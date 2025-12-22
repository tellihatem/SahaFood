# 🏗️ Sahhafood Project Architecture Analysis

## 📋 Executive Summary

**Sahhafood** is a multi-role food delivery Flutter application built with a **feature-based architecture** using **Riverpod** for state management. The project is currently in a **frontend-only state** with mock data, designed to be easily connected to a backend API layer.

### Key Characteristics
- **Language**: Dart/Flutter (SDK ^3.9.2)
- **State Management**: Riverpod (hooks_riverpod ^2.3.6)
- **Architecture Pattern**: Feature-based modular architecture
- **UI Framework**: Material 3 with Arabic RTL support
- **Design System**: Responsive design using flutter_screenutil (375x812 base)
- **Primary Color**: #FF7622 (Orange)
- **Localization**: Arabic (ar_SA) with Tajawal font family

---

## 🏛️ Architecture Overview

### Project Structure

```
sahhafood/
├── lib/
│   ├── core/                          # Core application utilities
│   │   ├── constants/                 # Design system constants
│   │   │   ├── app_colors.dart       # Color palette
│   │   │   ├── app_dimensions.dart   # Spacing, sizes, radii
│   │   │   ├── app_text_styles.dart  # Typography system
│   │   │   └── constants.dart        # Barrel export
│   │   ├── services/                  # Shared services
│   │   │   └── user_role_service.dart # Role management (mock)
│   │   ├── theme/                     # Theme configuration
│   │   ├── utils/                     # Helper utilities
│   │   └── widgets/                   # Legacy widgets
│   │
│   ├── features/                      # Feature modules
│   │   ├── auth/                      # Authentication ✅ REFACTORED
│   │   ├── home/                      # Restaurant browsing
│   │   ├── cart/                      # Shopping cart
│   │   ├── order/                     # Order management
│   │   ├── profile/                   # User profile
│   │   ├── chef/                      # Chef role features
│   │   ├── delivery/                  # Delivery driver features
│   │   ├── favorites/                 # Favorites management
│   │   ├── promo/                     # Promotions & offers
│   │   ├── navigation/                # Main app navigation
│   │   └── onboarding/                # Onboarding screens
│   │
│   ├── shared/                        # Shared UI components
│   │   └── widgets/                   # Reusable widgets
│   │
│   └── main.dart                      # App entry point
```

### Feature-Based Architecture

Each feature follows this structure:
```
feature_name/
├── models/          # Data models (immutable, with copyWith & JSON)
├── providers/       # State management (Riverpod StateNotifiers)
└── ui/              # User interface
    ├── screens/     # Full-page screens
    └── widgets/     # Feature-specific widgets
```

---

## 🎯 State Management Pattern

### Riverpod Implementation

```dart
// 1. State Class (Immutable)
class FeatureState {
  final List<Data> items;
  final bool isLoading;
  final String? error;
  
  const FeatureState({
    required this.items,
    this.isLoading = false,
    this.error
  });
  
  FeatureState copyWith({...}) => FeatureState(...);
}

// 2. Notifier (Business Logic)
class FeatureNotifier extends StateNotifier<FeatureState> {
  FeatureNotifier() : super(FeatureState.initial());
  
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    // TODO: Replace with API call
    await Future.delayed(Duration(seconds: 1));
    state = state.copyWith(items: mockData, isLoading: false);
  }
}

// 3. Provider (Exposure to UI)
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>(
  (ref) => FeatureNotifier()
);
```

**Key Characteristics:**
- ✅ Immutable state objects
- ✅ `copyWith` pattern for state updates
- ✅ Separation of concerns (State/Logic/UI)
- ✅ Mock data with TODO comments for API integration
- ✅ Error handling structure in place

---

## 📦 Feature Modules

### ✅ Auth Feature (Fully Refactored)

**Models:** `UserModel`, `UserRole` enum

**Providers:**
- `AuthNotifier` - Login, signup, logout, role management
- `authProvider`, `isLoggedInProvider`, `userRoleProvider`

**UI Screens:**
- ✅ Login, Location Access, Role Selection
- ⏳ Signup, Forgot Password, Verification (placeholders)

**Backend Integration Point:**
```dart
// Current: Mock validation
Future<bool> login({required String phoneNumber, required String password}) {
  await Future.delayed(const Duration(seconds: 1));
  if (phoneNumber.length == 9 && password.length >= 6) {
    state = UserModel(...);
    return true;
  }
  return false;
}

// Future: API call
Future<bool> login({required String phoneNumber, required String password}) {
  final response = await _authApiService.login(phoneNumber, password);
  if (response.success) {
    state = UserModel.fromJson(response.data);
    return true;
  }
  return false;
}
```

