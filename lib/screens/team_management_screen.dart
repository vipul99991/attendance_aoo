import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _teamMembers = [
    {
      'id': '001',
      'name': 'Alice Johnson',
      'email': 'alice.johnson@company.com',
      'role': 'Senior Developer',
      'department': 'Engineering',
      'status': 'Present',
      'checkIn': '09:15 AM',
      'checkOut': null,
      'location': 'Office - Floor 5',
      'avatar': null,
      'phone': '+1 (555) 123-4567',
      'totalHours': '7.5h',
      'weeklyHours': '37.5h',
    },
    {
      'id': '002',
      'name': 'Bob Smith',
      'email': 'bob.smith@company.com',
      'role': 'UI/UX Designer',
      'department': 'Design',
      'status': 'On Leave',
      'checkIn': null,
      'checkOut': null,
      'location': null,
      'avatar': null,
      'phone': '+1 (555) 234-5678',
      'totalHours': '0h',
      'weeklyHours': '32h',
    },
    {
      'id': '003',
      'name': 'Carol Davis',
      'email': 'carol.davis@company.com',
      'role': 'Project Manager',
      'department': 'Management',
      'status': 'Work From Home',
      'checkIn': '08:45 AM',
      'checkOut': null,
      'location': 'Remote',
      'avatar': null,
      'phone': '+1 (555) 345-6789',
      'totalHours': '8h',
      'weeklyHours': '40h',
    },
    {
      'id': '004',
      'name': 'David Wilson',
      'email': 'david.wilson@company.com',
      'role': 'Backend Developer',
      'department': 'Engineering',
      'status': 'Late',
      'checkIn': '10:30 AM',
      'checkOut': null,
      'location': 'Office - Floor 3',
      'avatar': null,
      'phone': '+1 (555) 456-7890',
      'totalHours': '6.5h',
      'weeklyHours': '35h',
    },
    {
      'id': '005',
      'name': 'Eva Martinez',
      'email': 'eva.martinez@company.com',
      'role': 'QA Engineer',
      'department': 'Quality Assurance',
      'status': 'Present',
      'checkIn': '09:00 AM',
      'checkOut': '06:15 PM',
      'location': 'Office - Floor 4',
      'avatar': null,
      'phone': '+1 (555) 567-8901',
      'totalHours': '9.25h',
      'weeklyHours': '42h',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Management'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Team Status'),
            Tab(text: 'Analytics'),
            Tab(text: 'Reports'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddMemberDialog,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'export') {
                _exportTeamData();
              } else if (value == 'settings') {
                _showTeamSettings();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Team Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTeamStatusTab(),
          _buildAnalyticsTab(),
          _buildReportsTab(),
        ],
      ),
    );
  }

  Widget _buildTeamStatusTab() {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search team members...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All'),
                    _buildFilterChip('Present'),
                    _buildFilterChip('Absent'),
                    _buildFilterChip('On Leave'),
                    _buildFilterChip('Work From Home'),
                    _buildFilterChip('Late'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Team Summary Cards
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total',
                  '${_teamMembers.length}',
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Present',
                  '3',
                  Icons.check_circle,
                  AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Absent',
                  '1',
                  Icons.cancel,
                  AppTheme.errorColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Remote',
                  '1',
                  Icons.home_work,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Team Members List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _teamMembers.length,
            itemBuilder: (context, index) {
              final member = _teamMembers[index];
              return _buildTeamMemberCard(member);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? label : 'All';
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: color),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showMemberDetails(member),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 25,
                backgroundColor: _getStatusColor(
                  member['status'],
                ).withOpacity(0.2),
                child: member['avatar'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          member['avatar'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        member['name'][0].toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(member['status']),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 16),

              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      member['role'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(member['status']),
                          size: 16,
                          color: _getStatusColor(member['status']),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          member['status'],
                          style: TextStyle(
                            color: _getStatusColor(member['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (member['checkIn'] != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '• ${member['checkIn']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) => _handleMemberAction(value, member),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'message',
                    child: Row(
                      children: [
                        Icon(Icons.message),
                        SizedBox(width: 8),
                        Text('Send Message'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'call',
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 8),
                        Text('Call'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Analytics',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          // Analytics Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildAnalyticsCard(
                'Average Hours',
                '8.2h',
                Icons.access_time,
                Colors.blue,
              ),
              _buildAnalyticsCard(
                'Attendance Rate',
                '94%',
                Icons.percent,
                AppTheme.successColor,
              ),
              _buildAnalyticsCard(
                'On Time Rate',
                '87%',
                Icons.schedule,
                AppTheme.warningColor,
              ),
              _buildAnalyticsCard(
                'Remote Workers',
                '20%',
                Icons.home_work,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Department Breakdown
          Text(
            'Department Breakdown',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          _buildDepartmentCard('Engineering', 2, 85),
          _buildDepartmentCard('Design', 1, 90),
          _buildDepartmentCard('Management', 1, 95),
          _buildDepartmentCard('Quality Assurance', 1, 92),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentCard(
    String department,
    int members,
    int attendanceRate,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
          child: Text(
            department[0],
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(department, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '$members members',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$attendanceRate%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: attendanceRate >= 90
                    ? AppTheme.successColor
                    : AppTheme.warningColor,
              ),
            ),
            const Text(
              'Attendance',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Reports',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          // Quick Report Actions
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildReportAction(
                'Daily Report',
                'Today\'s attendance',
                Icons.today,
                () {},
              ),
              _buildReportAction(
                'Weekly Report',
                'Last 7 days',
                Icons.date_range,
                () {},
              ),
              _buildReportAction(
                'Monthly Report',
                'This month',
                Icons.calendar_month,
                () {},
              ),
              _buildReportAction(
                'Custom Report',
                'Select date range',
                Icons.tune,
                () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Reports
          Text(
            'Recent Reports',
            style: AppTheme.headingSmall.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 16),

          _buildRecentReportItem(
            'Team Attendance - Week 42',
            'Oct 14 - Oct 20, 2024',
            Icons.file_present,
          ),
          _buildRecentReportItem(
            'Monthly Performance Report',
            'October 2024',
            Icons.bar_chart,
          ),
          _buildRecentReportItem(
            'Leave Summary Report',
            'Q3 2024',
            Icons.event_busy,
          ),
        ],
      ),
    );
  }

  Widget _buildReportAction(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppTheme.primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReportItem(String title, String date, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        subtitle: Text(date),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report downloaded')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Report shared')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AppTheme.successColor;
      case 'absent':
        return AppTheme.errorColor;
      case 'on leave':
        return Colors.blue;
      case 'late':
        return AppTheme.warningColor;
      case 'work from home':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'on leave':
        return Icons.event_busy;
      case 'late':
        return Icons.schedule;
      case 'work from home':
        return Icons.home_work;
      default:
        return Icons.help_outline;
    }
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Team Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Role')),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Department'),
              items: const [
                DropdownMenuItem(
                  value: 'engineering',
                  child: Text('Engineering'),
                ),
                DropdownMenuItem(value: 'design', child: Text('Design')),
                DropdownMenuItem(
                  value: 'management',
                  child: Text('Management'),
                ),
                DropdownMenuItem(value: 'qa', child: Text('Quality Assurance')),
              ],
              onChanged: (value) {},
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
                const SnackBar(content: Text('Team member added successfully')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showMemberDetails(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Role: ${member['role']}'),
            Text('Department: ${member['department']}'),
            Text('Email: ${member['email']}'),
            Text('Phone: ${member['phone']}'),
            Text('Status: ${member['status']}'),
            if (member['checkIn'] != null)
              Text('Check In: ${member['checkIn']}'),
            if (member['checkOut'] != null)
              Text('Check Out: ${member['checkOut']}'),
            Text('Today: ${member['totalHours']}'),
            Text('This Week: ${member['weeklyHours']}'),
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

  void _handleMemberAction(String action, Map<String, dynamic> member) {
    switch (action) {
      case 'view':
        _showMemberDetails(member);
        break;
      case 'message':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Messaging ${member['name']}')));
        break;
      case 'call':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Calling ${member['phone']}')));
        break;
    }
  }

  void _exportTeamData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Team Data'),
        content: const Text('Choose export format and date range'),
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
                  content: Text('Team data exported successfully'),
                ),
              );
            },
            child: const Text('Export CSV'),
          ),
        ],
      ),
    );
  }

  void _showTeamSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Team Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Auto-sync attendance'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Email notifications'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Weekly reports'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
