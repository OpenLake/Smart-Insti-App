# Style Guide 🎨

## Code Style
-   **Files**: Snake case (`file_name.dart`).
-   **Classes**: PascalCase (`ClassName`).
-   **Variables**: camelCase (`variableName`).
-   **Imports**: Organize imports by package, then relative. Avoid unused imports.
-   **Constants**: Use `const` where possible for performance.
-   **Null Safety**: Strict null safety. Avoid force unwrapping (`!`).

## UltimateTheme Usage
-   **Colors**: Use `UltimateTheme.primary`, `UltimateTheme.accent`, `UltimateTheme.navy`, `Colors.white`, or `Colors.black`.
-   **Typography**: Use `GoogleFonts.spaceGrotesk` for headings and `GoogleFonts.inter` for body text.
-   **Spacing**: Use `const SizedBox(height: 8)` multiples for vertical spacing.
-   **Borders**: Use `BorderRadius.circular(16)` or `24` for consistent rounded corners.

## Widget Structure
-   **CustomScrollView**: Use for complex scrollable layouts (like `UserHome`).
-   **Riverpod**: Use `ConsumerWidget` or `ConsumerStatefulWidget` for reactive UI.
-   **Responsiveness**: Use `Expanded`, `Flexible`, or `Spacer` to handle layout constraints. avoiding fixed widths where possible.

## Commit Messages
-   Start with a verb in present tense (e.g., "Add feature", "Fix bug").
-   Reference issue numbers if applicable.
