# Chef/Seller Interface Implementation

## Overview
This implementation adds a complete chef/seller interface to the Sahhafood app, allowing you to test both client and chef experiences without a backend.

## Architecture

### Role Management System
- **Location**: `lib/core/services/user_role_service.dart`
- **Purpose**: Mock service to manage user roles (Client/Chef) for testing
- **Features**:
  - Switch between client and chef roles
  - Singleton pattern for global access
  - ChangeNotifier for reactive updates

### Chef Feature Structure
```
lib/features/chef/
├── navigation/
│   └── chef_navigation_screen.dart    # Main navigation for chef interface
└── screens/
    ├── chef_dashboard_screen.dart      # Dashboard with stats & revenue
    ├── chef_running_orders_screen.dart # Manage running orders
    ├── chef_food_list_screen.dart      # View all menu items
    ├── chef_add_item_screen.dart       # Add new food items
    ├── chef_food_details_screen.dart   # View food item details
    ├── chef_profile_screen.dart        # Chef profile with balance
    ├── chef_notifications_screen.dart  # Notifications
    ├── chef_messages_screen.dart       # Customer messages
    └── chef_reviews_screen.dart        # Customer reviews
```

## Screens Implemented

### 1. Chef Dashboard
- **Route**: `/chef/home` (default tab)
- **Features**:
  - Running orders count
  - Order requests count
  - Revenue chart
  - Reviews summary (4.9 rating)
  - Popular items this week

### 2. Running Orders
- **Route**: `/chef/running-orders`
- **Features**:
  - List of active orders
  - Order details (ID, item, price)
  - Done/Cancel actions
  - Real-time order count

### 3. Food List
- **Route**: Chef navigation tab
- **Features**:
  - Category filters (All, Breakfast, Lunch, Dinner)
  - Food items with ratings
  - Out of stock indicators
  - Item count display

### 4. Add New Item
- **Route**: `/chef/add-item`
- **Features**:
  - Item name input
  - Photo/Video upload placeholders
  - Price with pickup/delivery options
  - Highlights selection (Hot, Vegan, Organic, etc.)
  - Fruits/Ingredients selection
  - Description field

### 5. Food Details
- **Route**: `/chef/food-details`
- **Features**:
  - Food image
  - Category badges
  - Price and rating
  - Ingredients display
  - Description
  - Edit button

### 6. Chef Profile
- **Route**: Chef navigation tab
- **Features**:
  - Available balance display ($500.00)
  - Withdraw button
  - Personal info
  - Settings
  - Withdrawal history
  - Order count (29K)
  - User reviews
  - Logout (returns to role selection)

### 7. Notifications
- **Route**: Chef navigation tab
- **Features**:
  - Tabs: Notifications & Messages
  - Customer order notifications
  - Time stamps
  - Order images

### 8. Messages
- **Route**: `/chef/messages`
- **Features**:
  - Customer message list
  - Unread count badges
  - Message preview
  - Time stamps

### 9. Reviews
- **Route**: `/chef/reviews`
- **Features**:
  - Customer reviews list
  - Star ratings
  - Review text
  - Date stamps
  - Reviewer info

## Navigation

### Chef Bottom Navigation
1. **Home** - Dashboard
2. **Menu** - Food List
3. **Add** (Center) - Quick actions menu
4. **Notifications** - Notifications & Messages
5. **Profile** - Chef Profile

### Quick Actions Menu (Center Button)
- Add new dish
- View running orders
- Messages
- Reviews

## How to Test

### 1. Start the App
```bash
flutter run
```

### 2. Navigate Through Onboarding
- Complete the onboarding screens
- Click "ابدأ الآن" (Start Now)

### 3. Login
- Enter any phone number (9 digits starting with 6 or 7)
- Enter any password (6+ characters)
- Click "تسجيل الدخول" (Login)

### 4. Select Role
You'll see the **Role Selection Screen** with two options:
- **عميل (Client)**: Browse restaurants and order food
- **طاهي / بائع (Chef/Seller)**: Manage restaurant, orders, and menu

### 5. Switch Between Roles
- From Chef Profile → Click "تسجيل الخروج" (Logout)
- You'll return to Role Selection
- Choose a different role to test

## Routes Available

### Client Routes
- `/home` - Client main navigation
- `/location` - Location access screen

### Chef Routes
- `/chef/home` - Chef main navigation
- `/chef/add-item` - Add new food item
- `/chef/running-orders` - Running orders list
- `/chef/messages` - Messages screen
- `/chef/reviews` - Reviews screen
- `/chef/food-details` - Food details screen

### Common Routes
- `/role-selection` - Role selection for testing

## Design Consistency

All chef screens follow the app's design system:
- **Primary Color**: #FF7622 (Orange)
- **RTL Support**: Full Arabic right-to-left layout
- **Responsive**: Using flutter_screenutil (375x812 base)
- **Typography**: Tajawal font family
- **Clean UI**: Consistent spacing and styling

## Mock Data

All screens use mock data for testing:
- Order counts and IDs
- Food items and prices
- Customer names and messages
- Reviews and ratings
- Revenue statistics

## Future Backend Integration

When implementing the backend:

1. **Replace UserRoleService** with actual authentication
2. **Add API calls** in each screen for real data
3. **Implement state management** (Provider, Riverpod, or Bloc)
4. **Add real-time updates** for orders and messages
5. **Implement image upload** functionality
6. **Add payment integration** for withdrawals

## Notes

- The role selection screen is for **testing purposes only**
- In production, user roles should be determined by backend authentication
- All images are placeholders (gray boxes) - replace with actual images
- Form validations are basic - enhance for production use
- No data persistence - all changes are lost on app restart

## Color Scheme

- **Primary**: #FF7622 (Orange)
- **Text Dark**: #32343E
- **Text Light**: #9CA3AF
- **Background**: #FFFFFF (White)
- **Border**: #E5E7EB
- **Success**: #4CAF50
- **Error**: #EF4444

## Support

For questions or issues with the chef interface implementation, refer to the Figma designs or check the individual screen files for implementation details.
