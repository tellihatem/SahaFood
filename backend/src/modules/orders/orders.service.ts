import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

export interface CreateOrderDto {
  addressId: string;
  notes?: string;
  voucherCode?: string;
  paymentMethod?: 'cash' | 'card';
}

export interface CreateOrderFromCartDto extends CreateOrderDto {}

export interface CreateOrderDirectDto extends CreateOrderDto {
  restaurantId: string;
  items: { foodId: string; quantity: number; notes?: string }[];
}

@Injectable()
export class OrdersService {
  constructor(private readonly prisma: PrismaService) {}

  // Create order from user's cart
  async createFromCart(userId: string, data: CreateOrderFromCartDto) {
    // Get user's cart
    const cart = await this.prisma.cart.findUnique({
      where: { user_id: userId },
      include: {
        restaurant: true,
        items: {
          include: { food: true },
        },
      },
    });

    if (!cart || cart.items.length === 0) {
      throw new BadRequestException('السلة فارغة');
    }

    // Check for unavailable items
    const unavailableItems = cart.items.filter(item => !item.food.is_available);
    if (unavailableItems.length > 0) {
      throw new BadRequestException(
        `بعض الأطعمة غير متوفرة: ${unavailableItems.map(i => i.food.name).join(', ')}`
      );
    }

    // Validate address
    const address = await this.prisma.address.findFirst({
      where: { id: data.addressId, user_id: userId },
    });
    if (!address) throw new NotFoundException('العنوان غير موجود');

    // Check minimum order
    const subtotal = cart.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    if (cart.restaurant.minimum_order && subtotal < cart.restaurant.minimum_order) {
      throw new BadRequestException(
        `الحد الأدنى للطلب هو ${cart.restaurant.minimum_order} دج`
      );
    }

    // Calculate delivery fee
    const deliveryFee = cart.restaurant.delivery_fee || 0;

    // Apply voucher
    let voucherDiscount = 0;
    let voucherId: string | null = null;
    if (data.voucherCode) {
      const voucherResult = await this.applyVoucher(data.voucherCode, subtotal);
      voucherDiscount = voucherResult.discount;
      voucherId = voucherResult.voucherId;
    }

    const total = subtotal + deliveryFee - voucherDiscount;

    // Create order items from cart
    const orderItems = cart.items.map(item => ({
      food_id: item.food_id,
      name: item.food.name,
      quantity: item.quantity,
      price: item.price, // Use frozen price from cart
      notes: item.notes,
    }));

    // Create order in transaction
    const order = await this.prisma.$transaction(async (tx) => {
      // Create order
      const newOrder = await tx.order.create({
        data: {
          user_id: userId,
          restaurant_id: cart.restaurant_id,
          delivery_address_id: data.addressId,
          subtotal,
          delivery_fee: deliveryFee,
          voucher_discount: voucherDiscount,
          total,
          notes: data.notes,
          payment_method: data.paymentMethod || 'cash',
          status: 'pending',
          items: {
            create: orderItems,
          },
          status_logs: {
            create: {
              from_status: 'new',
              to_status: 'pending',
              changed_by: userId,
            },
          },
        },
        include: {
          items: true,
          restaurant: { select: { id: true, name: true, slug: true, image_url: true, phone: true } },
          delivery_address: true,
        },
      });

      // Link voucher to order if used
      if (voucherId) {
        await tx.orderVoucher.create({
          data: {
            order_id: newOrder.id,
            voucher_id: voucherId,
            discount_applied: voucherDiscount,
          },
        });
      }

      // Clear cart
      await tx.cartItem.deleteMany({ where: { cart_id: cart.id } });
      await tx.cart.delete({ where: { id: cart.id } });

      return newOrder;
    });

    return {
      ...order,
      message: 'تم إنشاء الطلب بنجاح',
    };
  }

