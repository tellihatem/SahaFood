import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class FoodsService {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string) {
    const food = await this.prisma.food.findUnique({
      where: { id },
      include: {
        restaurant: {
          select: {
            id: true,
            name: true,
            slug: true,
          },
        },
      },
    });

    if (!food) {
      throw new NotFoundException('الطعام غير موجود');
    }

    return food;
  }

  async search(query: {
    page?: number;
    limit?: number;
    search?: string;
    category?: string;
    minPrice?: number;
    maxPrice?: number;
  }) {
    const { page = 1, limit = 10, search, category, minPrice, maxPrice } = query;
    const skip = (page - 1) * limit;

    const where: any = { is_available: true };

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (category) {
      where.categories = { contains: category, mode: 'insensitive' };
    }

    if (minPrice !== undefined || maxPrice !== undefined) {
      where.price = {};
      if (minPrice !== undefined) where.price.gte = minPrice;
      if (maxPrice !== undefined) where.price.lte = maxPrice;
    }

    const [foods, total] = await Promise.all([
      this.prisma.food.findMany({
        where,
        skip,
        take: limit,
        include: {
          restaurant: {
            select: { id: true, name: true, slug: true },
          },
        },
        orderBy: { created_at: 'desc' },
      }),
      this.prisma.food.count({ where }),
    ]);

    return {
      data: foods,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}