---

### 🏠 Home Feature

**Models:** `Restaurant`, `MenuItem`, `Category`, `Banner`, `FilterCriteria`

**Providers (7 total):**
1. `restaurant_provider` - Restaurant listing & filtering
2. `category_provider` - Category management
3. `menu_provider` - Menu items
4. `search_provider` - Search functionality
5. `filter_provider` - Advanced filtering
6. `banner_provider` - Banner carousel
7. `quick_filter_provider` - Quick filters

**UI Screens:** Home, Search, Restaurant View, Food Details, Filter

---

### 🛒 Cart Feature

**Models:** `CartItem`, `CartState`

**Key Methods:**
- `addItem()`, `removeItem()`
- `incrementQuantity()`, `decrementQuantity()`
- `placeOrder()`, `clearCart()`

---

### 📦 Order Feature

**Models:** `Order`, `OrderItem`, `OrderStatus` enum

**Key Methods:**
- `loadOrders()`, `cancelOrder()`
- `reorder()`, `rateOrder()`

---

### 👨‍🍳 Chef Feature

Chef dashboard, menu management, running orders, messages, reviews

---

### 🚚 Delivery Feature

Delivery dashboard, earnings, history, settings, support

---

## 🎨 Design System

### Constants

**Colors:** Primary (#FF7622), backgrounds, text colors, status colors

**Dimensions:** Spacing (4-48), border radius (8-24), icon sizes, button heights

**Typography:** Tajawal (Arabic), Sen (English), predefined text styles

### Shared Widgets

1. `CustomButton` - Styled button with loading state
2. `ArabicText` - RTL-optimized text widget
3. `CustomTextField` - Styled input field
4. `DropdownField` - Dropdown selector
5. `SectionHeader` - Consistent section headers
6. `BannerCarousel` - Image carousel

---

## 🔌 Backend Integration Strategy

### Current State

- ✅ All models have `fromJson()` and `toJson()` methods
- ✅ Providers have TODO comments marking API integration points
- ✅ Mock data simulates real API responses
- ✅ Error handling structure in place
- ✅ Loading states implemented

### Recommended Approach: API Service Layer

Create a dedicated API service layer between providers and backend.

#### Step 1: Create API Infrastructure

```
lib/core/
├── api/
│   ├── api_client.dart           # HTTP client wrapper (Dio)
│   ├── api_config.dart           # Base URLs, endpoints
│   ├── api_interceptor.dart      # Auth tokens, logging
│   └── api_exception.dart        # Error handling
└── services/
    ├── auth_api_service.dart
    ├── restaurant_api_service.dart
    ├── cart_api_service.dart
    ├── order_api_service.dart
    └── ...
```

#### Step 2: API Client Implementation

```dart
// api_client.dart
class ApiClient {
  final Dio _dio;
  
  ApiClient({String? baseUrl}) : _dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? ApiConfig.baseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  )) {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    try {
      return await _dio.get(path, queryParameters: params);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
  
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

#### Step 3: API Configuration

```dart
// api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://api.sahhafood.com/v1';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  
  // Restaurant endpoints
  static const String restaurants = '/restaurants';
  static const String restaurantDetails = '/restaurants/:id';
  
  // Order endpoints
  static const String orders = '/orders';
  static const String placeOrder = '/orders/place';
}
```

#### Step 4: API Services

```dart
// auth_api_service.dart
class AuthApiService {
  final ApiClient _apiClient;
  
  AuthApiService(this._apiClient);
  
  Future<UserModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.login,
      data: {'phone_number': phoneNumber, 'password': password},
    );
    return UserModel.fromJson(response.data['user']);
  }
}

// restaurant_api_service.dart
class RestaurantApiService {
  final ApiClient _apiClient;
  
  RestaurantApiService(this._apiClient);
  
  Future<List<Restaurant>> getRestaurants({
    String? query,
    FilterCriteria? filters,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.restaurants,
      params: {
        if (query != null) 'query': query,
        if (filters != null) ...filters.toQueryParams(),
      },
    );
    return (response.data['restaurants'] as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
  }
}
```

#### Step 5: Update Providers

```dart
// Riverpod providers for API services
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.read(apiClientProvider));
});

// Update existing AuthNotifier
class AuthNotifier extends StateNotifier<UserModel> {
  final AuthApiService _authApiService;
  
