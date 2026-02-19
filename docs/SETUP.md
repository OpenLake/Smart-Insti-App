# Setup Guide 🛠️

This guide covers how to set up the **Smart Insti App** including the backend server, frontend application, and database connectivity.

## Prerequisites

Before starting, ensure you have the following installed:

-   **Node.js** (v18+ recommended) & **npm**
-   **Flutter SDK** (v3.x+) & **Dart SDK**
-   **MongoDB** (Community Server or Atlas)
-   **Git** for version control
-   **VS Code** or **Android Studio** (Recommended IDEs)

---

## 1. Backend Setup server

The backend is built with Node.js, Express, and MongoDB.

### Step 1.1: Navigate to Backend Directory
```bash
cd backend
```

### Step 1.2: Install Dependencies
```bash
npm install
```

### Step 1.3: Configure Environment Variables
1.  Copy the example environment file:
    ```bash
    cp .env.example .env
    ```
2.  Open `.env` and fill in the required values:
    -   **PORT**: `3000` (default)
    -   **MONGODB_URI**: Connection string for your MongoDB instance (e.g., `mongodb://localhost:27017/smart-insti-app`).
    -   **ACCESS_TOKEN_SECRET**: A strong random string for signing JWTs.
    -   **REFRESH_TOKEN_SECRET**: A strong random string for refresh tokens.
    -   **CLOUDINARY_***: API keys for image uploads (Optional for local dev, but required for full features).
    -   **FIREBASE_***: Service account credentials for push notifications (**Optional** - You can skip this for local development).

### Step 1.4: Start the Server
-   **Development Mode** (auto-restart on changes):
    ```bash
    npm run dev
    # OR using Makefile from root
    make dev
    ```
-   **Production Mode**:
    ```bash
    npm start
    ```

The server should be running at `http://localhost:3000`.

---

## 2. Frontend Setup 📱

The frontend is built with Flutter.

### Step 2.1: Navigate to Frontend Directory
```bash
cd frontend
```

### Step 2.2: Install Dependencies
```bash
flutter pub get
```

### Step 2.3: Configure Environment Variables
1.  Copy the example environment file:
    ```bash
    cp .env.example .env
    ```
2.  Open `.env` and set the `API_URL`:
    -   **For Android Emulator**: `http://10.0.2.2:3000/api`
    -   **For iOS Simulator**: `http://localhost:3000/api`
    -   **For Real Device**: `http://<YOUR_PC_IP>:3000/api` (Ensure your phone and PC are on the same Wi-Fi).

### Step 2.4: Run the App
-   **Debug Mode**:
    ```bash
    flutter run
    # OR using Makefile from root
    make dev-frontend
    ```

---

## 3. Database Setup 🗄️

-   Ensure your MongoDB instance is running.
-   The application will automatically create the necessary collections when you run it and modify data.
-   **Seeding Data**: You can use the provided CSV/TSV files (like `menu_jan.tsv`) to import initial data via the app interface or scripts if available.

---

## 4. Troubleshooting 🔧

### Common Issues

1.  **"Connection Refused" on Android Emulator**
    -   **Cause**: The emulator cannot access `localhost` of the host machine directly.
    -   **Fix**: Use `10.0.2.2` instead of `localhost` in your `.env` file for `API_URL`.

2.  **"JWT Malformed" or "Invalid Token"**
    -   **Cause**: Mismatch between the secret used to sign the token and the verify secret.
    -   **Fix**: Ensure `ACCESS_TOKEN_SECRET` in `backend/.env` is consistent and you restart the server after changing it.

3.  **App Crashes on Launch (Linux)**
    -   **Cause**: Firebase configuration might be missing or incorrect for desktop.
    -   **Fix**: We have added a `try-catch` block in `main.dart`, but ensure your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) are correctly placed if you need Firebase features.

4.  **Port Already in Use**
    -   **Cause**: Another process is running on port 3000.
    -   **Fix**: Kill the process using `lsof -i :3000` (Linux/Mac) or change the `PORT` in `backend/.env`.

---

## 5. Deployment 🚀

(Add deployment instructions here, e.g., Docker, Heroku, etc.)
