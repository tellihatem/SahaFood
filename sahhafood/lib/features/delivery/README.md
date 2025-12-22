# Delivery Feature

## Overview
The delivery feature provides a complete interface for delivery personnel to manage their assigned orders from restaurants.

## Structure
```
delivery/
├── navigation/
│   └── delivery_navigation.dart    # Bottom navigation for delivery app
└── screens/
    ├── delivery_home_screen.dart   # Main screen with order list
    ├── delivery_order_details_screen.dart  # Order details with status management
    └── delivery_profile_screen.dart  # Delivery person profile
```

## Screens

### 1. DeliveryHomeScreen
- **Purpose**: Display all assigned orders with filtering by status
- **Features**:
  - Tab-based filtering (Pending, In Progress, Completed)
  - Order cards with key information
  - Empty state when no orders
  - Navigation to order details

### 2. DeliveryOrderDetailsScreen
- **Purpose**: Detailed view of a single order with actions
- **Features**:
  - Map view with navigation button (Google Maps integration)
  - Customer information with contact options
  - Call button (opens phone dialer)
  - Chat button (reuses ChatScreen from order feature)
  - Status update buttons:
    - "Start Delivery" (pending → on_way)
    - "Mark as Delivered" (on_way → delivered)
  - Order information display

### 3. DeliveryProfileScreen
- **Purpose**: Delivery person profile and settings
- **Features**:
  - Profile picture
  - Statistics (completed orders, rating)
  - Menu items (personal info, history, earnings, etc.)
  - Logout option

### 4. DeliveryNavigation
- **Purpose**: Bottom navigation wrapper
- **Features**:
  - Two tabs: Orders and Profile
  - Active state indication

## Design System
- **Primary Color**: #FF7622 (Orange)
- **Font**: Tajawal (Arabic RTL support)
- **Design Size**: 375x812 (iPhone 11 Pro)
- **Direction**: RTL (Right-to-Left)

## Reusable Components Used
- `ArabicText` - For all text display
- `CustomButton` - For action buttons
- `ChatScreen` - Reused from order feature

## Integration Points

### Chat Functionality
The delivery screens reuse the existing `ChatScreen` from `lib/features/order/screens/chat_screen.dart`.

### Phone Calls
Uses `url_launcher` package to initiate phone calls:
```dart
final url = Uri.parse('tel:+966500000000');
await launchUrl(url);
```

### Maps Navigation
Uses `url_launcher` to open Google Maps:
```dart
final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=Location');
await launchUrl(url, mode: LaunchMode.externalApplication);
```

## Status Flow
1. **pending** → Order assigned, waiting for delivery person to start
2. **on_way** → Delivery person picked up order and is en route
3. **delivered** → Order successfully delivered to customer

## Usage

### Navigate to Delivery Interface
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DeliveryNavigation(),
  ),
);
```

### Pass Order Data
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DeliveryOrderDetailsScreen(
      order: {
        'orderId': '#123456',
        'restaurantName': 'مطعم البيت العربي',
        'customerName': 'محمد أحمد',
        'customerAddress': 'شارع الملك فهد، الرياض',
        'orderTime': '14:30',
        'items': 3,
        'distance': '2.5 كم',
        'status': 'pending',
      },
    ),
  ),
);
```

## Future Enhancements
- Real-time location tracking with Google Maps SDK
- Push notifications for new orders
- In-app earnings tracking
- Order history with filters
- Customer ratings and feedback
- Real-time chat with Firebase
- Photo proof of delivery
- Route optimization
