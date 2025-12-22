import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class AddressesService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(userId: string) {
    return this.prisma.address.findMany({
      where: { user_id: userId },
      orderBy: [{ is_default: 'desc' }, { created_at: 'desc' }],
    });
  }

  async create(userId: string, data: {
    label: string;
    street: string;
    city: string;
    latitude: number;
    longitude: number;
    isDefault?: boolean;
  }) {
    if (data.isDefault) {
      await this.prisma.address.updateMany({
        where: { user_id: userId },
        data: { is_default: false },
      });
    }

    return this.prisma.address.create({
      data: {
        user_id: userId,
        label: data.label,
        street: data.street,
        city: data.city,
        latitude: data.latitude,
        longitude: data.longitude,
        is_default: data.isDefault ?? false,
      },
    });
  }

  async update(userId: string, id: string, data: {
    label?: string;
    street?: string;
    city?: string;
    latitude?: number;
    longitude?: number;
    isDefault?: boolean;
  }) {
    const address = await this.prisma.address.findFirst({
      where: { id, user_id: userId },
    });

    if (!address) throw new NotFoundException('العنوان غير موجود');

    if (data.isDefault) {
      await this.prisma.address.updateMany({
        where: { user_id: userId, id: { not: id } },
        data: { is_default: false },
      });
    }

    return this.prisma.address.update({
      where: { id },
      data: {
        label: data.label,
        street: data.street,
        city: data.city,
        latitude: data.latitude,
        longitude: data.longitude,
        is_default: data.isDefault,
      },
    });
  }

  async delete(userId: string, id: string) {
    const address = await this.prisma.address.findFirst({
      where: { id, user_id: userId },
    });

    if (!address) throw new NotFoundException('العنوان غير موجود');

    await this.prisma.address.delete({ where: { id } });
    return { message: 'تم حذف العنوان' };
  }

  async setDefault(userId: string, id: string) {
    const address = await this.prisma.address.findFirst({
      where: { id, user_id: userId },
    });

    if (!address) throw new NotFoundException('العنوان غير موجود');

    await this.prisma.address.updateMany({
      where: { user_id: userId },
      data: { is_default: false },
    });

    return this.prisma.address.update({
      where: { id },
      data: { is_default: true },
    });
  }
}
