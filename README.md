# 🎯 Attendance App - Advanced Attendance Management System

A modern, feature-rich Flutter application for attendance management with beautiful UI/UX, animations, and advanced functionality.

## ✨ Features

### 🎨 **Modern UI/UX**
- Beautiful gradient designs with Material Design 3
- Smooth animations and transitions
- Custom app theme with light/dark mode support
- Responsive design for all screen sizes
- Custom widgets and components
- Lottie animations and shimmer effects for enhanced user experience

### 📱 **Core Functionality**
- **User Authentication**: Secure employee login with comprehensive profile management
- **Real-time Attendance Tracking**: GPS-verified check-in/check-out with photo capture
- **Dashboard**: Overview of attendance statistics and quick actions
- **Calendar View**: Monthly attendance calendar with color-coded status
- **Analytics**: Detailed attendance statistics and interactive charts
- **Leave Management**: Apply and track various types of leave requests
- **Team Management**: View team attendance and performance metrics
- **Profile Management**: User profile with settings and preferences

### 🚀 **Advanced Features**
- **Offline Support**: Hive database for local data storage with synchronization capabilities
- **Real-time Updates**: State management with Provider pattern
- **Location Tracking**: GPS-based check-in/out verification with configurable radius
- **Photo Verification**: Camera integration for attendance verification
- **Data Visualization**: Charts and graphs using FL Chart
- **Reporting & Export**: Generate and export attendance reports in multiple formats
- **Multi-platform**: Works on Android, iOS, and Web
- **Permission-based Access**: Role-based permissions for different operations

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
├── main.dart                     # App entry point with MultiProvider setup
├── models/                       # Data models
│   ├── employee_model.dart       # Employee data structure
│   ├── attendance.dart           # Attendance record model
│   ├── leave_request.dart        # Leave request model
│   └── user.dart                 # User model
├── providers/                    # State management
│   ├── attendance_provider.dart  # Attendance business logic
│   ├── auth_provider.dart        # Authentication management
│   ├── theme_provider.dart       # Theme management
│   └── user_provider.dart        # User state management
├── screens/                      # App screens
│   ├── attendance_screen.dart
│   ├── auth_screen.dart
│   ├── calendar_screen.dart
│   ├── enhanced_home_screen.dart
│   ├── home_screen.dart
│   ├── leave_request_screen.dart
│   ├── login_screen.dart
│   ├── metrics_screen.dart
│   ├── onboarding_screen.dart
│   ├── profile_screen.dart
│   ├── qr_scanner_screen.dart
│   ├── reports_analytics_screen.dart
│   ├── settings_screen.dart
│   ├── splash_screen.dart
│   ├── statistics_screen.dart
│   └── team_management_screen.dart
├── widgets/                      # Reusable widgets
│   ├── attendance_card.dart
│   ├── check_in_out_card.dart    # Main attendance UI component
│   ├── quick_action_card.dart    # Reusable action cards
│   ├── quick_actions.dart
│   └── statistics_overview.dart
├── services/                     # Platform-specific services
│   ├── camera_service.dart       # Photo capture functionality
│   ├── database_service.dart
│   └── location_service.dart     # GPS location services
├── utils/                        # Utilities and configuration
│   ├── app_theme.dart            # Theme system
│   └── constants.dart            # App configuration and constants
└── models/                       # Data models
    └── attendance.dart
