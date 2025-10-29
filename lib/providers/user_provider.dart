import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');

      if (userJson != null) {
        // In a real app, you would parse the user from JSON
        // For now, we'll create a demo user
        _currentUser = User(
          id: '1',
          name: 'Vipul',
          email: 'vipul@company.com',
          phone: '+1234567890',
          department: 'Engineering',
          designation: 'Software Developer',
          joinDate: DateTime(2023, 1, 15),
          role: UserRole.employee,
        );
        _isLoggedIn = true;
      }
    } catch (e) {
      debugPrint('Error initializing user: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Demo login - accept any email/password
      _currentUser = User(
        id: '1',
        name: 'Vipul',
        email: email,
        phone: '+1234567890',
        department: 'Engineering',
        designation: 'Software Developer',
        joinDate: DateTime(2023, 1, 15),
        role: UserRole.employee,
      );

      _isLoggedIn = true;

      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', 'demo_user');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');

      _currentUser = null;
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