  // Create order directly (without cart)
  async createDirect(userId: string, data: CreateOrderDirectDto) {
    // Validate restaurant
    const restaurant = await this.prisma.restaurant.findUnique({
      where: { id: data.restaurantId },
    });
    if (!restaurant || !restaurant.is_active) {
      throw new NotFoundException('المطعم غير موجود أو غير متاح');
    }

    // Validate address
    const address = await this.prisma.address.findFirst({
      where: { id: data.addressId, user_id: userId },
    });
    if (!address) throw new NotFoundException('العنوان غير موجود');

    // Get foods and validate
    const foodIds = data.items.map(i => i.foodId);
    const foods = await this.prisma.food.findMany({
      where: {
        id: { in: foodIds },
        restaurant_id: data.restaurantId,
        is_available: true,
      },
    });

    if (foods.length !== data.items.length) {
      const foundIds = foods.map(f => f.id);
      const missingIds = foodIds.filter(id => !foundIds.includes(id));
      throw new BadRequestException(`بعض الأطعمة غير متوفرة أو لا تنتمي لهذا المطعم`);
    }

    // Calculate subtotal
    let subtotal = 0;
    const orderItems = data.items.map(item => {
      const food = foods.find(f => f.id === item.foodId)!;
      subtotal += food.price * item.quantity;
      return {
        food_id: food.id,
        name: food.name,
        quantity: item.quantity,
        price: food.price,
        notes: item.notes,
      };
    });

    // Check minimum order
    if (restaurant.minimum_order && subtotal < restaurant.minimum_order) {
      throw new BadRequestException(`الحد الأدنى للطلب هو ${restaurant.minimum_order} دج`);
    }

    const deliveryFee = restaurant.delivery_fee || 0;

    // Apply voucher
    let voucherDiscount = 0;
    let voucherId: string | null = null;
    if (data.voucherCode) {
      const voucherResult = await this.applyVoucher(data.voucherCode, subtotal);
      voucherDiscount = voucherResult.discount;
      voucherId = voucherResult.voucherId;
    }

    const total = subtotal + deliveryFee - voucherDiscount;

    // Create order
    const order = await this.prisma.$transaction(async (tx) => {
      const newOrder = await tx.order.create({
        data: {
          user_id: userId,
          restaurant_id: data.restaurantId,
          delivery_address_id: data.addressId,
          subtotal,
          delivery_fee: deliveryFee,
          voucher_discount: voucherDiscount,
          total,
          notes: data.notes,
          payment_method: data.paymentMethod || 'cash',
          status: 'pending',
          items: {
            create: orderItems,
          },
          status_logs: {
            create: {
              from_status: 'new',
              to_status: 'pending',
              changed_by: userId,
            },
          },
        },
        include: {
          items: true,
          restaurant: { select: { id: true, name: true, slug: true, image_url: true } },
          delivery_address: true,
        },
      });

      if (voucherId) {
        await tx.orderVoucher.create({
          data: {
            order_id: newOrder.id,
            voucher_id: voucherId,
            discount_applied: voucherDiscount,
          },
        });
      }

      return newOrder;
    });

    return { ...order, message: 'تم إنشاء الطلب بنجاح' };
  }

  async findUserOrders(userId: string, query: { status?: string; page?: number; limit?: number }) {
    const { status, page = 1, limit = 10 } = query;
    const skip = (page - 1) * limit;

    const where: any = { user_id: userId };
    if (status) where.status = status;

    const [orders, total] = await Promise.all([
      this.prisma.order.findMany({
        where,
        skip,
        take: limit,
        include: {
          items: true,
          restaurant: { select: { id: true, name: true, slug: true, image_url: true } },
        },
        orderBy: { created_at: 'desc' },
      }),
      this.prisma.order.count({ where }),
    ]);

    return {
      data: orders,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  async findById(id: string, userId?: string) {
    const order = await this.prisma.order.findUnique({
      where: { id },
      include: {
        items: true,
        restaurant: {
          select: {
            id: true,
            name: true,
            slug: true,
            image_url: true,
            phone: true,
            address: true,
            latitude: true,
            longitude: true,
          },
        },
        delivery_address: true,
        delivery_person: {
          select: {
            id: true,
            name: true,
            phone: true,
            profile_image: true,
          },
        },
        status_logs: {
          orderBy: { changed_at: 'desc' },
        },
      },
    });

    if (!order) throw new NotFoundException('الطلب غير موجود');
    if (userId && order.user_id !== userId) {
      throw new NotFoundException('الطلب غير موجود');
    }

    return order;
  }

  // Get order tracking with delivery driver location
  async trackOrder(orderId: string, userId: string) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: {
        items: true,
        restaurant: {
          select: {
            id: true,
            name: true,
            image_url: true,
            phone: true,
            latitude: true,
            longitude: true,
          },
        },
        delivery_address: true,
        delivery_person: {
          select: {
            id: true,
            name: true,
            phone: true,
            profile_image: true,
          },
        },
        status_logs: {
          orderBy: { changed_at: 'asc' },
        },
      },
    });

