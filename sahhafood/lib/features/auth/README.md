# Auth Feature

User authentication feature with local state management.

## Structure

```
auth/
├── models/          # Local data models (no serialization)
│   ├── user_model.dart
│   └── models.dart
├── providers/       # Riverpod state management
│   ├── auth_provider.dart
│   └── providers.dart
└── ui/             # User interface
    ├── screens/    # Full-screen views
    │   └── login_screen.dart
    └── widgets/    # Reusable UI components
        └── phone_input_field.dart
```

## Features

- **Login**: Phone number + password authentication
- **Signup**: User registration with role selection
- **State Management**: Riverpod-based local state
- **Validation**: Phone number and password validation
- **RTL Support**: Full Arabic language support

## State Management

Uses `AuthNotifier` (StateNotifier) for managing authentication state:
- Login/Logout
- User role management
- Session state

## Models

- `UserModel`: Simple user data model (no API serialization)
- Supports: customer, chef, and delivery roles

## Usage

```dart
// Access auth state
final user = ref.watch(authProvider);
final isLoggedIn = ref.watch(isLoggedInProvider);

// Perform login
final authNotifier = ref.read(authProvider.notifier);
await authNotifier.login(phoneNumber: '6xxxxxxxx', password: 'password');
```
