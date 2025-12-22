# 📌 Project Scope
This document defines the rules and architecture for the frontend Flutter application of the Food Delivery project. It will serve as the single source of truth for development inside Windsurf.

## ✅ Rules & Guidelines

### Code Style
- Use Dart best practices and follow Flutter's Effective Dart guidelines.
- Prefer const constructors whenever possible.
- Keep widgets small and reusable.
- Use Riverpod for state management (avoid mixing with GetX in the same project).

### Naming Conventions
- Files → `snake_case.dart`
- Classes → `PascalCase`
- Variables & functions → `camelCase`
- Widgets ending with `...Widget` only when needed (e.g., `CustomButton`, not `ButtonWidget`).

### Reusability
- Extract shared UI into `/lib/core/widgets`.
- Define typography, colors, and spacing in `/lib/core/theme`.
- Keep features isolated — no cross-importing from one feature into another unless through `core`.

### Workflow with Figma
- Follow the design tokens from Figma (colors, fonts, spacing).
- Each screen in Figma → one feature folder in code.
- Components in Figma → reusable widgets in `/core/widgets`.

# 🏗 Architecture

## Folder Structure
```
lib/
 ├── core/                 # Reusable, app-wide utilities
 │    ├── theme/           # Colors, typography, spacing, themes
 │    ├── widgets/         # Shared UI components
 │    ├── utils/           # Helpers, formatters, constants
 │    └── config/          # App config (routes, env setup)
 │
 ├── features/             # Each feature = independent module
 │    ├── auth/            # Login, signup, onboarding
 │    ├── home/            # Main dashboard, feed
 │    ├── cart/            # Cart management
 │    ├── orders/          # Order history, order details
 │    └── profile/         # User settings, account
 │
 ├── services/             # External services (e.g., API layer, mock for now)
 │
 └── main.dart             # App entry point
```

## State Management
- Use Riverpod (`hooks_riverpod`) for predictable, testable state.
- Each feature has its own `provider.dart` file.
- Keep business logic outside widgets (providers handle state).

## Navigation
- Use `go_router` for clean and declarative navigation.
- Define all routes in `/core/config/app_routes.dart`.

## Theming
- Centralize `ThemeData` in `/core/theme`.
- Follow light/dark mode from system.

## RTL Language Support
- The app will support Arabic language content while maintaining LTR (Left-to-Right) layout direction.
- All text content should be in Arabic.
- Text alignment should be right-aligned for Arabic content.
- Use `textDirection: TextDirection.rtl` for Arabic text widgets.
- Maintain LTR layout direction for overall app structure (menus, navigation, etc.).
- Store all text strings in a localization file for easy translation management.
- Use `intl` package for number and date formatting in Arabic.
- Ensure proper font support for Arabic characters.
