# Smart Insti App

![Login Page](![image](https://github.com/user-attachments/assets/58e50bb2-435f-412d-8290-7388f88fa2e9)) ![Home Page](![image](https://github.com/user-attachments/assets/b3b7c95b-e32a-44c0-9a6a-17d52eacdc5f)) ![Admin Page](![image](https://github.com/user-attachments/assets/74e65916-5bdd-4514-98c4-4d0b87efc91f))

## Overview

Smart Insti App is a comprehensive institute management application designed to streamline campus life for students, faculty, and administrators. The app provides a unified platform for managing various aspects of institutional operations including student profiles, faculty information, course management, mess menus, lost and found items, room allocations, timetables, and communication.

## Features

### For Students
- **Profile Management**: View and edit personal profiles, skills, and achievements
- **Timetable**: Access and customize personal class schedules
- **Mess Menu**: View daily and weekly mess menus
- **Room Vacancy**: Check and apply for available rooms
- **Lost and Found**: Report lost items or claim found items
- **Chat Room**: Communicate with other students and faculty
- **Broadcast Notifications**: Receive important announcements

### For Faculty
- **Profile Management**: Manage professional profiles
- **Course Management**: View assigned courses and students
- **Communication**: Direct messaging with students and other faculty

### For Administrators
- **Student Management**: Add, view, and manage student information
- **Faculty Management**: Add, view, and manage faculty profiles
- **Course Administration**: Create and manage courses and assignments
- **Mess Menu Management**: Update and publish mess menus
- **Room Allocation**: Manage room assignments and vacancies

## Technology Stack

### Backend
- **Node.js** with Express.js framework
- **MongoDB** database for data storage
- **JWT** for authentication
- **Multer** for file uploads
- **Email service** for OTP verification and notifications

### Frontend
- **Flutter** for cross-platform mobile application development
- **Provider** pattern for state management
- **Custom UI components** for consistent user experience

## Project Structure

### Backend

```
backend/
├── app.js                 # Main application entry point
├── bin/www                # Server configuration
├── config/                # Configuration files
├── constants/             # Application constants
├── database/              # Database connection setup
├── middlewares/           # Custom middlewares
├── models/                # Database models
└── resources/             # API endpoints
    ├── admin/
    ├── auth/
    ├── chatroom/
    ├── faculty/
    ├── lostAndFound/
    ├── messMenu/
    ├── rooms/
    ├── student/
    └── timetable/
```

### Frontend

```
frontend/
├── lib/
│   ├── main.dart           # Entry point
│   ├── assets/             # Application assets
│   ├── components/         # Reusable UI components
│   ├── constants/          # Application constants
│   ├── models/             # Data models
│   ├── provider/           # State management
│   ├── repositories/       # Data access layer
│   ├── routes/             # Navigation routes
│   ├── screens/            # UI screens
│   │   ├── admin/          # Admin-specific screens
│   │   ├── auth/           # Authentication screens
│   │   └── user/           # User-facing screens
│   └── services/           # Application services
```

## Installation

### Prerequisites
- Node.js (v14 or later)
- MongoDB
- Flutter SDK (v3.0 or later)
- Android Studio or Xcode (for deployment)

### Backend Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/amaydixit11/smart-insti-app.git
   cd smart-insti-app/backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file based on `.env.example` with your configurations.
4. 
5. Start the server:
   ```bash
   npm start
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd ../frontend
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Create an `.env` file.

4. Run the application:
   ```bash
   flutter run
   ```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/awesome-feature`)
3. Commit your changes (`git commit -m 'Add awesome feature'`)
4. Push to the branch (`git push origin feature/awesome-feature`)
5. Open a Pull Request