  AuthNotifier(this._authApiService) : super(UserModel.guest());
  
  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final user = await _authApiService.login(
        phoneNumber: phoneNumber,
        password: password,
      );
      state = user;
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Provider with dependency injection
final authProvider = StateNotifierProvider<AuthNotifier, UserModel>((ref) {
  final authApiService = ref.read(authApiServiceProvider);
  return AuthNotifier(authApiService);
});
```

#### Step 6: Authentication & Token Management

```dart
// auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, refresh or logout
    }
    handler.next(err);
  }
}

// token_storage.dart
class TokenStorage {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }
  
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
```

#### Step 7: Error Handling

```dart
// api_exception.dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException({required this.message, this.statusCode});
  
  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(message: 'انتهت مهلة الاتصال');
      case DioExceptionType.badResponse:
        return ApiException(
          message: _getErrorMessage(error.response?.statusCode),
          statusCode: error.response?.statusCode,
        );
      default:
        return ApiException(message: 'حدث خطأ غير متوقع');
    }
  }
  
  static String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400: return 'طلب غير صالح';
      case 401: return 'يرجى تسجيل الدخول مرة أخرى';
      case 404: return 'المورد غير موجود';
      case 500: return 'خطأ في الخادم';
      default: return 'حدث خطأ غير متوقع';
    }
  }
}
```

---

## ✅ Migration Checklist

### Phase 1: Setup (Week 1)
- [ ] Add dependencies: `dio`, `shared_preferences`
- [ ] Create `lib/core/api/` directory structure
- [ ] Implement `ApiClient` with Dio
- [ ] Create `ApiConfig` with all endpoints
- [ ] Implement `ApiException` for error handling

### Phase 2: Authentication (Week 1-2)
- [ ] Create `AuthApiService`
- [ ] Implement token storage
- [ ] Add `AuthInterceptor` for token management
- [ ] Update `AuthNotifier` to use API service
- [ ] Test login/signup/logout flows

### Phase 3: Core Features (Week 2-3)
- [ ] Create `RestaurantApiService`
- [ ] Create `CartApiService`
- [ ] Create `OrderApiService`
- [ ] Update respective providers
- [ ] Test each feature individually

### Phase 4: Additional Features (Week 3-4)
- [ ] Create `ProfileApiService`
- [ ] Create `ChefApiService`
- [ ] Create `DeliveryApiService`
- [ ] Update respective providers

### Phase 5: Testing & Optimization (Week 4)
- [ ] Integration testing
- [ ] Error handling verification
- [ ] Performance optimization
- [ ] Add caching (optional)

---

## 🎯 Key Advantages of Current Architecture

1. **Clean Separation**: UI, logic, and data are clearly separated
2. **Backend-Ready**: Models already have JSON serialization
3. **Scalable**: Feature-based structure scales well
4. **Testable**: Providers can be easily mocked
5. **Maintainable**: Consistent patterns across features
6. **Type-Safe**: Strong typing with Dart
7. **Reactive**: Riverpod provides reactive state management

---

## 📝 Recommendations

### Immediate Actions
1. Complete auth feature refactoring (signup, forgot password screens)
2. Add `dio` and `shared_preferences` dependencies
3. Create API layer infrastructure
4. Start with auth API integration as proof of concept

### Best Practices
1. Keep API services thin - only handle HTTP calls
2. Keep business logic in providers
3. Use dependency injection via Riverpod
4. Handle errors at provider level
5. Cache frequently accessed data
6. Implement retry logic for failed requests
7. Add request/response logging for debugging

### Future Enhancements
1. Implement offline support with local database (Hive/Drift)
2. Add real-time updates (WebSockets/Firebase)
3. Implement push notifications
4. Add analytics and crash reporting
5. Implement CI/CD pipeline

---

## 📊 Project Metrics

- **Total Features**: 11 (auth, home, cart, order, profile, chef, delivery, favorites, promo, navigation, onboarding)
- **Refactored Features**: 1 (auth - 100%)
- **Providers**: 15+ across all features
- **Shared Widgets**: 6 reusable components
- **Design Constants**: 3 files (colors, dimensions, typography)
- **Lines of Code**: ~10,000+ (estimated)

---

## 🚀 Conclusion

The Sahhafood project has a **solid, well-structured frontend architecture** that is **ready for backend integration**. The feature-based structure, combined with Riverpod state management and comprehensive design system, provides an excellent foundation for scaling.

The recommended API service layer approach will enable **smooth backend integration** without major refactoring. All models are already serializable, providers have clear integration points, and the architecture supports dependency injection.

**Estimated Backend Integration Timeline**: 3-4 weeks for full integration with proper testing.
