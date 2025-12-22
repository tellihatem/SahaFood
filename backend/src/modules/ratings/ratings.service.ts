import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class RatingsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(userId: string, orderId: string, rating: number, comment?: string) {
    const order = await this.prisma.order.findFirst({
      where: { id: orderId, user_id: userId, status: 'delivered' },
    });

    if (!order) {
      throw new NotFoundException('الطلب غير موجود أو لم يتم توصيله بعد');
    }

    const existingRating = await this.prisma.rating.findUnique({
      where: { order_id: orderId },
    });

    if (existingRating) {
      throw new BadRequestException('تم تقييم هذا الطلب مسبقاً');
    }

    const newRating = await this.prisma.rating.create({
      data: {
        user_id: userId,
        order_id: orderId,
        restaurant_id: order.restaurant_id,
        rating,
        comment,
      },
    });

    // Update restaurant average rating
    const avgRating = await this.prisma.rating.aggregate({
      where: { restaurant_id: order.restaurant_id },
      _avg: { rating: true },
    });

    await this.prisma.restaurant.update({
      where: { id: order.restaurant_id },
      data: { rating: avgRating._avg.rating || 0 },
    });

    return newRating;
  }

  async getRestaurantRatings(restaurantId: string, page = 1, limit = 10) {
    const skip = (page - 1) * limit;

    const [ratings, total] = await Promise.all([
      this.prisma.rating.findMany({
        where: { restaurant_id: restaurantId },
        skip,
        take: limit,
        orderBy: { created_at: 'desc' },
        include: {
          user: { select: { name: true, profile_image: true } },
        },
      }),
      this.prisma.rating.count({ where: { restaurant_id: restaurantId } }),
    ]);

    return { data: ratings, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
  }
}