```

### Architecture Patterns
- **MVVM-like Architecture**: Clear separation between models, views, and business logic
- **Provider Pattern**: Centralized state management with reactive updates
- **Repository Pattern**: Data access abstraction through providers
- **Clean Architecture**: Modular structure with distinct layers

### Key Technologies
- **Flutter SDK**: Cross-platform development
- **Provider**: State management with ChangeNotifier
- **GoRouter**: Navigation and routing system
- **Hive**: Local database storage for offline capability
- **Geolocator**: Location services for attendance verification
- **Camera**: Photo capture for attendance verification
- **FL Chart**: Data visualization and analytics
- **Lottie**: Vector animations and visual effects
- **Material Design 3**: Modern UI components
- **Intl**: Internationalization and date formatting

## 🎨 **Design System**

### Color Palette
- **Primary**: Indigo (#6366F1)
- **Secondary**: Emerald (#10B981) 
- **Accent**: Amber (#F59E0B)
- **Success**: Green (#22C55E)
- **Warning**: Orange (#F97316)
- **Error**: Red (#EF4444)

### Typography
- **Font Family**: System default with Poppins support
- **Headings**: Bold weights with proper hierarchy
- **Body Text**: Regular and medium weights
- **Captions**: Light weight for secondary information

## 🗃️ **Data Models & Relationships**

### Employee Model
- Comprehensive employee information (ID, name, contact details, role)
- Working hours configuration (start time, end time, break duration)
- Office location data with configurable radius
- Permission-based access control
- HR email contacts for notifications

### Attendance Record Model
- Check-in/check-out timestamps with location data
- Photo references for verification
- Automatic calculation of work duration and overtime
- Multiple attendance statuses (present, late, half-day, etc.)
- Notes and additional information fields

### Leave Request Model
- Comprehensive leave management with type, dates, and status
- Support for various leave types (sick, vacation, personal, emergency, maternity, paternity)
- Approval workflow with approver tracking
- Half-day leave functionality

## 🔐 **Authentication & User Management**

### Authentication System
- Employee-based authentication with comprehensive profile data
- Persistent login using Hive storage
- Permission-based access control with role-based permissions
- Secure credential validation
- Session management with logout functionality

### State Management
- **AuthProvider**: Handles authentication state and user management
- **AttendanceProvider**: Manages attendance data and operations
- **ThemeProvider**: Handles theme changes (light/dark mode)
- **UserProvider**: Manages user state and preferences

## 📍 **Attendance Tracking Features**

### Location-Based Verification
- GPS location verification to ensure users are within office radius
- Distance calculation using Geolocator
- Configurable office location and allowed radius
- Location data stored with each attendance record

### Photo Capture Integration
- Camera service integration for photo capture
- Photos stored with check-in/check-out records
- Optional photo capture that doesn't fail if camera is unavailable

### Working Hours Calculation
- Automatic calculation of total work time
- Overtime detection based on working hours configuration
- Late arrival detection based on configured start time
- Half-day identification based on work duration

### Status Determination
- Automatic status assignment (present, late, half-day, etc.)
- Configurable rules for status determination
- Time-based calculations for attendance metrics

## 📊 **Analytics & Reporting**

### Dashboard Features
- Attendance percentage tracking
- Working hours monitoring
- Overtime analysis
- Leave request statistics
- Team performance metrics

### Report Generation
- Monthly/weekly reports
- Export capabilities (PDF, Excel, CSV)
- Interactive charts and graphs
- Custom date range selection
- Department-wise analytics

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
3. **Authentication**: Employee login with credentials
4. **Dashboard**: Home screen with attendance overview
5. **Check-in/out**: GPS-verified attendance with photo capture
6. **Analytics**: View attendance statistics and reports
7. **Leave Management**: Apply and track leave requests
8. **Team Management**: View team attendance and performance
9. **Profile**: User settings and preferences

### Key Screens

#### 🏠 **Home Dashboard**
- Current day attendance status
- Quick check-in/check-out buttons with location verification
- Statistics overview with key metrics
- Quick action cards for common tasks
- Recent attendance summary

#### 📊 **Analytics & Reports**
- Attendance percentage tracking
- Working hours analysis
- Monthly/weekly reports
- Interactive charts using FL Chart
- Export capabilities in multiple formats

#### 📅 **Calendar View**
- Monthly attendance calendar with color-coded status
- Daily details view
- Leave requests integration
- Working hours visualization

#### 🏢 **Team Management**
- Team attendance overview
- Department-wise analytics
- Individual employee tracking
- Performance metrics
- Team reports

#### 📝 **Leave Management**
- Apply for various types of leave
- Track leave status (pending/approved/rejected)
- Leave balance information
- Leave history tracking

## 🔧 **Technical Implementation**

### State Management
The application uses Provider as the primary state management solution:
- **MultiProvider** in `main.dart` initializes multiple providers
- **ChangeNotifier** pattern for reactive updates
- **Consumer** and **Consumer2** widgets for listening to state changes
- Centralized state management with clear separation of concerns

### Data Persistence
- **Hive Database**: Local-first approach with offline support
- Multiple boxes for different data types (user, attendance, leave, settings)
- Automatic data serialization/deserialization
- Efficient data retrieval and storage

### Navigation System
- **GoRouter**: Declarative routing with clear route definitions
- Deep linking support
- Protected routes with authentication checks
- Tab-based navigation for main screens
- Modal and dialog navigation for specific flows

### Security Considerations
- Location verification to prevent remote check-ins
- Photo capture for identity verification
- Permission-based access control
- Secure credential handling
- Privacy-first approach to data handling

### Performance Optimizations
- Efficient data storage with Hive
- Lazy loading of data
- Optimized UI rendering with proper widget structure
- Background service integration for continuous operations

## 🛡️ **Data Security**

### Local Storage
- Hive database for offline capability
- Secure user authentication
- Privacy-first approach to data handling
- Configurable data retention policies

### Verification Features
- GPS location verification for attendance
- Photo capture for identity confirmation
- Time-based access controls
- Permission-based feature access

## 🌟 **Future Enhancements**

### Planned Features
- [ ] Biometric authentication
- [ ] Advanced reporting with custom filters
- [ ] Geofencing for automatic check-in
- [ ] Face recognition attendance
- [ ] Integration with calendar apps
- [ ] Advanced analytics with AI-powered insights
- [ ] Multi-language support
- [ ] Integration with HR systems
- [ ] Push notifications for attendance reminders

### Technical Improvements
- [ ] Unit and integration tests
- [ ] CI/CD pipeline setup
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Error handling enhancement
- [ ] Server synchronization capabilities

## 📋 **Project Dependencies**

### UI Components
- `flutter_svg`: SVG image support
- `font_awesome_flutter`: Icon library
- `lottie`: Animation support
- `animated_text_kit`: Animated text effects
- `shimmer`: Loading animations

### State Management
- `provider`: Reactive state management

### Navigation
- `go_router`: Declarative routing

### Storage
- `hive`: Local database
- `hive_flutter`: Hive Flutter integration
- `shared_preferences`: Simple key-value storage
- `sqflite`: SQLite database (alternative option)

### Date/Time
- `intl`: Internationalization and date formatting
- `table_calendar`: Calendar UI components

### Charts
- `fl_chart`: Data visualization

### Media
- `image_picker`: Image selection
- `camera`: Camera functionality
- `cached_network_image`: Image caching

### Utilities
- `uuid`: Unique identifier generation
- `url_launcher`: URL handling
- `path`: File path operations

### Location
- `geolocator`: GPS location services
- `geocoding`: Address conversion

### QR Code
- `qr_flutter`: QR code generation

### HTTP & JSON
- `http`: HTTP requests
- `dio`: Advanced HTTP client

### Background Services
- `flutter_background_service`: Background operations

### File Operations & Export
- `excel`: Excel file generation
- `pdf`: PDF generation
- `open_file`: File opening
- `share_plus`: File sharing
- `path_provider`: File system paths
- `permission_handler`: Permission management

### Email
- `mailer`: Email functionality

## 🤝 **Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 **License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Flutter**

> *A modern attendance management solution for the digital workplace*