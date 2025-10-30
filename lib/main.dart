import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'providers/attendance_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/leave_provider.dart';
import 'services/attendance_service.dart';
import 'services/statistics_service.dart';
import 'data/attendance_repository.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';
import 'services/location_service.dart';
import 'services/camera_service.dart';
import 'utils/app_theme.dart';

// Global navigator key for accessing context from lifecycle callbacks
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize AttendanceRepository
  final attendanceRepository = AttendanceRepository();
  await attendanceRepository.initialize();

  // Initialize database (skip on desktop platforms)
  // await DatabaseService().initializeDatabase();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(AttendanceApp(attendanceRepository: attendanceRepository));
}

class AttendanceApp extends StatefulWidget {
  final AttendanceRepository attendanceRepository;

  const AttendanceApp({super.key, required this.attendanceRepository});

  @override
  State<AttendanceApp> createState() => _AttendanceAppState();
}

class _AttendanceAppState extends State<AttendanceApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes for proper attendance tracking
    switch (state) {
      case AppLifecycleState.resumed:
        // App is resumed from background - refresh attendance state
        _refreshAttendanceOnResume();
        break;
      case AppLifecycleState.paused:
        // App is going to background - save current state
        _saveAttendanceOnPause();
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., during a phone call)
        break;
      case AppLifecycleState.hidden:
        // App is hidden but not paused (iOS 13+)
        break;
    }
  }

  void _refreshAttendanceOnResume() {
    // Get the attendance provider and refresh state when app resumes
    final context = navigatorKey.currentContext;
    if (context != null) {
      final attendanceProvider = Provider.of<AttendanceProvider>(
        context,
        listen: false,
      );
      attendanceProvider.refreshAttendanceState();
    }
  }

  void _saveAttendanceOnPause() {
    // Save current state when app goes to background
    final context = navigatorKey.currentContext;
    if (context != null) {
      // The Hive database automatically persists data
      debugPrint('App paused - attendance state saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(
          create: (context) => AttendanceProvider(
            attendanceService: AttendanceService(
              locationService: LocationService(),
              cameraService: CameraService(),
              uuid: const Uuid(),
            ),
            statisticsService: StatisticsService(),
            attendanceRepository: widget.attendanceRepository,
            uuid: const Uuid(),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Attendance App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => const AttendanceScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const StatisticsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
