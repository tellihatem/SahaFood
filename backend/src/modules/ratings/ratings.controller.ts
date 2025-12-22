import { Controller, Post, Get, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { RatingsService } from './ratings.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('ratings')
@Controller('ratings')
export class RatingsController {
  constructor(private readonly ratingsService: RatingsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Rate an order - تقييم الطلب' })
  async create(
    @CurrentUser('id') userId: string,
    @Body() body: { orderId: string; rating: number; comment?: string },
  ) {
    return this.ratingsService.create(userId, body.orderId, body.rating, body.comment);
  }

  @Get('restaurant/:restaurantId')
  @ApiOperation({ summary: 'Get restaurant ratings - تقييمات المطعم' })
  async getRestaurantRatings(
    @Param('restaurantId') restaurantId: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.ratingsService.getRestaurantRatings(restaurantId, page, limit);
  }
}
