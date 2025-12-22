import { Controller, Get, Post, Patch, Param, Body, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('admin')
@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin')
@ApiBearerAuth('JWT-auth')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('dashboard')
  @ApiOperation({ summary: 'Get dashboard stats - إحصائيات لوحة التحكم' })
  async getDashboardStats() {
    return this.adminService.getDashboardStats();
  }

  @Get('chef-applications')
  @ApiOperation({ summary: 'Get pending chef applications - طلبات الشيف المعلقة' })
  async getPendingChefApplications() {
    return this.adminService.getPendingChefApplications();
  }

  @Patch('chef-applications/:id/approve')
  @ApiOperation({ summary: 'Approve chef application - قبول طلب الشيف' })
  async approveChefApplication(
    @Param('id') id: string,
    @CurrentUser('id') adminId: string,
  ) {
    return this.adminService.approveChefApplication(id, adminId);
  }

  @Patch('chef-applications/:id/reject')
  @ApiOperation({ summary: 'Reject chef application - رفض طلب الشيف' })
  async rejectChefApplication(
    @Param('id') id: string,
    @CurrentUser('id') adminId: string,
    @Body() body: { reason: string },
  ) {
    return this.adminService.rejectChefApplication(id, adminId, body.reason);
  }

  @Get('users')
  @ApiOperation({ summary: 'Get all users - قائمة المستخدمين' })
  async getUsers(
    @Query('page') page?: number,
    @Query('limit') limit?: number,
    @Query('role') role?: string,
  ) {
    return this.adminService.getUsers(page, limit, role);
  }
}
