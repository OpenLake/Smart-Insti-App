# Architecture & Tech Stack 🏗️

## Overview
Smart Insti App is a Flutter-based mobile application designed for campus management. It follows a feature-first, repository pattern architecture to ensure scalability and maintainability.

## Technology Stack 🛠️
-   **Framework**: Flutter (Dart)
-   **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
-   **Navigation**: [go_router](https://pub.dev/packages/go_router)
-   **Networking**: [dio](https://pub.dev/packages/dio) with interceptors
-   **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences) (for Auth Token)
-   **UI Library**: Custom `UltimateTheme` + [flutter_animate](https://pub.dev/packages/flutter_animate) + [google_fonts](https://pub.dev/packages/google_fonts)

## Project Structure 📂
```
lib/
├── components/       # Reusable UI widgets (Buttons, TextFields, Cards)
├── constants/        # App-wide constants (API URLs, Strings)
├── models/           # Data models (Student, Faculty, Event, etc.)
├── provider/         # Riverpod providers (State Management)
├── repositories/     # Data & API interactions
├── screens/          # UI Pages (organized by feature/role)
│   ├── admin/        # Admin-specific screens
│   ├── auth/         # Login & Registration screens
│   ├── user/         # Student/Faculty screens (Home, Profile, etc.)
│   └── main_scaffold.dart # Main app shell
├── services/         # Core services (AuthService, etc.)
├── theme/            # UltimateTheme definition
└── main.dart         # App entry point
```

## Key Patterns

### State Management (Riverpod)
-   **Providers**: Used for dependency injection (e.g., `authProvider`, `studentDbRepositoryProvider`).
-   **StateNotifiers**: Manage complex state logic (e.g., `HomeProvider`, `PostProvider`).
-   **ConsumerWidgets**: UI components that rebuild on state changes.

### Navigation (GoRouter)
-   Centralized route definition in `main.dart`.
-   Declarative routing with support for deep linking and redirection based on auth state.

### Theming (UltimateTheme)
-   A centralized theme class `UltimateTheme` defines the color palette (`Primary`, `Secondary`, `Navy`), typography (`Inter`, `Space Grotesk`), and reusable decorations.
-   **Strict usage**: No hardcoded hex codes in widgets; all colors reference `UltimateTheme`.

### API Layer
-   **Repositories**: Abstract the data source (API vs Local).
-   **Dio Interceptors**: Handle token injection and global error handling.
-   **Error Resilience**: Repositories include try-catch blocks to return empty states or cached data on network failure.
