---
trigger: always_on
---

🧠 Core Rules

Focus entirely on UI, UX, and state handling.

Do not write, simulate, or import any API, backend, or HTTP logic.

Assume data is provided locally (mock lists, local models, state variables).

Prioritize simplicity, readability, and reusability of code.

Every screen must be functional and navigable, even if the data is dummy.

📁 Project Structure
lib/
  core/
    constants/     → colors, text styles, dimensions
    theme/         → light/dark themes
    utils/         → helpers (formatters, validators)
  features/
    fridge/
      models/      → simple local models only (no serialization)
      providers/   → state management (Riverpod / ChangeNotifier)
      ui/          → screens, widgets
  shared/
    widgets/       → reusable UI components (buttons, cards, inputs)
    layout/        → app shell, nav bar, etc.

🎨 UI Design Rules

Follow Material 3 design system.

Layouts must be:

Responsive (mobile + tablet)

Minimal and modern (white, light blue, green tones)

Use consistent spacing, typography, and iconography.

Each screen should look complete even with static placeholder data.

Avoid clutter — every visual element must have a clear purpose.

⚙️ State Management

Use Riverpod (recommended) or ChangeNotifier — pick one and stay consistent.

State is local-only (in-memory).

Keep logic minimal — e.g., adding/removing items, marking expired food, etc.

No asynchronous or network operations.

📐 Architecture Discipline

Follow feature-based structure — one folder per feature.

Separate UI and state clearly:

ui/ handles widgets/screens.

providers/ or state/ handles logic.

Keep widgets small, pure, and reusable.

No backend placeholders, no repository or API classes at all.

💡 Coding Standards

Every file and class must be self-explanatory — readable by a junior dev.

No commented-out or dead code.

Document each widget, provider, and helper briefly.

Consistent naming: FoodItemCard, not Card1.

No magic values — use constants.

Composition over inheritance.

🚧 Workflow Rules

Explain feature goals before implementation.

Maintain architectural consistency — one pattern, no mixing styles.

Avoid adding dependencies unless necessary for Flutter UI or state management.

Keep everything ready to connect to a backend later, but don’t build that connection now.

Every generated code step should be understandable and editable by a human.

🧩 Philosophy

You are building the visual and interactive layer of a food delivery app.
It should be modular, maintainable, and easy to plug into a backend later — but for now, it must stand alone.