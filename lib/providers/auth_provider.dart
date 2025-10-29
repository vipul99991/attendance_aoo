import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/employee_model.dart';

class AuthProvider extends ChangeNotifier {
  Employee? _currentEmployee;
  bool _isLoggedIn = false;
  Box? _userBox;

  Employee? get currentEmployee => _currentEmployee;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _userBox = await Hive.openBox('user_data');
      await _loadUserFromStorage();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
    }
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final userData = _userBox?.get('current_employee');
      if (userData != null) {
        _currentEmployee = Employee.fromJson(
          Map<String, dynamic>.from(userData),
        );
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user from storage: $e');
    }
  }

  Future<void> login(Employee employee) async {
    try {
      _currentEmployee = employee;
      _isLoggedIn = true;

      // Save to Hive storage
      await _userBox?.put('current_employee', employee.toJson());
      await _userBox?.put('is_logged_in', true);

      notifyListeners();
    } catch (e) {
      debugPrint('Error during login: $e');
      throw Exception('Failed to save login data');
    }
  }

  Future<void> logout() async {
    try {
      _currentEmployee = null;
      _isLoggedIn = false;

      // Clear from Hive storage
      await _userBox?.delete('current_employee');
      await _userBox?.delete('is_logged_in');

      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      _currentEmployee = employee;
      await _userBox?.put('current_employee', employee.toJson());
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating employee: $e');
    }
  }

  bool hasPermission(String permission) {
    return _currentEmployee?.permissions.contains(permission) ?? false;
  }

  List<String> get hrEmails {
    return _currentEmployee?.hrEmails ?? [];
  }

  WorkingHours? get workingHours {
    return _currentEmployee?.workingHours;
  }

  OfficeLocation? get officeLocation {
    return _currentEmployee?.location;
  }

  // Calculate if current time is overtime
  bool isOvertimeHour(DateTime dateTime) {
    if (_currentEmployee?.workingHours == null) return false;

    final workingHours = _currentEmployee!.workingHours;
    final endTime = _parseTime(workingHours.endTime, dateTime);
    final currentTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );

    return currentTime.isAfter(endTime);
  }

  DateTime _parseTime(String time, DateTime date) {
    final parts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  } // Get standard work end time for the day

  DateTime getWorkEndTime(DateTime date) {
    final workingHours = _currentEmployee?.workingHours;
    if (workingHours == null) {
      return DateTime(date.year, date.month, date.day, 17, 0); // Default 5 PM
    }

    final parts = workingHours.endTime.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
