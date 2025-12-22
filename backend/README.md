# Sahhafood Backend API

Backend API for Sahhafood food delivery application built with NestJS, Prisma, and PostgreSQL.

## Prerequisites

- Node.js 18+
- Docker & Docker Compose
- npm or yarn

## Quick Start

### 1. Start Database Services

```bash
# Start PostgreSQL and Redis containers
npm run docker:up

# Or manually
docker-compose up -d
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Setup Database

```bash
# Generate Prisma client
npm run prisma:generate

# Run migrations
npm run prisma:migrate

# Seed database with sample data
npm run prisma:seed
```

### 4. Start Development Server

```bash
npm run start:dev
```

The API will be available at:
- **API**: http://localhost:3000/api/v1
- **Swagger Docs**: http://localhost:3000/docs

## Available Scripts

| Command | Description |
|---------|-------------|
| `npm run start:dev` | Start development server with hot reload |
| `npm run start:prod` | Start production server |
| `npm run build` | Build the application |
| `npm run prisma:generate` | Generate Prisma client |
| `npm run prisma:migrate` | Run database migrations |
| `npm run prisma:seed` | Seed database with sample data |
| `npm run prisma:studio` | Open Prisma Studio GUI |
| `npm run docker:up` | Start Docker containers |
| `npm run docker:down` | Stop Docker containers |

## API Endpoints

### Authentication
- `POST /api/v1/auth/otp/send` - Send OTP to phone
- `POST /api/v1/auth/otp/verify` - Verify OTP and login
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - Logout user

### Users
- `GET /api/v1/users/me` - Get current user profile
- `PATCH /api/v1/users/me` - Update profile
- `DELETE /api/v1/users/me` - Delete account

### Restaurants
- `GET /api/v1/restaurants` - List restaurants
- `GET /api/v1/restaurants/:slug` - Get restaurant details

### Foods
- `GET /api/v1/foods/search` - Search foods
- `GET /api/v1/foods/:id` - Get food details

### Cart
- `GET /api/v1/cart` - Get cart
- `POST /api/v1/cart/items` - Add item to cart
- `PATCH /api/v1/cart/items/:foodId` - Update item quantity
- `DELETE /api/v1/cart/items/:foodId` - Remove item
- `DELETE /api/v1/cart` - Clear cart

### Orders
- `POST /api/v1/orders` - Create order
- `GET /api/v1/orders` - Get user orders
- `GET /api/v1/orders/:id` - Get order details
- `PATCH /api/v1/orders/:id/cancel` - Cancel order

### Addresses
- `GET /api/v1/addresses` - Get user addresses
- `POST /api/v1/addresses` - Add address
- `PATCH /api/v1/addresses/:id` - Update address
- `DELETE /api/v1/addresses/:id` - Delete address

### Ratings
- `POST /api/v1/ratings` - Rate an order
- `GET /api/v1/ratings/restaurant/:id` - Get restaurant ratings

### Vouchers
- `GET /api/v1/vouchers` - Get active vouchers
- `POST /api/v1/vouchers/validate` - Validate voucher code

### Admin (requires admin role)
- `GET /api/v1/admin/dashboard` - Dashboard stats
- `GET /api/v1/admin/users` - List users
- `GET /api/v1/admin/chef-applications` - Pending applications
- `PATCH /api/v1/admin/chef-applications/:id/approve` - Approve
- `PATCH /api/v1/admin/chef-applications/:id/reject` - Reject

## Test Users (after seeding)

| Role | Phone | Password |
|------|-------|----------|
| Admin | +213555000001 | admin123456 |
| Chef | +213555000002 | chef123456 |
| Delivery | +213555000003 | delivery123456 |
| User | +213555000004 | user123456 |

## Environment Variables

See `.env.example` for all available environment variables.

## Project Structure

```
backend/
├── prisma/
│   ├── schema.prisma    # Database schema
│   └── seed.ts          # Database seeder
├── src/
│   ├── main.ts          # Application entry point
│   ├── app.module.ts    # Root module
│   ├── prisma/          # Prisma service
│   └── modules/
│       ├── auth/        # Authentication
│       ├── users/       # User management
│       ├── restaurants/ # Restaurants
│       ├── foods/       # Food items
│       ├── orders/      # Orders
│       ├── cart/        # Shopping cart
│       ├── addresses/   # User addresses
│       ├── ratings/     # Ratings & reviews
│       ├── vouchers/    # Promotions
│       ├── admin/       # Admin panel
│       └── health/      # Health check
├── docker-compose.yml   # Docker services
├── package.json
└── tsconfig.json
```

## Security Features

- JWT-based authentication with refresh tokens
- OTP verification via SMS/WhatsApp
- Password hashing with Argon2
- Rate limiting
- CORS protection
- Helmet security headers
- Role-based access control (RBAC)

## License

Private - Sahhafood Team