    if (!order) throw new NotFoundException('الطلب غير موجود');
    if (order.user_id !== userId) {
      throw new NotFoundException('الطلب غير موجود');
    }

    // Get delivery driver's live location if assigned
    let driverLocation = null;
    if (order.delivery_person_id) {
      const deliveryProfile = await this.prisma.deliveryProfile.findUnique({
        where: { user_id: order.delivery_person_id },
        select: {
          current_latitude: true,
          current_longitude: true,
          is_available: true,
        },
      });

      if (deliveryProfile) {
        driverLocation = {
          latitude: deliveryProfile.current_latitude,
          longitude: deliveryProfile.current_longitude,
          isActive: deliveryProfile.is_available,
        };
      }
    }

    // Calculate estimated delivery time based on status
    const estimatedDelivery = this.calculateEstimatedDelivery(order);

    // Build status timeline
    const statusTimeline = this.buildStatusTimeline(order.status_logs, order.status);

    return {
      id: order.id,
      orderNumber: order.id.slice(-8).toUpperCase(),
      status: order.status,
      statusText: this.getStatusText(order.status),
      restaurant: order.restaurant,
      deliveryAddress: order.delivery_address,
      items: order.items,
      subtotal: order.subtotal,
      deliveryFee: order.delivery_fee,
      voucherDiscount: order.voucher_discount,
      total: order.total,
      paymentMethod: order.payment_method,
      notes: order.notes,
      createdAt: order.created_at,
      deliveryPerson: order.delivery_person,
      driverLocation,
      estimatedDelivery,
      statusTimeline,
      canCancel: ['pending', 'confirmed'].includes(order.status),
    };
  }

  async updateStatus(orderId: string, status: string, changedBy: string, notes?: string) {
    const order = await this.prisma.order.findUnique({ where: { id: orderId } });
    if (!order) throw new NotFoundException('الطلب غير موجود');

    // Validate status transition
    const validTransitions: Record<string, string[]> = {
      pending: ['confirmed', 'cancelled'],
      confirmed: ['preparing', 'cancelled'],
      preparing: ['ready', 'cancelled'],
      ready: ['picked_up'],
      picked_up: ['on_the_way'],
      on_the_way: ['delivered'],
      delivered: [],
      cancelled: [],
    };

    if (!validTransitions[order.status]?.includes(status)) {
      throw new BadRequestException(`لا يمكن تغيير الحالة من ${order.status} إلى ${status}`);
    }

    return this.prisma.order.update({
      where: { id: orderId },
      data: {
        status,
        ...(status === 'delivered' && { delivered_at: new Date() }),
        status_logs: {
          create: {
            from_status: order.status,
            to_status: status,
            changed_by: changedBy,
            notes,
          },
        },
      },
      include: {
        items: true,
        restaurant: { select: { name: true, image_url: true } },
      },
    });
  }

  async cancelOrder(orderId: string, userId: string, reason?: string) {
    const order = await this.findById(orderId, userId);

    if (!['pending', 'confirmed'].includes(order.status)) {
      throw new BadRequestException('لا يمكن إلغاء هذا الطلب بعد بدء التحضير');
    }

    return this.updateStatus(orderId, 'cancelled', userId, reason);
  }

  async assignDeliveryPerson(orderId: string, deliveryPersonId: string, assignedBy: string) {
    const order = await this.prisma.order.findUnique({ where: { id: orderId } });
    if (!order) throw new NotFoundException('الطلب غير موجود');

    // Verify delivery person exists and is available
    const deliveryProfile = await this.prisma.deliveryProfile.findUnique({
      where: { user_id: deliveryPersonId },
    });

    if (!deliveryProfile || !deliveryProfile.is_available) {
      throw new BadRequestException('عامل التوصيل غير متاح');
    }

    return this.prisma.order.update({
      where: { id: orderId },
      data: {
        delivery_person_id: deliveryPersonId,
        status_logs: {
          create: {
            from_status: order.status,
            to_status: order.status,
            changed_by: assignedBy,
            notes: `تم تعيين عامل التوصيل`,
          },
        },
      },
    });
  }

  private async applyVoucher(code: string, subtotal: number) {
    const voucher = await this.prisma.voucher.findFirst({
      where: {
        code,
        is_active: true,
        expires_at: { gte: new Date() },
        min_order_value: { lte: subtotal },
      },
    });

    if (!voucher) {
      throw new BadRequestException('رمز الخصم غير صالح أو منتهي الصلاحية');
    }

    let discount = 0;
    if (voucher.discount_type === 'PERCENTAGE') {
      discount = (subtotal * voucher.discount_value) / 100;
      if (voucher.max_discount && discount > voucher.max_discount) {
        discount = voucher.max_discount;
      }
    } else {
      discount = Math.min(voucher.discount_value, subtotal);
    }

    return { discount, voucherId: voucher.id };
  }

  private calculateEstimatedDelivery(order: any) {
    if (['delivered', 'cancelled'].includes(order.status)) {
      return null;
    }

    const now = new Date();
    let minutesToAdd = 45; // Default estimate

    switch (order.status) {
      case 'pending':
        minutesToAdd = 50;
        break;
      case 'confirmed':
        minutesToAdd = 40;
        break;
      case 'preparing':
        minutesToAdd = 30;
        break;
      case 'ready':
        minutesToAdd = 20;
        break;
      case 'picked_up':
      case 'on_the_way':
        minutesToAdd = 15;
        break;
    }

    return new Date(now.getTime() + minutesToAdd * 60000);
  }

  private buildStatusTimeline(statusLogs: any[], currentStatus: string) {
    const allStatuses = [
      { key: 'pending', label: 'تم استلام الطلب', icon: 'receipt' },
      { key: 'confirmed', label: 'تم تأكيد الطلب', icon: 'check-circle' },
      { key: 'preparing', label: 'جاري التحضير', icon: 'chef-hat' },
      { key: 'ready', label: 'جاهز للاستلام', icon: 'package' },
      { key: 'picked_up', label: 'تم الاستلام', icon: 'bike' },
      { key: 'on_the_way', label: 'في الطريق', icon: 'navigation' },
      { key: 'delivered', label: 'تم التوصيل', icon: 'check-double' },
    ];

    const statusOrder = allStatuses.map(s => s.key);
    const currentIndex = statusOrder.indexOf(currentStatus);

    return allStatuses.map((status, index) => {
      const log = statusLogs.find(l => l.to_status === status.key);
      return {
        ...status,
        completed: index <= currentIndex && currentStatus !== 'cancelled',
        current: status.key === currentStatus,
        timestamp: log?.changed_at || null,
      };
    });
  }

  private getStatusText(status: string): string {
    const statusTexts: Record<string, string> = {
      pending: 'في انتظار التأكيد',
      confirmed: 'تم التأكيد',
      preparing: 'جاري التحضير',
      ready: 'جاهز للاستلام',
      picked_up: 'تم الاستلام من المطعم',
      on_the_way: 'في الطريق إليك',
      delivered: 'تم التوصيل',
      cancelled: 'ملغي',
    };
    return statusTexts[status] || status;
  }
}
