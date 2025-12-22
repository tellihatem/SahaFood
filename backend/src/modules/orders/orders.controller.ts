import { Controller, Get, Post, Patch, Param, Body, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery, ApiResponse, ApiBody } from '@nestjs/swagger';
import { OrdersService } from './orders.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('orders')
@Controller('orders')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth('JWT-auth')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post()
  @ApiOperation({ summary: 'Create order from cart - إنشاء طلب من السلة' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['addressId'],
      properties: {
        addressId: { type: 'string', description: 'Delivery address ID' },
        notes: { type: 'string', description: 'Order notes (optional)' },
        voucherCode: { type: 'string', description: 'Voucher code (optional)' },
        paymentMethod: { type: 'string', enum: ['cash', 'card'], default: 'cash' },
      },
    },
  })
  @ApiResponse({ status: 201, description: 'Order created successfully' })
  @ApiResponse({ status: 400, description: 'Cart empty or validation error' })
  async createFromCart(
    @CurrentUser('id') userId: string,
    @Body() body: { addressId: string; notes?: string; voucherCode?: string; paymentMethod?: 'cash' | 'card' },
  ) {
    return this.ordersService.createFromCart(userId, body);
  }

  @Post('direct')
  @ApiOperation({ summary: 'Create order directly (without cart) - طلب مباشر' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['restaurantId', 'addressId', 'items'],
      properties: {
        restaurantId: { type: 'string' },
        addressId: { type: 'string' },
        items: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              foodId: { type: 'string' },
              quantity: { type: 'number' },
              notes: { type: 'string' },
            },
          },
        },
        notes: { type: 'string' },
        voucherCode: { type: 'string' },
        paymentMethod: { type: 'string', enum: ['cash', 'card'] },
      },
    },
  })
  @ApiResponse({ status: 201, description: 'Order created successfully' })
  async createDirect(
    @CurrentUser('id') userId: string,
    @Body() body: {
      restaurantId: string;
      addressId: string;
      items: { foodId: string; quantity: number; notes?: string }[];
      notes?: string;
      voucherCode?: string;
      paymentMethod?: 'cash' | 'card';
    },
  ) {
    return this.ordersService.createDirect(userId, body);
  }

  @Get()
  @ApiOperation({ summary: 'Get user orders - طلباتي' })
  @ApiQuery({ name: 'status', required: false, description: 'Filter by status' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'List of orders with pagination' })
  async findAll(
    @CurrentUser('id') userId: string,
    @Query('status') status?: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.ordersService.findUserOrders(userId, { 
      status, 
      page: page ? Number(page) : undefined,
      limit: limit ? Number(limit) : undefined,
    });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get order details - تفاصيل الطلب' })
  @ApiResponse({ status: 200, description: 'Order details' })
  @ApiResponse({ status: 404, description: 'Order not found' })
  async findOne(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.ordersService.findById(id, userId);
  }

  @Get(':id/track')
  @ApiOperation({ summary: 'Track order with driver location - تتبع الطلب' })
  @ApiResponse({ status: 200, description: 'Order tracking info with driver location and status timeline' })
  async trackOrder(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.ordersService.trackOrder(id, userId);
  }

  @Patch(':id/cancel')
  @ApiOperation({ summary: 'Cancel order - إلغاء الطلب' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        reason: { type: 'string', description: 'Cancellation reason (optional)' },
      },
    },
  })
  @ApiResponse({ status: 200, description: 'Order cancelled' })
  @ApiResponse({ status: 400, description: 'Cannot cancel order at this stage' })
  async cancel(
    @CurrentUser('id') userId: string,
    @Param('id') id: string,
    @Body() body: { reason?: string },
  ) {
    return this.ordersService.cancelOrder(id, userId, body.reason);
  }
}
