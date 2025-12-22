import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse, ApiBody } from '@nestjs/swagger';
import { CartService } from './cart.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('cart')
@Controller('cart')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth('JWT-auth')
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Get()
  @ApiOperation({ summary: 'Get cart - عرض السلة' })
  @ApiResponse({ status: 200, description: 'Cart with items, totals, and restaurant info' })
  async getCart(@CurrentUser('id') userId: string) {
    return this.cartService.getCart(userId);
  }

  @Post('items')
  @ApiOperation({ summary: 'Add item to cart - إضافة للسلة' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['foodId', 'quantity'],
      properties: {
        foodId: { type: 'string', description: 'Food ID' },
        quantity: { type: 'number', minimum: 1, description: 'Quantity to add' },
        notes: { type: 'string', description: 'Special instructions (optional)' },
      },
    },
  })
  @ApiResponse({ status: 200, description: 'Updated cart' })
  @ApiResponse({ status: 400, description: 'Cannot add items from different restaurants' })
  @ApiResponse({ status: 404, description: 'Food not found' })
  async addItem(
    @CurrentUser('id') userId: string,
    @Body() body: { foodId: string; quantity: number; notes?: string },
  ) {
    return this.cartService.addItem(userId, body.foodId, body.quantity, body.notes);
  }

  @Patch('items/:foodId')
  @ApiOperation({ summary: 'Update item quantity/notes - تحديث الكمية' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['quantity'],
      properties: {
        quantity: { type: 'number', minimum: 0, description: 'New quantity (0 to remove)' },
        notes: { type: 'string', description: 'Special instructions' },
      },
    },
  })
  @ApiResponse({ status: 200, description: 'Updated cart' })
  async updateItem(
    @CurrentUser('id') userId: string,
    @Param('foodId') foodId: string,
    @Body() body: { quantity: number; notes?: string },
  ) {
    return this.cartService.updateItem(userId, foodId, body.quantity, body.notes);
  }

  @Delete('items/:foodId')
  @ApiOperation({ summary: 'Remove item from cart - حذف من السلة' })
  @ApiResponse({ status: 200, description: 'Updated cart' })
  async removeItem(@CurrentUser('id') userId: string, @Param('foodId') foodId: string) {
    return this.cartService.removeItem(userId, foodId);
  }

  @Delete()
  @ApiOperation({ summary: 'Clear cart - إفراغ السلة' })
  @ApiResponse({ status: 200, description: 'Cart cleared' })
  async clearCart(@CurrentUser('id') userId: string) {
    return this.cartService.clearCart(userId);
  }

  @Post('sync-prices')
  @ApiOperation({ summary: 'Sync cart prices with current food prices - مزامنة الأسعار' })
  @ApiResponse({ status: 200, description: 'Cart with updated prices' })
  async syncPrices(@CurrentUser('id') userId: string) {
    return this.cartService.syncPrices(userId);
  }
}
