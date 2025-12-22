import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class CartService {
  constructor(private readonly prisma: PrismaService) {}

  async getCart(userId: string) {
    const cart = await this.prisma.cart.findUnique({
      where: { user_id: userId },
      include: {
        restaurant: {
          select: {
            id: true,
            name: true,
            slug: true,
            image_url: true,
            minimum_order: true,
            delivery_fee: true,
            delivery_time_min: true,
            delivery_time_max: true,
          },
        },
        items: {
          include: {
            food: {
              select: { 
                id: true, 
                name: true, 
                price: true, 
                image_url: true, 
                is_available: true,
                description: true,
              },
            },
          },
          orderBy: { created_at: 'asc' },
        },
      },
    });

    if (!cart) {
      return { 
        items: [], 
        subtotal: 0, 
        deliveryFee: 0,
        total: 0,
        itemsCount: 0,
      };
    }

    // Check for unavailable items
    const unavailableItems = cart.items.filter(item => !item.food.is_available);
    
    const subtotal = cart.items
      .filter(item => item.food.is_available)
      .reduce((sum, item) => sum + item.price * item.quantity, 0);
    
    const deliveryFee = cart.restaurant?.delivery_fee || 0;
    const minimumOrder = cart.restaurant?.minimum_order || 0;
    const itemsCount = cart.items.reduce((sum, item) => sum + item.quantity, 0);

    return {
      id: cart.id,
      restaurant: cart.restaurant,
      items: cart.items.map(item => ({
        id: item.id,
        foodId: item.food_id,
        name: item.food.name,
        description: item.food.description,
        image: item.food.image_url,
        quantity: item.quantity,
        unitPrice: item.price,
        currentPrice: item.food.price,
        priceChanged: item.price !== item.food.price,
        totalPrice: item.price * item.quantity,
        isAvailable: item.food.is_available,
        notes: item.notes,
      })),
      subtotal,
      deliveryFee,
      total: subtotal + deliveryFee,
      itemsCount,
      minimumOrder,
      meetsMinimum: subtotal >= minimumOrder,
      unavailableItems: unavailableItems.length,
    };
  }

  async addItem(userId: string, foodId: string, quantity: number, notes?: string) {
    if (quantity <= 0) {
      throw new BadRequestException('الكمية يجب أن تكون أكبر من صفر');
    }

    const food = await this.prisma.food.findUnique({
      where: { id: foodId },
      include: { restaurant: { select: { id: true, name: true } } },
    });

    if (!food) {
      throw new NotFoundException('الطعام غير موجود');
    }

    if (!food.is_available) {
      throw new BadRequestException('هذا الطعام غير متوفر حالياً');
    }

    let cart = await this.prisma.cart.findUnique({ where: { user_id: userId } });

    if (cart && cart.restaurant_id !== food.restaurant_id) {
      throw new BadRequestException(
        `لا يمكن إضافة أطعمة من مطاعم مختلفة. السلة تحتوي على طلبات من مطعم آخر. قم بإفراغ السلة أولاً`
      );
    }

    if (!cart) {
      cart = await this.prisma.cart.create({
        data: {
          user_id: userId,
          restaurant_id: food.restaurant_id,
        },
      });
    }

    const existingItem = await this.prisma.cartItem.findUnique({
      where: { cart_id_food_id: { cart_id: cart.id, food_id: foodId } },
    });

    if (existingItem) {
      await this.prisma.cartItem.update({
        where: { id: existingItem.id },
        data: { 
          quantity: existingItem.quantity + quantity,
          notes: notes || existingItem.notes,
        },
      });
    } else {
      // Price is frozen at the time of adding to cart
      await this.prisma.cartItem.create({
        data: {
          cart_id: cart.id,
          food_id: foodId,
          quantity,
          price: food.price, // Frozen price
          notes,
        },
      });
    }

    return this.getCart(userId);
  }

  async updateItem(userId: string, foodId: string, quantity: number, notes?: string) {
    const cart = await this.prisma.cart.findUnique({ where: { user_id: userId } });
    if (!cart) throw new NotFoundException('السلة فارغة');

    if (quantity <= 0) {
      return this.removeItem(userId, foodId);
    }

    const item = await this.prisma.cartItem.findUnique({
      where: { cart_id_food_id: { cart_id: cart.id, food_id: foodId } },
    });

    if (!item) {
      throw new NotFoundException('العنصر غير موجود في السلة');
    }

    await this.prisma.cartItem.update({
      where: { id: item.id },
      data: { 
        quantity,
        ...(notes !== undefined && { notes }),
      },
    });

    return this.getCart(userId);
  }

  async removeItem(userId: string, foodId: string) {
    const cart = await this.prisma.cart.findUnique({ where: { user_id: userId } });
    if (!cart) throw new NotFoundException('السلة فارغة');

    try {
      await this.prisma.cartItem.delete({
        where: { cart_id_food_id: { cart_id: cart.id, food_id: foodId } },
      });
    } catch {
      throw new NotFoundException('العنصر غير موجود في السلة');
    }

    const remainingItems = await this.prisma.cartItem.count({ where: { cart_id: cart.id } });
    if (remainingItems === 0) {
      await this.prisma.cart.delete({ where: { id: cart.id } });
    }

    return this.getCart(userId);
  }

  async clearCart(userId: string) {
    const cart = await this.prisma.cart.findUnique({ where: { user_id: userId } });
    if (cart) {
      await this.prisma.cartItem.deleteMany({ where: { cart_id: cart.id } });
      await this.prisma.cart.delete({ where: { id: cart.id } });
    }
    return { message: 'تم إفراغ السلة', items: [], total: 0 };
  }

  async syncPrices(userId: string) {
    // Update cart item prices to current food prices
    const cart = await this.prisma.cart.findUnique({
      where: { user_id: userId },
      include: {
        items: {
          include: { food: true },
        },
      },
    });

    if (!cart) return this.getCart(userId);

    for (const item of cart.items) {
      if (item.price !== item.food.price) {
        await this.prisma.cartItem.update({
          where: { id: item.id },
          data: { price: item.food.price },
        });
      }
    }

    return this.getCart(userId);
  }
}
