import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_theme.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AttendanceProvider, UserProvider>(
      builder: (context, attendanceProvider, userProvider, child) {
        final todayAttendance = attendanceProvider.todayAttendance;
        final hasCheckedIn = attendanceProvider.hasCheckedInToday;
        final hasCheckedOut = attendanceProvider.hasCheckedOutToday;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Today\'s Attendance',
                      style: AppTheme.headingSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Check In/Out Times
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeCard(
                        context,
                        'Check In',
                        todayAttendance?.checkInTime,
                        Icons.login,
                        AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimeCard(
                        context,
                        'Check Out',
                        todayAttendance?.checkOutTime,
                        Icons.logout,
                        AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Total Hours
                if (todayAttendance?.totalHours != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total Hours: ${todayAttendance!.formattedTotalHours}',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    if (!hasCheckedIn)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showCheckInDialog(context),
                          icon: const Icon(Icons.login, size: 18),
                          label: const Text('Check In'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      )
                    else if (!hasCheckedOut)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showCheckOutDialog(context),
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text('Check Out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.warningColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.successColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.successColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Day Completed',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    String title,
    DateTime? time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            time != null ? DateFormat('hh:mm a').format(time) : '--:--',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showCheckInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Check In'),
        content: const Text('Are you sure you want to check in now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final userProvider = context.read<UserProvider>();
              final attendanceProvider = context.read<AttendanceProvider>();

              final success = await attendanceProvider.checkInLegacy(
                userId: userProvider.currentUser!.id,
                location: 'Office', // In a real app, get actual location
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Checked in successfully!'
                          : 'Failed to check in. Please try again.',
                    ),
                    backgroundColor: success
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Check In'),
          ),
        ],
      ),
    );
  }

  void _showCheckOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Check Out'),
        content: const Text('Are you sure you want to check out now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final attendanceProvider = context.read<AttendanceProvider>();

              final success = await attendanceProvider.checkOutLegacy(
                location: 'Office', // In a real app, get actual location
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Checked out successfully!'
                          : 'Failed to check out. Please try again.',
                    ),
                    backgroundColor: success
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Check Out'),
          ),
        ],
      ),
    );
  }
}
