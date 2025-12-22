import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiResponse } from '@nestjs/swagger';
import { RestaurantsService } from './restaurants.service';

@ApiTags('restaurants')
@Controller('restaurants')
export class RestaurantsController {
  constructor(private readonly restaurantsService: RestaurantsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all restaurants - قائمة المطاعم' })
  @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number (default: 1)' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Items per page (default: 10)' })
  @ApiQuery({ name: 'search', required: false, type: String, description: 'Search by name, description, or address' })
  @ApiQuery({ name: 'category', required: false, type: String, description: 'Filter by category' })
  @ApiQuery({ name: 'sortBy', required: false, enum: ['rating', 'name', 'created_at'], description: 'Sort field' })
  @ApiQuery({ name: 'sortOrder', required: false, enum: ['asc', 'desc'], description: 'Sort order' })
  @ApiQuery({ name: 'minRating', required: false, type: Number, description: 'Minimum rating filter' })
  @ApiQuery({ name: 'isOpen', required: false, type: Boolean, description: 'Filter by currently open' })
  @ApiResponse({ status: 200, description: 'List of restaurants with pagination' })
  async findAll(
    @Query('page') page?: number,
    @Query('limit') limit?: number,
    @Query('search') search?: string,
    @Query('category') category?: string,
    @Query('sortBy') sortBy?: 'rating' | 'name' | 'created_at',
    @Query('sortOrder') sortOrder?: 'asc' | 'desc',
    @Query('minRating') minRating?: number,
    @Query('isOpen') isOpen?: boolean,
  ) {
    return this.restaurantsService.findAll({ 
      page: page ? Number(page) : undefined, 
      limit: limit ? Number(limit) : undefined, 
      search, 
      category,
      sortBy,
      sortOrder,
      minRating: minRating ? Number(minRating) : undefined,
      isOpen,
    });
  }

  @Get('map')
  @ApiOperation({ summary: 'Get restaurants for map view - المطاعم على الخريطة' })
  @ApiQuery({ name: 'latitude', required: true, type: Number, description: 'User latitude' })
  @ApiQuery({ name: 'longitude', required: true, type: Number, description: 'User longitude' })
  @ApiQuery({ name: 'radius', required: false, type: Number, description: 'Search radius in km (default: 10)' })
  @ApiQuery({ name: 'category', required: false, type: String, description: 'Filter by category' })
  @ApiResponse({ status: 200, description: 'List of nearby restaurants with distance' })
  async findForMap(
    @Query('latitude') latitude: number,
    @Query('longitude') longitude: number,
    @Query('radius') radius?: number,
    @Query('category') category?: string,
  ) {
    return this.restaurantsService.findForMap({ 
      latitude: Number(latitude), 
      longitude: Number(longitude), 
      radius: radius ? Number(radius) : undefined,
      category,
    });
  }

  @Get('categories')
  @ApiOperation({ summary: 'Get all restaurant categories - التصنيفات' })
  @ApiResponse({ status: 200, description: 'List of unique categories' })
  async getCategories() {
    return this.restaurantsService.getCategories();
  }

  @Get('featured')
  @ApiOperation({ summary: 'Get featured restaurants - المطاعم المميزة' })
  @ApiResponse({ status: 200, description: 'List of top-rated restaurants' })
  async getFeatured() {
    return this.restaurantsService.getFeatured();
  }

  @Get(':slug')
  @ApiOperation({ summary: 'Get restaurant by slug with full menu - تفاصيل المطعم مع القائمة' })
  @ApiResponse({ status: 200, description: 'Restaurant details with menu grouped by category' })
  @ApiResponse({ status: 404, description: 'Restaurant not found' })
  async findBySlug(@Param('slug') slug: string) {
    return this.restaurantsService.findBySlug(slug);
  }
}
