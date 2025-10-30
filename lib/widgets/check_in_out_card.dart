import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_provider.dart';
import '../providers/user_provider.dart';
import '../models/employee_model.dart';

class CheckInOutCard extends StatefulWidget {
  // ignore: use_super_parameters
  const CheckInOutCard({Key? key}) : super(key: key);

  @override
  State<CheckInOutCard> createState() => _CheckInOutCardState();
}

class _CheckInOutCardState extends State<CheckInOutCard> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Update the clock every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AttendanceProvider, UserProvider>(
      builder: (context, attendanceProvider, userProvider, child) {
        final hasActiveCheckIn = attendanceProvider.hasActiveCheckIn;
        final isCheckedOut = attendanceProvider.isCheckedOutToday;
        final canCheckIn = attendanceProvider.canCheckIn;
        final todayAttendance = attendanceProvider.todayAttendance;
        final isLoading = attendanceProvider.isLoading;

        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attendance',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(DateTime.now()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Status Display
                if (hasActiveCheckIn) ...[
                  _buildStatusDisplay(
                    'Checked In',
                    DateFormat('hh:mm a').format(todayAttendance!.checkInTime!),
                    Icons.login,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildWorkingTimeDisplay(todayAttendance),
                ] else if (isCheckedOut) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusDisplay(
                          'Check In',
                          DateFormat(
                            'hh:mm a',
                          ).format(todayAttendance!.checkInTime!),
                          Icons.login,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatusDisplay(
                          'Check Out',
                          DateFormat(
                            'hh:mm a',
                          ).format(todayAttendance.checkOutTime!),
                          Icons.logout,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildWorkSummaryDisplay(todayAttendance),
                ] else ...[
                  _buildNotCheckedInDisplay(),
                ],

                const SizedBox(height: 24),

                // Action Buttons
                if (isLoading) ...[
                  const CircularProgressIndicator(color: Colors.white),
                ] else if (canCheckIn) ...[
                  _buildCheckInButton(
                    context,
                    userProvider,
                    attendanceProvider,
                  ),
                ] else if (hasActiveCheckIn) ...[
                  _buildCheckOutButton(
                    context,
                    userProvider,
                    attendanceProvider,
                  ),
                ] else if (isCheckedOut) ...[
                  _buildNewDayMessage(),
                ],

                // Error Display
                if (attendanceProvider.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            attendanceProvider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusDisplay(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingTimeDisplay(AttendanceRecord attendance) {
    final workingTime = _currentTime.difference(attendance.checkInTime!);
    final hours = workingTime.inHours;
    final minutes = workingTime.inMinutes % 60;
    final seconds = workingTime.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer_outlined,
                color: Colors.white.withValues(alpha: 0.9),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Working Time',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Digital Clock Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimeUnit(hours.toString().padLeft(2, '0'), 'HRS'),
                _buildTimeSeparator(),
                _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'MIN'),
                _buildTimeSeparator(),
                _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'SEC'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
            height: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildWorkSummaryDisplay(AttendanceRecord attendance) {
    final totalWorkTime = attendance.totalWorkTime!;
    final hours = totalWorkTime.inHours;
    final minutes = totalWorkTime.inMinutes % 60;
    final hasOvertime =
        attendance.overtimeHours != null &&
        attendance.overtimeHours!.inMinutes > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Total Work: ${hours}h ${minutes}m',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (hasOvertime) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Overtime: ${attendance.overtimeHours!.inHours}h ${attendance.overtimeHours!.inMinutes % 60}m',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotCheckedInDisplay() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.access_time_filled,
            size: 48,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          Text(
            'Ready to start your day?',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap check-in to begin tracking your attendance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton(
    BuildContext context,
    UserProvider userProvider,
    AttendanceProvider attendanceProvider,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () =>
            _handleCheckIn(context, userProvider, attendanceProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login, size: 24),
            const SizedBox(width: 12),
            const Text(
              'CHECK IN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckOutButton(
    BuildContext context,
    UserProvider userProvider,
    AttendanceProvider attendanceProvider,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () =>
            _handleCheckOut(context, userProvider, attendanceProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 24),
            const SizedBox(width: 12),
            const Text(
              'CHECK OUT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewDayMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Attendance Complete',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Ready for next check-in cycle',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckIn(
    BuildContext context,
    UserProvider userProvider,
    AttendanceProvider attendanceProvider,
  ) async {
    final user = userProvider.currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ User not logged in'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Create a mock employee from user data for check-in
    final mockEmployee = Employee(
      employeeId: user.id,
      name: user.name,
      email: user.email,
      department: user.department,
      position: user.designation,
      phone: user.phone,
      profileImage: user.profileImage,
      workingHours: WorkingHours(
        startTime: '09:00',
        endTime: '17:00',
        breakDuration: 60,
      ),
      hrEmails: ['hr@company.com'],
      location: OfficeLocation(
        latitude: 0.0,
        longitude: 0.0,
        allowedRadius: 100,
      ),
      permissions: [],
    );

    final success = await attendanceProvider.checkIn(
      employeeId: mockEmployee.employeeId,
      officeLocation: mockEmployee.location,
      requireLocation: false, // Set to false to avoid location issues
      requirePhoto: false, // Set to false to avoid camera issues
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Checked in successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(attendanceProvider.errorMessage ?? '❌ Check-in failed'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleCheckOut(
    BuildContext context,
    UserProvider userProvider,
    AttendanceProvider attendanceProvider,
  ) async {
    final user = userProvider.currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ User not logged in'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Create a mock employee from user data for check-out
    final mockEmployee = Employee(
      employeeId: user.id,
      name: user.name,
      email: user.email,
      department: user.department,
      position: user.designation,
      phone: user.phone,
      profileImage: user.profileImage,
      workingHours: WorkingHours(
        startTime: '09:00',
        endTime: '17:00',
        breakDuration: 60,
      ),
      hrEmails: ['hr@company.com'],
      location: OfficeLocation(
        latitude: 0.0,
        longitude: 0.0,
        allowedRadius: 100,
      ),
      permissions: [],
    );

    final success = await attendanceProvider.checkOut(
      employeeId: mockEmployee.employeeId,
      workingHours: mockEmployee.workingHours,
      requireLocation: false, // Set to false to avoid location issues
      requirePhoto: false, // Set to false to avoid camera issues
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Checked out successfully!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );

      // After successful check-out, allow for a new check-in cycle
      await Future.delayed(
        const Duration(milliseconds: 10),
      ); // Small delay to ensure state update
      await attendanceProvider.allowNewCheckInCycle();
    } else if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            attendanceProvider.errorMessage ?? '❌ Check-out failed',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
