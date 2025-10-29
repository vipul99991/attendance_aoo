# attendance_aoo

A new Flutter project.

## Getting Started

# 🎯 Attendance App - Advanced Attendance Management System

A modern, feature-rich Flutter application for attendance management with beautiful UI/UX, animations, and advanced functionality.

## ✨ Features

### 🎨 **Modern UI/UX**
- Beautiful gradient designs with Material Design 3
- Smooth animations and transitions
- Custom app theme with light/dark mode support
- Responsive design for all screen sizes
- Custom widgets and components

### 📱 **Core Functionality**
- **User Authentication**: Secure login/signup with social login options
- **Real-time Attendance Tracking**: Check-in/Check-out with timestamp
- **Dashboard**: Overview of attendance statistics and quick actions
- **Calendar View**: Monthly attendance calendar
- **Analytics**: Detailed attendance statistics and charts
- **Leave Management**: Apply and track leave requests
- **Profile Management**: User profile with settings

### 🚀 **Advanced Features**
- **Offline Support**: SQLite database for local data storage
- **Real-time Updates**: State management with Provider
- **Location Tracking**: GPS-based check-in/out (ready for implementation)
- **Push Notifications**: Local notifications for reminders
- **Data Visualization**: Charts and graphs using FL Chart
- **Export/Import**: Data export capabilities
- **Multi-platform**: Works on Android, iOS, and Web

### 🎭 **Animations & Visual Effects**
- Splash screen with animated logo
- Onboarding screens with smooth transitions
- Loading animations and shimmer effects
- Card animations and micro-interactions
- Gradient backgrounds and modern design patterns

## 🏗️ **Architecture**

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── attendance.dart
│   └── leave_request.dart
├── providers/                # State management
│   ├── theme_provider.dart
│   ├── user_provider.dart
│   └── attendance_provider.dart
├── screens/                  # App screens
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── attendance_screen.dart
│   ├── calendar_screen.dart
│   ├── statistics_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable widgets
│   ├── attendance_card.dart
│   ├── quick_actions.dart
│   └── statistics_overview.dart
├── services/                 # Business logic
│   └── database_service.dart
└── utils/                    # Utilities
    └── app_theme.dart
```

### Key Technologies
- **Flutter SDK**: Cross-platform development
- **Provider**: State management
- **GoRouter**: Navigation and routing
- **SQLite**: Local database storage
- **FL Chart**: Data visualization
- **Lottie**: Vector animations
- **Material Design 3**: Modern UI components

## 🎨 **Design System**

### Color Palette
- **Primary**: Indigo (#6366F1)
- **Secondary**: Emerald (#10B981) 
- **Accent**: Amber (#F59E0B)
- **Success**: Green (#22C55E)
- **Warning**: Orange (#F97316)
- **Error**: Red (#EF4444)

### Typography
- **Font Family**: System default (Poppins ready for implementation)
- **Headings**: Bold weights with proper hierarchy
- **Body Text**: Regular and medium weights
- **Captions**: Light weight for secondary information

## 🚀 **Getting Started**

### Prerequisites
- Flutter SDK (>=3.9.2)
- Dart SDK (>=3.0.0)
- Android Studio or VS Code
- Git

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd attendance_aoo
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # For Android/iOS
   flutter run
   
   # For Web
   flutter run -d web-server --web-port 8080
   ```

## 📱 **App Flow**

### User Journey
1. **Splash Screen**: Animated logo with app branding
2. **Onboarding**: 3-screen introduction to features
3. **Authentication**: Login/signup with multiple options
4. **Dashboard**: Home screen with attendance overview
5. **Check-in/out**: Quick attendance actions
6. **Analytics**: View attendance statistics
7. **Calendar**: Monthly attendance view
8. **Profile**: User settings and preferences

### Key Screens

#### 🏠 **Home Dashboard**
- Current day status
- Quick check-in/out buttons
- Statistics overview
- Quick action cards
- Recent attendance summary

#### 📊 **Analytics & Reports**
- Attendance percentage
- Working hours tracking
- Monthly/weekly reports
- Interactive charts
- Export capabilities

#### 📅 **Calendar View**
- Monthly attendance calendar
- Color-coded attendance status
- Daily details view
- Leave requests integration

## 🛡️ **Data Security**

### Local Storage
- SQLite database for offline capability
- Encrypted sensitive data
- Secure user authentication
- Privacy-first approach

## 🔧 **Build Issues Fixed**

### Android Build Configuration
I've resolved the build issues that were occurring with the Android version:

1. **Core Library Desugaring**: Added support for Java 8+ language features
   - Updated `android/app/build.gradle.kts` with `isCoreLibraryDesugaringEnabled = true`
   - Added desugaring library dependency: `com.android.tools:desugar_jdk_libs:2.0.4`

2. **Java Version Update**: Updated to Java 17 for better compatibility
   - Changed from Java 11 to Java 17 in compile options
   - Updated Kotlin JVM target accordingly

3. **Flutter Local Notifications**: Temporarily disabled due to compilation conflicts
   - The package had Java compilation issues with newer Android SDK versions
   - Can be re-enabled once a compatible version is available

4. **Minimum SDK**: Set to API level 24 (Android 7.0) for better compatibility

### Fixed Configuration Files
- `android/app/build.gradle.kts`: Core library desugaring and Java 17
- `android/gradle.properties`: Flutter SDK version specifications
- `pubspec.yaml`: Temporarily disabled problematic notification package

## 🌟 **Future Enhancements**

### Planned Features
- [ ] Biometric authentication
- [ ] Advanced reporting
- [ ] Team management
- [ ] Integration with HR systems
- [ ] AI-powered insights
- [ ] Multi-language support
- [ ] Re-enable push notifications (when compatible package available)
- [ ] Geofencing for automatic check-in
- [ ] Face recognition attendance
- [ ] Integration with calendar apps

### Technical Improvements
- [ ] Unit and integration tests
- [ ] CI/CD pipeline setup
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Error handling enhancement

---

**Built with ❤️ using Flutter**

> *A modern attendance management solution for the digital workplace*
