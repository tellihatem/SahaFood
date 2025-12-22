import { Controller, Post, Get, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { VouchersService } from './vouchers.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('vouchers')
@Controller('vouchers')
export class VouchersController {
  constructor(private readonly vouchersService: VouchersService) {}

  @Post('validate')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Validate voucher code - التحقق من رمز الخصم' })
  async validate(@Body() body: { code: string; orderTotal: number }) {
    return this.vouchersService.validate(body.code, body.orderTotal);
  }

  @Get()
  @ApiOperation({ summary: 'Get active vouchers - العروض المتاحة' })
  async getActiveVouchers() {
    return this.vouchersService.getActiveVouchers();
  }
}
