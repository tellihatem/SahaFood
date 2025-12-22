import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class VouchersService {
  constructor(private readonly prisma: PrismaService) {}

  async validate(code: string, orderTotal: number) {
    const voucher = await this.prisma.voucher.findFirst({
      where: {
        code,
        is_active: true,
        expires_at: { gte: new Date() },
      },
    });

    if (!voucher) {
      throw new NotFoundException('رمز الخصم غير صالح أو منتهي الصلاحية');
    }

    if (orderTotal < voucher.min_order_value) {
      throw new NotFoundException(`الحد الأدنى للطلب ${voucher.min_order_value} دج`);
    }

    let discount = 0;
    if (voucher.discount_type === 'PERCENTAGE') {
      discount = (orderTotal * voucher.discount_value) / 100;
      if (voucher.max_discount && discount > voucher.max_discount) {
        discount = voucher.max_discount;
      }
    } else {
      discount = voucher.discount_value;
    }

    return {
      valid: true,
      voucher: {
        code: voucher.code,
        description: voucher.description,
        discountType: voucher.discount_type,
        discountValue: voucher.discount_value,
      },
      discount,
      newTotal: orderTotal - discount,
    };
  }

  async getActiveVouchers() {
    return this.prisma.voucher.findMany({
      where: {
        is_active: true,
        expires_at: { gte: new Date() },
      },
      select: {
        code: true,
        description: true,
        discount_type: true,
        discount_value: true,
        max_discount: true,
        min_order_value: true,
        expires_at: true,
      },
    });
  }
}
