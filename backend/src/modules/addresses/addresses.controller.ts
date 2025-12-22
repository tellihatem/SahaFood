import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AddressesService } from './addresses.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('addresses')
@Controller('addresses')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth('JWT-auth')
export class AddressesController {
  constructor(private readonly addressesService: AddressesService) {}

  @Get()
  @ApiOperation({ summary: 'Get user addresses - عناويني' })
  async findAll(@CurrentUser('id') userId: string) {
    return this.addressesService.findAll(userId);
  }

  @Post()
  @ApiOperation({ summary: 'Add new address - إضافة عنوان' })
  async create(
    @CurrentUser('id') userId: string,
    @Body() body: { label: string; street: string; city: string; latitude: number; longitude: number; isDefault?: boolean },
  ) {
    return this.addressesService.create(userId, body);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update address - تحديث العنوان' })
  async update(
    @CurrentUser('id') userId: string,
    @Param('id') id: string,
    @Body() body: { label?: string; street?: string; city?: string; latitude?: number; longitude?: number; isDefault?: boolean },
  ) {
    return this.addressesService.update(userId, id, body);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete address - حذف العنوان' })
  async delete(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.addressesService.delete(userId, id);
  }

  @Patch(':id/default')
  @ApiOperation({ summary: 'Set as default address - تعيين كعنوان افتراضي' })
  async setDefault(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.addressesService.setDefault(userId, id);
  }
}
