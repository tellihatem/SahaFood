import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class AdminService {
  constructor(private readonly prisma: PrismaService) {}

  async getDashboardStats() {
    const [usersCount, restaurantsCount, ordersCount, pendingOrders] = await Promise.all([
      this.prisma.user.count(),
      this.prisma.restaurant.count(),
      this.prisma.order.count(),
      this.prisma.order.count({ where: { status: 'pending' } }),
    ]);

    return { usersCount, restaurantsCount, ordersCount, pendingOrders };
  }

  async getPendingChefApplications() {
    return this.prisma.chefApplication.findMany({
      where: { status: 'pending' },
      orderBy: { created_at: 'desc' },
    });
  }

  async approveChefApplication(applicationId: string, adminId: string) {
    const application = await this.prisma.chefApplication.update({
      where: { id: applicationId },
      data: {
        status: 'approved',
        reviewed_by: adminId,
        reviewed_at: new Date(),
      },
    });

    await this.prisma.user.update({
      where: { id: application.user_id },
      data: { role: 'chef' },
    });

    await this.logAction(adminId, 'approve_chef', 'chef_application', applicationId);
    return application;
  }

  async rejectChefApplication(applicationId: string, adminId: string, reason: string) {
    const application = await this.prisma.chefApplication.update({
      where: { id: applicationId },
      data: {
        status: 'rejected',
        rejection_reason: reason,
        reviewed_by: adminId,
        reviewed_at: new Date(),
      },
    });

    await this.logAction(adminId, 'reject_chef', 'chef_application', applicationId, { reason });
    return application;
  }

  async getUsers(page = 1, limit = 20, role?: string) {
    const skip = (page - 1) * limit;
    const where = role ? { role } : {};

    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip,
        take: limit,
        select: {
          id: true,
          phone: true,
          name: true,
          role: true,
          created_at: true,
        },
        orderBy: { created_at: 'desc' },
      }),
      this.prisma.user.count({ where }),
    ]);

    return { data: users, meta: { total, page, limit, totalPages: Math.ceil(total / limit) } };
  }

  private async logAction(adminId: string, action: string, entityType: string, entityId: string, details?: object) {
    return this.prisma.auditLog.create({
      data: {
        admin_id: adminId,
        action,
        entity_type: entityType,
        entity_id: entityId,
        details: details || {},
      },
    });
  }
}
