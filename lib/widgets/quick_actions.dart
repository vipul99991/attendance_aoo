import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'quick_action_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.headingSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 16),

        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0, // increased height to prevent text overflow
          children: [
            QuickActionCard(
              title: 'QR Scanner',
              subtitle: 'Quick check-in',
              icon: Icons.qr_code_scanner,
              colors: const [Color(0xFF7C4DFF), Color(0xFF7C4DFF)],
              onTap: () => _handleQRScanner(context),
            ),
            QuickActionCard(
              title: 'Leave Request',
              subtitle: 'Apply leave',
              icon: Icons.task_alt_rounded,
              colors: const [Color(0xFFFF6D00), Color(0xFFFF8F00)],
              onTap: () => _handleLeaveRequest(context),
            ),
            QuickActionCard(
              title: 'Team View',
              subtitle: 'Team status',
              icon: Icons.groups_rounded,
              colors: const [Color(0xFF00C853), Color(0xFF00BFA5)],
              onTap: () => _handleTeamView(context),
            ),
            QuickActionCard(
              title: 'Reports',
              subtitle: 'Analytics',
              icon: Icons.bar_chart_rounded,
              colors: const [Color(0xFF2196F3), Color(0xFF21CBF3)],
              onTap: () => _handleReports(context),
            ),
            QuickActionCard(
              title: 'Work From Home',
              subtitle: 'Remote work',
              icon: Icons.home_work,
              colors: const [Color(0xFF9C27B0), Color(0xFFE91E63)],
              onTap: () => _handleWorkFromHome(context),
            ),
            QuickActionCard(
              title: 'Overtime',
              subtitle: 'Extra hours',
              icon: Icons.access_time_filled,
              colors: const [Color(0xFFFF9800), Color(0xFFFFB74D)],
              onTap: () => _handleOvertime(context),
            ),
            QuickActionCard(
              title: 'Location',
              subtitle: 'Check location',
              icon: Icons.location_on,
              colors: const [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              onTap: () => _handleLocation(context),
            ),
            QuickActionCard(
              title: 'Settings',
              subtitle: 'Preferences',
              icon: Icons.settings_rounded,
              colors: const [Color(0xFF607D8B), Color(0xFF90A4AE)],
              onTap: () => _handleSettings(context),
            ),
          ],
        ),
      ],
    );
  }

  void _handleQRScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text('Scan QR code for quick attendance marking'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Scanner opening...')),
              );
            },
            child: const Text('Open Scanner'),
          ),
        ],
      ),
    );
  }

  void _handleLeaveRequest(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Leave Type'),
              items: const [
                DropdownMenuItem(value: 'sick', child: Text('Sick Leave')),
                DropdownMenuItem(value: 'vacation', child: Text('Vacation')),
                DropdownMenuItem(
                  value: 'personal',
                  child: Text('Personal Leave'),
                ),
                DropdownMenuItem(
                  value: 'emergency',
                  child: Text('Emergency Leave'),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'From Date'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'To Date'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Reason'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave request submitted')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _handleTeamView(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Team Status'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTeamMember(
                'Alice Johnson',
                'Present',
                Icons.check_circle,
                Colors.green,
              ),
              _buildTeamMember(
                'Bob Smith',
                'On Leave',
                Icons.event_busy,
                Colors.blue,
              ),
              _buildTeamMember(
                'Carol Davis',
                'Work From Home',
                Icons.home_work,
                Colors.purple,
              ),
              _buildTeamMember(
                'David Wilson',
                'Late',
                Icons.schedule,
                Colors.orange,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    String name,
    String status,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(name),
      subtitle: Text(status),
      dense: true,
    );
  }

  void _handleReports(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reports & Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Monthly Report'),
              subtitle: const Text('Detailed monthly attendance'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Performance Analytics'),
              subtitle: const Text('Charts and statistics'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export Data'),
              subtitle: const Text('Download CSV/PDF reports'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleWorkFromHome(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Work From Home'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mark today as Work From Home?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'e.g., Bad weather, Personal reasons',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Work From Home marked for today'),
                ),
              );
            },
            child: const Text('Mark WFH'),
          ),
        ],
      ),
    );
  }

  void _handleOvertime(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overtime Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Expected Hours'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Reason for Overtime'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Overtime request submitted')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _handleLocation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text('Current Location'),
            const SizedBox(height: 8),
            const Text(
              'Office Building, Floor 5\n123 Business St, City',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    Text('In Range', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.gps_fixed, color: Colors.blue),
                    Text('GPS Active', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Location Services'),
              value: true,
              onChanged: (value) {},
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('English'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
