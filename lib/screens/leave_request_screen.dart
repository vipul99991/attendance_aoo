import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String _selectedLeaveType = 'sick';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now().add(const Duration(days: 1));
  bool _isHalfDay = false;
  String _halfDayType = 'morning';

  final List<Map<String, dynamic>> _leaveHistory = [
    {
      'type': 'Sick Leave',
      'from': DateTime(2024, 10, 10),
      'to': DateTime(2024, 10, 12),
      'status': 'Approved',
      'reason': 'Fever and cold',
    },
    {
      'type': 'Vacation',
      'from': DateTime(2024, 9, 15),
      'to': DateTime(2024, 9, 20),
      'status': 'Pending',
      'reason': 'Family vacation',
    },
    {
      'type': 'Personal',
      'from': DateTime(2024, 8, 5),
      'to': DateTime(2024, 8, 5),
      'status': 'Rejected',
      'reason': 'Personal work',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leave Requests'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Apply Leave'),
              Tab(text: 'Leave History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildApplyLeaveTab(), _buildLeaveHistoryTab()],
        ),
      ),
    );
  }

  Widget _buildApplyLeaveTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Type Selection
            Text(
              'Leave Type',
              style: AppTheme.headingSmall.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedLeaveType,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'sick', child: Text('🤒 Sick Leave')),
                  DropdownMenuItem(
                    value: 'vacation',
                    child: Text('🏖️ Vacation Leave'),
                  ),
                  DropdownMenuItem(
                    value: 'personal',
                    child: Text('👤 Personal Leave'),
                  ),
                  DropdownMenuItem(
                    value: 'emergency',
                    child: Text('🚨 Emergency Leave'),
                  ),
                  DropdownMenuItem(
                    value: 'maternity',
                    child: Text('👶 Maternity Leave'),
                  ),
                  DropdownMenuItem(
                    value: 'paternity',
                    child: Text('👨‍👶 Paternity Leave'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLeaveType = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // Half Day Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Half Day Leave'),
                    subtitle: const Text(
                      'Apply for half day instead of full day',
                    ),
                    value: _isHalfDay,
                    onChanged: (value) {
                      setState(() {
                        _isHalfDay = value;
                        if (_isHalfDay) {
                          _toDate = _fromDate;
                        }
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_isHalfDay) ...[
                    const Divider(),
                    RadioListTile<String>(
                      title: const Text('Morning (9 AM - 1 PM)'),
                      value: 'morning',
                      groupValue: _halfDayType,
                      onChanged: (value) {
                        setState(() {
                          _halfDayType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: const Text('Afternoon (1 PM - 6 PM)'),
                      value: 'afternoon',
                      groupValue: _halfDayType,
                      onChanged: (value) {
                        setState(() {
                          _halfDayType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date Selection
            Row(
              children: [
                Expanded(
                  child: _buildDateSelector('From Date', _fromDate, (date) {
                    setState(() {
                      _fromDate = date;
                      if (_isHalfDay || _toDate.isBefore(_fromDate)) {
                        _toDate = _fromDate;
                      }
                    });
                  }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _isHalfDay
                      ? Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Same Day',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : _buildDateSelector('To Date', _toDate, (date) {
                          setState(() {
                            _toDate = date;
                          });
                        }),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Days Count
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isHalfDay
                        ? 'Half Day Leave'
                        : 'Total Days: ${_toDate.difference(_fromDate).inDays + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Reason
            Text(
              'Reason',
              style: AppTheme.headingSmall.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Please provide a reason for your leave request...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide a reason for leave';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitLeaveRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Leave Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Leave Balance Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave Balance',
                    style: AppTheme.headingSmall.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBalanceItem('Sick Leave', '8', '12'),
                      _buildBalanceItem('Vacation', '15', '20'),
                      _buildBalanceItem('Personal', '3', '5'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime date,
    Function(DateTime) onDateChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              onDateChanged(selectedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM d, yyyy').format(date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceItem(String type, String used, String total) {
    return Column(
      children: [
        Text(
          '$used/$total',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          type,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLeaveHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _leaveHistory.length,
      itemBuilder: (context, index) {
        final leave = _leaveHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(leave['status']),
              child: Icon(_getStatusIcon(leave['status']), color: Colors.white),
            ),
            title: Text(
              leave['type'],
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('MMM d').format(leave['from'])} - ${DateFormat('MMM d, yyyy').format(leave['to'])}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Reason: ${leave['reason']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(leave['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(leave['status']),
                  width: 1,
                ),
              ),
              child: Text(
                leave['status'],
                style: TextStyle(
                  color: _getStatusColor(leave['status']),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onTap: () => _showLeaveDetails(leave),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.warningColor;
      case 'rejected':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  void _submitLeaveRequest() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit leave request to backend
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text(
            'Your leave request has been submitted successfully!',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _reasonController.clear();
                setState(() {
                  _fromDate = DateTime.now();
                  _toDate = DateTime.now().add(const Duration(days: 1));
                  _isHalfDay = false;
                  _selectedLeaveType = 'sick';
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showLeaveDetails(Map<String, dynamic> leave) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(leave['type']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${DateFormat('MMM d, yyyy').format(leave['from'])}'),
            Text('To: ${DateFormat('MMM d, yyyy').format(leave['to'])}'),
            Text('Status: ${leave['status']}'),
            Text('Reason: ${leave['reason']}'),
          ],
        ),
        actions: [
          if (leave['status'] == 'Pending')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Cancel leave request
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Leave request cancelled')),
                );
              },
              child: const Text('Cancel Request'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
