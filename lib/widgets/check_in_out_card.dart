import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_provider.dart';
import '../providers/auth_provider.dart';
import '../models/employee_model.dart';

class CheckInOutCard extends StatefulWidget {
  // ignore: use_super_parameters
  const CheckInOutCard({Key? key}) : super(key: key);

  @override
  State<CheckInOutCard> createState() => _CheckInOutCardState();
}

class _CheckInOutCardState extends State<CheckInOutCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AttendanceProvider, AuthProvider>(
      builder: (context, attendanceProvider, authProvider, child) {
        final isCheckedIn = attendanceProvider.isCheckedInToday;
        final isCheckedOut = attendanceProvider.isCheckedOutToday;
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
                if (isCheckedIn && !isCheckedOut) ...[
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
                ] else if (!isCheckedIn) ...[
                  _buildCheckInButton(
                    context,
                    authProvider,
                    attendanceProvider,
                  ),
                ] else if (!isCheckedOut) ...[
                  _buildCheckOutButton(
                    context,
                    authProvider,
                    attendanceProvider,
                  ),
                ] else ...[
                  _buildCheckInButton(
                    context,
                    authProvider,
                    attendanceProvider,
                  ),
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
    final workingTime = DateTime.now().difference(attendance.checkInTime!);
    final hours = workingTime.inHours;
    final minutes = workingTime.inMinutes % 60;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Text(
            'Working Time: ${hours}h ${minutes}m',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
    AuthProvider authProvider,
    AttendanceProvider attendanceProvider,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () =>
            _handleCheckIn(context, authProvider, attendanceProvider),
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
    AuthProvider authProvider,
    AttendanceProvider attendanceProvider,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () =>
            _handleCheckOut(context, authProvider, attendanceProvider),
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

  Widget _buildCompletedDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Day Completed!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckIn(
    BuildContext context,
    AuthProvider authProvider,
    AttendanceProvider attendanceProvider,
  ) async {
    final employee = authProvider.currentEmployee;
    if (employee == null) return;

    final success = await attendanceProvider.checkIn(
      employeeId: employee.employeeId,
      officeLocation: employee.location,
      requireLocation: true,
      requirePhoto: true,
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Checked in successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleCheckOut(
    BuildContext context,
    AuthProvider authProvider,
    AttendanceProvider attendanceProvider,
  ) async {
    final employee = authProvider.currentEmployee;
    if (employee == null) return;

    final success = await attendanceProvider.checkOut(
      employeeId: employee.employeeId,
      workingHours: employee.workingHours,
      requireLocation: true,
      requirePhoto: true,
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Checked out successfully!'),
          backgroundColor: Colors.orange,
        ),
      );
      
      // After successful check-out, allow for a new check-in cycle
      await Future.delayed(const Duration(milliseconds: 10)); // Small delay to ensure state update
      await attendanceProvider.allowNewCheckInCycle();
    }
  }
}
