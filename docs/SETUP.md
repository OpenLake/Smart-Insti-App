# Setup Guide 🛠️

## Prerequisites
-   **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install/linux)
-   **Dart SDK**: Included with Flutter.
-   **VS Code**: Recommended IDE with Dart/Flutter extensions.
-   **Git**: Version control.

## Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/OpenLake/Smart-Insti-App.git
    cd Smart-Insti-App
    ```

2.  **Navigate to Frontend**
    ```bash
    cd frontend
    ```

3.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

4.  **Configure Environment**
    -   Create a `.env` file in the root of `frontend/`.
    -   Add your API URL: `STUDENT_DB_API_URL=https://student-database-cosa-jztd.onrender.com`

## Running the App

### Debug Mode (Development)
```bash
flutter run
```

### Release Mode (Production)
```bash
flutter run --release
```

## Troubleshooting
-   **Dependencies**: If build fails, try running `flutter clean` followed by `flutter pub get`.
-   **Network**: Ensure you have an active internet connection for API calls.
-   **Platform**: Tested on Linux (Desktop) and Android. iOS build requires macOS.
