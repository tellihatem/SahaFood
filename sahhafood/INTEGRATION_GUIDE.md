# 🔗 Quick Integration Guide - Favorites & Promo Codes

## 🎯 Step-by-Step Integration

### **Step 1: Add Favorite Button to Home Screen Restaurant Cards**

Open `lib/features/home/ui/screens/home_screen.dart` and add the favorite button:

```dart
// At the top, add import:
import '../../../favorites/ui/widgets/widgets.dart';
import '../../../favorites/models/models.dart';

// In _buildRestaurantCard method, wrap the restaurant image Container with Stack:
Stack(
  children: [
    // Existing restaurant image Container
    Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusLarge),
          topRight: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      child: ClipRRect(
        // ... existing image code
      ),
    ),
    
    // ADD THIS: Favorite button
    Positioned(
      top: 8,
      left: 8,
      child: FavoriteButton(
        itemId: restaurant.id,
        type: FavoriteType.restaurant,
        size: 20,
      ),
    ),
  ],
),
```

### **Step 2: Add Favorite Button to "Near You" Cards**

In the same file, find `_NearYouCard` widget and add:

```dart
// In the Stack where the distance badge is:
Stack(
  children: [
    // Existing image ClipRRect
    ClipRRect(
      // ... existing code
    ),
    
    // Existing distance badge
    if (restaurant.distanceKm != null)
      Positioned(
        top: 8,
        left: 8,
        // ... existing distance badge code
      ),
    
    // ADD THIS: Favorite button on the right
    Positioned(
      top: 8,
      right: 8,
      child: FavoriteButton(
        itemId: restaurant.id,
        type: FavoriteType.restaurant,
        size: 18,
      ),
    ),
  ],
),
```

### **Step 3: Add Navigation to Favorites Screen**

Add a favorites button to your app. You can add it to:

**Option A: Profile Screen**
```dart
// In profile screen, add a menu item:
ListTile(
  leading: Icon(Icons.favorite, color: AppColors.primary),
  title: ArabicText(
    text: 'المفضلة',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  ),
  trailing: Icon(Icons.arrow_back_ios, size: 16),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  },
),
```

**Option B: Home Screen Header**
```dart
// In home screen header, add icon button:
IconButton(
  icon: Icon(
    Icons.favorite_border,
    size: AppDimensions.iconLarge,
    color: AppColors.textPrimary,
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  },
),
```

### **Step 4: Add Promo Codes Button to Home Screen**

Add a promo section after the banner carousel:

```dart
// In home_screen.dart, after the banner carousel:
SizedBox(height: AppDimensions.spacing16),

// ADD THIS: Promo codes banner
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PromoCodesScreen(),
      ),
    );
  },
  child: Container(
    margin: EdgeInsets.symmetric(
      horizontal: AppDimensions.spacing24,
    ),
    padding: EdgeInsets.all(AppDimensions.spacing16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.primary,
          AppColors.primary.withOpacity(0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
    ),
    child: Row(
      children: [
        Icon(
          Icons.local_offer,
          color: AppColors.white,
          size: 24,
        ),
        SizedBox(width: AppDimensions.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArabicText(
                text: 'عروض وخصومات حصرية',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
              SizedBox(height: 2),
              ArabicText(
                text: 'اكتشف أفضل العروض',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.white.withOpacity(0.9),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
          size: 16,
        ),
      ],
    ),
  ),
),
```

### **Step 5: Add Promo Input to Cart Screen**

Open `lib/features/cart/ui/screens/cart_screen.dart`:

```dart
// At the top, add imports:
import '../../../promo/ui/widgets/widgets.dart';
import '../../../promo/providers/providers.dart';

// In the build method, before the order summary:
// ADD THIS: Promo input widget
PromoInputWidget(
  orderAmount: totalAmount, // Use your cart total variable
),

SizedBox(height: AppDimensions.spacing16),

// Then your existing order summary
```

### **Step 6: Calculate Discount in Cart**

Update your cart total calculation:

```dart
// In cart screen, add this to calculate discount:
final promoState = ref.watch(promoProvider);
final discount = ref.read(promoProvider.notifier)
    .calculateDiscount(totalAmount);
final deliveryFee = promoState.appliedPromo?.type == PromoType.freeDelivery 
    ? 0.0 
    : 200.0; // Your delivery fee

final finalTotal = totalAmount - discount + deliveryFee;

// Then display in your order summary:
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ArabicText(
      text: 'المجموع الفرعي',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
    ArabicText(
      text: '${totalAmount.toInt()} دج',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  ],
),

if (discount > 0) ...[
  SizedBox(height: 8),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ArabicText(
        text: 'الخصم',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.success,
      ),
      ArabicText(
        text: '- ${discount.toInt()} دج',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      ),
    ],
  ),
],

SizedBox(height: 8),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ArabicText(
      text: 'رسوم التوصيل',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
    ArabicText(
      text: deliveryFee == 0 ? 'مجاني' : '${deliveryFee.toInt()} دج',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: deliveryFee == 0 ? AppColors.success : AppColors.textPrimary,
    ),
  ],
),

Divider(height: 24),

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ArabicText(
      text: 'المجموع الكلي',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    ArabicText(
      text: '${finalTotal.toInt()} دج',
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
    ),
  ],
),
```

### **Step 7: Add Imports to Main Files**

Make sure to add these imports where needed:

```dart
// For Favorites:
import 'package:sahhafood/features/favorites/ui/screens/favorites_screen.dart';
import 'package:sahhafood/features/favorites/ui/widgets/widgets.dart';
import 'package:sahhafood/features/favorites/models/models.dart';
import 'package:sahhafood/features/favorites/providers/providers.dart';

// For Promo Codes:
import 'package:sahhafood/features/promo/ui/screens/promo_codes_screen.dart';
import 'package:sahhafood/features/promo/ui/widgets/widgets.dart';
import 'package:sahhafood/features/promo/models/models.dart';
import 'package:sahhafood/features/promo/providers/providers.dart';
```

---

## 🎨 Optional Enhancements

### **Add Favorite Count Badge**

```dart
// In your navigation or profile icon:
Stack(
  children: [
    IconButton(
      icon: Icon(Icons.favorite_border),
      onPressed: () { /* navigate to favorites */ },
    ),
    Positioned(
      top: 8,
      right: 8,
      child: Consumer(
        builder: (context, ref, child) {
          final count = ref.watch(favoritesProvider).favorites.length;
          if (count == 0) return const SizedBox.shrink();
          
          return Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: AppColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
    ),
  ],
),
```

### **Add Active Promo Count Badge**

```dart
// Similar to favorites count:
Consumer(
  builder: (context, ref, child) {
    final activeCount = ref.watch(promoProvider).activePromoCodes.length;
    
    return Badge(
      label: Text(activeCount.toString()),
      child: Icon(Icons.local_offer),
    );
  },
),
```

---

## ✅ Verification Checklist

After integration, verify:

- [ ] Favorite button appears on restaurant cards
- [ ] Tapping favorite button animates and saves
- [ ] Favorites screen shows saved restaurants
- [ ] Can remove from favorites
- [ ] Promo codes screen displays all promos
- [ ] Countdown timers update in real-time
- [ ] Can copy promo codes
- [ ] Promo input appears in cart
- [ ] Can apply promo code
- [ ] Discount calculates correctly
- [ ] Can remove applied promo
- [ ] Free delivery promo works
- [ ] All Arabic text displays correctly (RTL)

---

## 🚀 You're All Set!

Both features are now fully integrated and ready to use. Test thoroughly and enjoy your enhanced app! 🎉
