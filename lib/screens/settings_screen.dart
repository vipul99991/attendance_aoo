import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = true;
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;
  bool _checkInReminders = true;
  bool _checkOutReminders = true;
  bool _weeklyReports = true;
  bool _monthlyReports = false;
  bool _locationTrackingEnabled = true;
  bool _wifiOnlyBackup = false;
  String _selectedLanguage = 'English';
  String _workingHoursStart = '09:00 AM';
  String _workingHoursEnd = '06:00 PM';
  double _reminderFrequency = 30; // minutes

  @override
  void initState() {
    super.initState();
    _initializeCurrentTheme();
  }

  void _initializeCurrentTheme() {
    // Theme is now managed directly by ThemeProvider
    // No need to sync local state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
            tooltip: 'Reset to Defaults',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSection('Account Settings', Icons.account_circle, [
              _buildProfileTile(),
              _buildChangePasswordTile(),
              _buildSecurityTile(),
            ]),

            const SizedBox(height: 24),

            // Appearance Settings
            _buildSection('Appearance', Icons.palette, [
              _buildThemeSelector(),
              _buildLanguageSelector(),
              _buildFontSizeSelector(),
            ]),

            const SizedBox(height: 24),

            // Notification Settings
            _buildSection('Notifications', Icons.notifications, [
              _buildSwitchTile(
                'Push Notifications',
                'Receive push notifications on your device',
                _pushNotificationsEnabled,
                (value) => setState(() => _pushNotificationsEnabled = value),
              ),
              _buildSwitchTile(
                'Email Notifications',
                'Receive notifications via email',
                _emailNotificationsEnabled,
                (value) => setState(() => _emailNotificationsEnabled = value),
              ),
              _buildSwitchTile(
                'Check-in Reminders',
                'Get reminded to check in',
                _checkInReminders,
                (value) => setState(() => _checkInReminders = value),
              ),
              _buildSwitchTile(
                'Check-out Reminders',
                'Get reminded to check out',
                _checkOutReminders,
                (value) => setState(() => _checkOutReminders = value),
              ),
              _buildReminderFrequencySlider(),
            ]),

            const SizedBox(height: 24),

            // Working Hours Settings
            _buildSection('Working Hours', Icons.schedule, [
              _buildWorkingHoursTile(),
              _buildBreakTimeTile(),
              _buildOvertimeSettingsTile(),
            ]),

            const SizedBox(height: 24),

            // Privacy & Security
            _buildSection('Privacy & Security', Icons.security, [
              _buildSwitchTile(
                'Biometric Authentication',
                'Use fingerprint or face unlock',
                _biometricEnabled,
                (value) => setState(() => _biometricEnabled = value),
              ),
              _buildSwitchTile(
                'Location Tracking',
                'Allow location tracking for check-ins',
                _locationTrackingEnabled,
                (value) => setState(() => _locationTrackingEnabled = value),
              ),
              _buildDataPrivacyTile(),
              _buildPermissionsTile(),
            ]),

            const SizedBox(height: 24),

            // Reports Settings
            _buildSection('Reports', Icons.analytics, [
              _buildSwitchTile(
                'Weekly Reports',
                'Receive weekly attendance summary',
                _weeklyReports,
                (value) => setState(() => _weeklyReports = value),
              ),
              _buildSwitchTile(
                'Monthly Reports',
                'Receive monthly attendance reports',
                _monthlyReports,
                (value) => setState(() => _monthlyReports = value),
              ),
              _buildReportFormatTile(),
              _buildAutoExportTile(),
            ]),

            const SizedBox(height: 24),

            // Data & Storage
            _buildSection('Data & Storage', Icons.storage, [
              _buildSwitchTile(
                'WiFi Only Backup',
                'Only backup data when connected to WiFi',
                _wifiOnlyBackup,
                (value) => setState(() => _wifiOnlyBackup = value),
              ),
              _buildStorageInfoTile(),
              _buildBackupRestoreTile(),
              _buildClearCacheTile(),
            ]),

            const SizedBox(height: 24),

            // About & Support
            _buildSection('About & Support', Icons.help, [
              _buildAboutTile(),
              _buildHelpCenterTile(),
              _buildContactSupportTile(),
              _buildPrivacyPolicyTile(),
              _buildTermsOfServiceTile(),
            ]),

            const SizedBox(height: 24),

            // Danger Zone
            _buildSection('Account Management', Icons.warning, [
              _buildExportDataTile(),
              _buildDeleteAccountTile(),
              _buildLogoutTile(),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTheme.headingSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildProfileTile() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.currentUser;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: user?.profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      user!.profileImage!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    user?.name[0].toUpperCase() ?? 'U',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          title: Text(
            user?.name ?? 'User Name',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            user?.email ?? 'user@example.com',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.edit),
          onTap: _showEditProfileDialog,
        );
      },
    );
  }

  Widget _buildThemeSelector() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        String currentTheme;
        switch (themeProvider.themeMode) {
          case ThemeMode.light:
            currentTheme = 'Light';
            break;
          case ThemeMode.dark:
            currentTheme = 'Dark';
            break;
          case ThemeMode.system:
            currentTheme = 'System';
            break;
        }

        return ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Theme'),
          subtitle: Text(currentTheme),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showThemeSelector,
        );
      },
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(_selectedLanguage),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showLanguageSelector,
    );
  }

  Widget _buildReminderFrequencySlider() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder Frequency',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${_reminderFrequency.round()} minutes before work hours',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Slider(
            value: _reminderFrequency,
            min: 5,
            max: 120,
            divisions: 23,
            onChanged: (value) => setState(() => _reminderFrequency = value),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursTile() {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: const Text('Working Hours'),
      subtitle: Text('$_workingHoursStart - $_workingHoursEnd'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showWorkingHoursDialog,
    );
  }

  Widget _buildChangePasswordTile() {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: const Text('Change Password'),
      subtitle: const Text('Update your account password'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showChangePasswordDialog,
    );
  }

  Widget _buildSecurityTile() {
    return ListTile(
      leading: const Icon(Icons.shield),
      title: const Text('Security Settings'),
      subtitle: const Text('Two-factor authentication, security keys'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showSecuritySettings,
    );
  }

  Widget _buildFontSizeSelector() {
    return ListTile(
      leading: const Icon(Icons.text_fields),
      title: const Text('Font Size'),
      subtitle: const Text('Medium'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showFontSizeDialog,
    );
  }

  Widget _buildBreakTimeTile() {
    return ListTile(
      leading: const Icon(Icons.coffee),
      title: const Text('Break Time'),
      subtitle: const Text('Configure lunch and break times'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showBreakTimeDialog,
    );
  }

  Widget _buildOvertimeSettingsTile() {
    return ListTile(
      leading: const Icon(Icons.trending_up),
      title: const Text('Overtime Settings'),
      subtitle: const Text('Configure overtime calculation'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showOvertimeSettingsDialog,
    );
  }

  Widget _buildDataPrivacyTile() {
    return ListTile(
      leading: const Icon(Icons.privacy_tip),
      title: const Text('Data Privacy'),
      subtitle: const Text('Manage your data privacy settings'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showDataPrivacySettings,
    );
  }

  Widget _buildPermissionsTile() {
    return ListTile(
      leading: const Icon(Icons.admin_panel_settings),
      title: const Text('App Permissions'),
      subtitle: const Text('Manage app permissions'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showPermissionsDialog,
    );
  }

  Widget _buildReportFormatTile() {
    return ListTile(
      leading: const Icon(Icons.file_copy),
      title: const Text('Report Format'),
      subtitle: const Text('PDF, Excel, CSV'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showReportFormatDialog,
    );
  }

  Widget _buildAutoExportTile() {
    return ListTile(
      leading: const Icon(Icons.cloud_upload),
      title: const Text('Auto Export'),
      subtitle: const Text('Automatically export reports'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showAutoExportDialog,
    );
  }

  Widget _buildStorageInfoTile() {
    return ListTile(
      leading: const Icon(Icons.pie_chart),
      title: const Text('Storage Usage'),
      subtitle: const Text('2.4 MB used of 100 MB'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showStorageInfo,
    );
  }

  Widget _buildBackupRestoreTile() {
    return ListTile(
      leading: const Icon(Icons.backup),
      title: const Text('Backup & Restore'),
      subtitle: const Text('Last backup: Today, 10:30 AM'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showBackupRestoreDialog,
    );
  }

  Widget _buildClearCacheTile() {
    return ListTile(
      leading: const Icon(Icons.clear_all),
      title: const Text('Clear Cache'),
      subtitle: const Text('Free up storage space'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showClearCacheDialog,
    );
  }

  Widget _buildAboutTile() {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text('About'),
      subtitle: const Text('Version 1.0.0 (Build 1)'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showAboutDialog,
    );
  }

  Widget _buildHelpCenterTile() {
    return ListTile(
      leading: const Icon(Icons.help_center),
      title: const Text('Help Center'),
      subtitle: const Text('FAQs, tutorials, and guides'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _openHelpCenter,
    );
  }

  Widget _buildContactSupportTile() {
    return ListTile(
      leading: const Icon(Icons.support_agent),
      title: const Text('Contact Support'),
      subtitle: const Text('Get help from our support team'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _contactSupport,
    );
  }

  Widget _buildPrivacyPolicyTile() {
    return ListTile(
      leading: const Icon(Icons.policy),
      title: const Text('Privacy Policy'),
      subtitle: const Text('Read our privacy policy'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _openPrivacyPolicy,
    );
  }

  Widget _buildTermsOfServiceTile() {
    return ListTile(
      leading: const Icon(Icons.description),
      title: const Text('Terms of Service'),
      subtitle: const Text('Read our terms of service'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _openTermsOfService,
    );
  }

  Widget _buildExportDataTile() {
    return ListTile(
      leading: const Icon(Icons.download, color: Colors.blue),
      title: const Text('Export My Data'),
      subtitle: const Text('Download all your data'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _exportUserData,
    );
  }

  Widget _buildDeleteAccountTile() {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
      subtitle: const Text('Permanently delete your account'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showDeleteAccountDialog,
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.orange),
      title: const Text('Logout', style: TextStyle(color: Colors.orange)),
      subtitle: const Text('Sign out of your account'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showLogoutDialog,
    );
  }

  // Method implementations
  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _biometricEnabled = true;
                _pushNotificationsEnabled = true;
                _emailNotificationsEnabled = false;
                _checkInReminders = true;
                _checkOutReminders = true;
                _weeklyReports = true;
                _monthlyReports = false;
                _locationTrackingEnabled = true;
                _wifiOnlyBackup = false;
                _selectedLanguage = 'English';
                _workingHoursStart = '09:00 AM';
                _workingHoursEnd = '06:00 PM';
                _reminderFrequency = 30;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              initialValue: Provider.of<UserProvider>(
                context,
                listen: false,
              ).currentUser?.name,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: Provider.of<UserProvider>(
                context,
                listen: false,
              ).currentUser?.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone'),
              initialValue: Provider.of<UserProvider>(
                context,
                listen: false,
              ).currentUser?.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Get current theme for selection display
    String getCurrentTheme() {
      switch (themeProvider.themeMode) {
        case ThemeMode.light:
          return 'Light';
        case ThemeMode.dark:
          return 'Dark';
        case ThemeMode.system:
          return 'System';
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          final currentTheme = getCurrentTheme();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Theme',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto),
                title: const Text('System'),
                trailing: currentTheme == 'System'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Light'),
                trailing: currentTheme == 'Light'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark'),
                trailing: currentTheme == 'Dark'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageSelector() {
    final languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Hindi',
      'Chinese',
    ];
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...languages.map(
            (language) => ListTile(
              title: Text(language),
              trailing: _selectedLanguage == language
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = language);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showWorkingHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Working Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(_workingHoursStart),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _workingHoursStart = time.format(context);
                  });
                }
              },
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(_workingHoursEnd),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _workingHoursEnd = time.format(context);
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Working hours updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Security Settings')),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Two-Factor Authentication'),
                subtitle: const Text('Add an extra layer of security'),
                value: false,
                onChanged: (value) {},
              ),
              ListTile(
                title: const Text('Security Keys'),
                subtitle: const Text('Manage your security keys'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Login History'),
                subtitle: const Text('View recent login activity'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    final fontSizes = ['Small', 'Medium', 'Large', 'Extra Large'];
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Font Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...fontSizes.map(
            (size) => ListTile(
              title: Text(size),
              trailing: size == 'Medium' ? const Icon(Icons.check) : null,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Font size set to $size')),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showBreakTimeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Break Time Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Lunch Break'),
              subtitle: const Text('12:00 PM - 1:00 PM'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Tea Break'),
              subtitle: const Text('3:30 PM - 3:45 PM'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOvertimeSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overtime Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Overtime Rate'),
              subtitle: const Text('1.5x regular rate'),
              trailing: const Icon(Icons.edit),
            ),
            ListTile(
              title: const Text('Minimum Overtime'),
              subtitle: const Text('30 minutes'),
              trailing: const Icon(Icons.edit),
            ),
            SwitchListTile(
              title: const Text('Auto Calculate'),
              subtitle: const Text('Automatic overtime calculation'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDataPrivacySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Data Privacy')),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Analytics'),
                subtitle: const Text('Share anonymous usage data'),
                value: false,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Crash Reports'),
                subtitle: const Text('Send crash reports to improve the app'),
                value: true,
                onChanged: (value) {},
              ),
              ListTile(
                title: const Text('Data Retention'),
                subtitle: const Text('Manage how long data is stored'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPermissionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Permissions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              subtitle: const Text('Allowed'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              subtitle: const Text('Allowed'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: const Text('Allowed'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportFormatDialog() {
    final formats = ['PDF', 'Excel', 'CSV'];
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Report Format',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...formats.map(
            (format) => ListTile(
              leading: Icon(_getFormatIcon(format)),
              title: Text(format),
              trailing: format == 'PDF' ? const Icon(Icons.check) : null,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Default report format set to $format'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  IconData _getFormatIcon(String format) {
    switch (format) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'Excel':
        return Icons.table_chart;
      case 'CSV':
        return Icons.description;
      default:
        return Icons.file_copy;
    }
  }

  void _showAutoExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto Export Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Auto Export'),
              subtitle: const Text('Automatically export reports'),
              value: false,
              onChanged: (value) {},
            ),
            ListTile(
              title: const Text('Export Frequency'),
              subtitle: const Text('Weekly'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              title: const Text('Export Location'),
              subtitle: const Text('Email'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Storage: 100 MB'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.024,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text('Breakdown:'),
            const SizedBox(height: 8),
            const Text('• Attendance Data: 1.8 MB'),
            const Text('• Profile Images: 0.4 MB'),
            const Text('• Cache: 0.2 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBackupRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Restore'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Create Backup'),
              subtitle: const Text('Backup your data to cloud'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup created successfully')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore Data'),
              subtitle: const Text('Restore from previous backup'),
              onTap: () {
                Navigator.pop(context);
                _showRestoreConfirmation();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRestoreConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data'),
        content: const Text(
          'This will replace all current data with backup data. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data restored successfully')),
              );
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear temporary files and free up storage space. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Attendance App',
      applicationVersion: '1.0.0 (Build 1)',
      applicationIcon: const Icon(Icons.access_time, size: 64),
      children: [
        const Text(
          'A comprehensive attendance tracking app for modern workplaces.',
        ),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• GPS-based check-in/out'),
        const Text('• QR code scanning'),
        const Text('• Detailed analytics'),
        const Text('• Leave management'),
      ],
    );
  }

  void _openHelpCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Help Center')),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.quiz),
                title: const Text('FAQs'),
                subtitle: const Text('Frequently asked questions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Video Tutorials'),
                subtitle: const Text('Learn how to use the app'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('User Guide'),
                subtitle: const Text('Complete user manual'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Contact Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email Support'),
            subtitle: const Text('support@attendanceapp.com'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening email client...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone Support'),
            subtitle: const Text('+1-800-123-4567'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening phone app...')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Live Chat'),
            subtitle: const Text('Chat with our support team'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Starting live chat...')),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Privacy Policy')),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Last updated: January 2024',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 24),
                Text(
                  'Information We Collect',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.',
                ),
                SizedBox(height: 16),
                Text(
                  'How We Use Your Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.',
                ),
                // Add more privacy policy content as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Terms of Service')),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms of Service',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Last updated: January 2024',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 24),
                Text(
                  'Acceptance of Terms',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.',
                ),
                SizedBox(height: 16),
                Text(
                  'Use License',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Permission is granted to temporarily use this application for personal, non-commercial transitory viewing only.',
                ),
                // Add more terms content as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _exportUserData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Your data will be exported and sent to your registered email address. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export initiated. Check your email.'),
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type "DELETE" to confirm account deletion:'),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Type DELETE here',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion initiated')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
