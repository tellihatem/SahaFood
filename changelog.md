# Changelog

## [2024-12-22] - API Endpoints Implementation

### Added - Step 1: Authentication Flow
- `POST /auth/register` - Register new user with phone, name, email, password
- `POST /auth/login` - Password-based login
- `POST /auth/otp/send` - Send OTP to phone (rate limited: 3 per 5 min)
- `POST /auth/otp/verify` - Verify OTP and get tokens
- `POST /auth/refresh` - Refresh access token
- `GET /auth/me` - Get current user profile
- `PATCH /auth/profile` - Complete/update profile
- `POST /auth/logout` - Logout user

### Added - Step 2: Restaurant Discovery
- `GET /restaurants` - List restaurants with filtering:
  - `search` - Search by name, description, address
  - `category` - Filter by category
  - `sortBy` - Sort by rating, name, created_at
  - `sortOrder` - asc/desc
  - `minRating` - Minimum rating filter
  - `isOpen` - Filter by currently open
  - Pagination with `page` and `limit`
- `GET /restaurants/map` - Restaurants for map view with distance calculation
- `GET /restaurants/categories` - All unique categories
- `GET /restaurants/featured` - Top-rated restaurants

### Added - Step 3: Restaurant Details
- `GET /restaurants/:slug` - Full restaurant details with:
  - Menu grouped by category
  - Recent ratings with user info
  - Owner info
  - Ratings and foods count

### Added - Step 4: Shopping Cart
- `GET /cart` - Get cart with restaurant info, totals, minimum order check
- `POST /cart/items` - Add item with notes, price frozen at add time
- `PATCH /cart/items/:foodId` - Update quantity/notes
- `DELETE /cart/items/:foodId` - Remove item
- `DELETE /cart` - Clear cart
- `POST /cart/sync-prices` - Sync cart prices with current food prices
- Price change detection between frozen and current prices

### Added - Step 5: Checkout Process
- Address CRUD endpoints (already existed)
- `POST /vouchers/validate` - Validate voucher code
- `GET /vouchers` - Get active vouchers
- `POST /orders` - Create order from cart with:
  - Address validation
  - Minimum order check
  - Voucher application
  - Price freezing from cart
  - Transaction-based order creation
- `POST /orders/direct` - Create order without cart

### Added - Step 6: Order Tracking
- `GET /orders` - Order history with pagination and status filter
- `GET /orders/:id` - Order details
- `GET /orders/:id/track` - Full tracking with:
  - Driver live location from DeliveryProfile
  - Status timeline with timestamps
  - Estimated delivery time
  - Restaurant and delivery address coordinates
- `PATCH /orders/:id/cancel` - Cancel order with reason

---

## [2024-12-22] - Backend Setup with Prisma & PostgreSQL

### Added
- **Docker Setup**
  - `docker-compose.yml` with PostgreSQL 16 and Redis 7
  - Persistent volumes for data storage
  - Health checks for services

- **Prisma Schema** (`prisma/schema.prisma`)
  - User & Authentication models (User, RefreshToken, Otp)
  - Restaurant & Food models
  - Cart & CartItem models
  - Order, OrderItem, OrderStatusLog models
  - Address, Favorite, Rating models
  - Voucher & OrderVoucher models
  - Admin models (ChefApplication, PendingRestaurant, Advertisement, PendingPayment, UserReport, AuditLog)
  - DeliveryProfile and RestaurantDeliveryPerson junction table

- **NestJS Backend Structure**
  - Main application entry point with Swagger docs
  - Global configuration, validation, and security (Helmet, CORS)
  - PrismaService for database connection

- **Database Seeder** (`prisma/seed.ts`)
  - Sample admin, chef, delivery, and user accounts
  - Sample restaurant with foods
  - Sample voucher and advertisement

### Security
- JWT access and refresh token authentication
- OTP rate limiting (3 per 5 minutes)
- Password hashing with Argon2
- Role-based access control (user, chef, delivery, admin)
- Request validation with class-validator
- Rate limiting with @nestjs/throttler
