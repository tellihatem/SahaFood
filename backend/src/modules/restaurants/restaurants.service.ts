import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

export interface RestaurantQueryDto {
  page?: number;
  limit?: number;
  search?: string;
  category?: string;
  sortBy?: 'rating' | 'name' | 'created_at';
  sortOrder?: 'asc' | 'desc';
  minRating?: number;
  isOpen?: boolean;
}

export interface MapQueryDto {
  latitude: number;
  longitude: number;
  radius?: number; // in kilometers
  category?: string;
}

@Injectable()
export class RestaurantsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(query: RestaurantQueryDto) {
    const { 
      page = 1, 
      limit = 10, 
      search, 
      category, 
      sortBy = 'rating', 
      sortOrder = 'desc',
      minRating,
      isOpen,
    } = query;
    const skip = (page - 1) * limit;

    const where: any = { is_active: true };

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
        { address: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (category) {
      where.categories = { has: category };
    }

    if (minRating) {
      where.rating = { gte: minRating };
    }

    // Check if restaurant is currently open
    if (isOpen !== undefined) {
      const now = new Date();
      const currentDay = now.toLocaleDateString('en-US', { weekday: 'long' }).toLowerCase();
      const currentTime = now.toTimeString().slice(0, 5); // HH:MM format
      
      // This is a simplified check - in production you'd want more sophisticated logic
      if (isOpen) {
        where.opening_hours = {
          path: [currentDay],
          not: null,
        };
      }
    }

    // Build orderBy
    const orderBy: any = {};
    orderBy[sortBy] = sortOrder;

    const [restaurants, total] = await Promise.all([
      this.prisma.restaurant.findMany({
        where,
        skip,
        take: limit,
        orderBy,
        select: {
          id: true,
          name: true,
          slug: true,
          description: true,
          address: true,
          image_url: true,
          rating: true,
          categories: true,
          opening_hours: true,
          latitude: true,
          longitude: true,
          delivery_time_min: true,
          delivery_time_max: true,
          minimum_order: true,
          delivery_fee: true,
          _count: {
            select: { ratings: true },
          },
        },
      }),
      this.prisma.restaurant.count({ where }),
    ]);

    return {
      data: restaurants.map(r => ({
        ...r,
        ratingsCount: r._count.ratings,
        _count: undefined,
      })),
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findForMap(query: MapQueryDto) {
    const { latitude, longitude, radius = 10, category } = query;

    const where: any = { 
      is_active: true,
      latitude: { not: null },
      longitude: { not: null },
    };

    if (category) {
      where.categories = { has: category };
    }

    // Get all restaurants with coordinates
    const restaurants = await this.prisma.restaurant.findMany({
      where,
      select: {
        id: true,
        name: true,
        slug: true,
        address: true,
        image_url: true,
        rating: true,
        categories: true,
        latitude: true,
        longitude: true,
        opening_hours: true,
        delivery_time_min: true,
        delivery_time_max: true,
      },
    });

    // Filter by distance using Haversine formula
    const filteredRestaurants = restaurants.filter(restaurant => {
      if (!restaurant.latitude || !restaurant.longitude) return false;
      const distance = this.calculateDistance(
        latitude,
        longitude,
        restaurant.latitude,
        restaurant.longitude,
      );
      return distance <= radius;
    });

    // Add distance to each restaurant
    const restaurantsWithDistance = filteredRestaurants.map(restaurant => ({
      ...restaurant,
      distance: this.calculateDistance(
        latitude,
        longitude,
        restaurant.latitude!,
        restaurant.longitude!,
      ),
    }));

    // Sort by distance
    restaurantsWithDistance.sort((a, b) => a.distance - b.distance);

    return {
      data: restaurantsWithDistance,
      meta: {
        total: restaurantsWithDistance.length,
        center: { latitude, longitude },
        radius,
      },
    };
  }

  async findBySlug(slug: string) {
    const restaurant = await this.prisma.restaurant.findUnique({
      where: { slug },
      include: {
        foods: {
          where: { is_available: true },
          orderBy: [
            { categories: 'asc' },
            { name: 'asc' },
          ],
        },
        ratings: {
          take: 10,
          orderBy: { created_at: 'desc' },
          include: {
            user: {
              select: { name: true, profile_image: true },
            },
          },
        },
        owner: {
          select: { id: true, name: true, profile_image: true },
        },
        _count: {
          select: { ratings: true, foods: true },
        },
      },
    });

    if (!restaurant) {
      throw new NotFoundException('المطعم غير موجود');
    }

    // Group foods by category
    const menuByCategory = this.groupFoodsByCategory(restaurant.foods);

    return {
      ...restaurant,
      menu: menuByCategory,
      ratingsCount: restaurant._count.ratings,
      foodsCount: restaurant._count.foods,
      _count: undefined,
    };
  }

  async findById(id: string) {
    const restaurant = await this.prisma.restaurant.findUnique({
      where: { id },
    });

    if (!restaurant) {
      throw new NotFoundException('المطعم غير موجود');
    }

    return restaurant;
  }

  async getCategories() {
    // Get all unique categories from active restaurants
    const restaurants = await this.prisma.restaurant.findMany({
      where: { is_active: true },
      select: { categories: true },
    });

    const categoriesSet = new Set<string>();
    restaurants.forEach(r => {
      r.categories.forEach(c => categoriesSet.add(c));
    });

    return Array.from(categoriesSet).sort();
  }

  async getFeatured() {
    // Get top-rated restaurants
    const featured = await this.prisma.restaurant.findMany({
      where: { 
        is_active: true,
        rating: { gte: 4 },
      },
      take: 10,
      orderBy: { rating: 'desc' },
      select: {
        id: true,
        name: true,
        slug: true,
        description: true,
        image_url: true,
        rating: true,
        categories: true,
        delivery_time_min: true,
        delivery_time_max: true,
      },
    });

    return featured;
  }

  private groupFoodsByCategory(foods: any[]) {
    const grouped: Record<string, any[]> = {};
    
    foods.forEach(food => {
      const category = food.categories || 'أخرى';
      if (!grouped[category]) {
        grouped[category] = [];
      }
      grouped[category].push(food);
    });

    return Object.entries(grouped).map(([category, items]) => ({
      category,
      items,
    }));
  }

  private calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    const R = 6371; // Earth's radius in kilometers
    const dLat = this.toRad(lat2 - lat1);
    const dLon = this.toRad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRad(lat1)) * Math.cos(this.toRad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return Math.round(R * c * 10) / 10; // Round to 1 decimal place
  }

  private toRad(deg: number): number {
    return deg * (Math.PI / 180);
  }
}
