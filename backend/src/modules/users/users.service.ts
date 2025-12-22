import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        phone: true,
        name: true,
        gender: true,
        birthdate: true,
        profile_image: true,
        role: true,
        created_at: true,
      },
    });

    if (!user) {
      throw new NotFoundException('المستخدم غير موجود');
    }

    return user;
  }

  async update(id: string, dto: UpdateUserDto) {
    await this.findById(id);

    return this.prisma.user.update({
      where: { id },
      data: dto,
      select: {
        id: true,
        phone: true,
        name: true,
        gender: true,
        birthdate: true,
        profile_image: true,
        role: true,
      },
    });
  }

  async softDelete(id: string) {
    await this.findById(id);

    return this.prisma.user.update({
      where: { id },
      data: { deleted_at: new Date() },
    });
  }
}
