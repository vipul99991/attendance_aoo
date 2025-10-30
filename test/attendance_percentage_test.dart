import 'package:flutter/foundation.dart';
import 'package:attendance_aoo/services/statistics_service.dart';
import 'package:attendance_aoo/models/employee_model.dart';

void main() {
  // Create test attendance records
  final records = [
    // Present days
    AttendanceRecord(
      id: '1',
      employeeId: 'emp1',
      date: DateTime.now(),
      status: AttendanceStatus.present,
    ),
    AttendanceRecord(
      id: '2',
      employeeId: 'emp1',
      date: DateTime.now().add(const Duration(days: 1)),
      status: AttendanceStatus.present,
    ),
    // Late days
    AttendanceRecord(
      id: '3',
      employeeId: 'emp1',
      date: DateTime.now().add(const Duration(days: 2)),
      status: AttendanceStatus.late,
    ),
    // Half days
    AttendanceRecord(
      id: '4',
      employeeId: 'emp1',
      date: DateTime.now().add(const Duration(days: 3)),
      status: AttendanceStatus.halfDay,
    ),
    AttendanceRecord(
      id: '5',
      employeeId: 'emp1',
      date: DateTime.now().add(const Duration(days: 4)),
      status: AttendanceStatus.halfDay,
    ),
    // Absent days
    AttendanceRecord(
      id: '6',
      employeeId: 'emp1',
      date: DateTime.now().add(const Duration(days: 5)),
      status: AttendanceStatus.absent,
    ),
  ];

  final service = StatisticsService();
  
  // Test calculateAttendanceStats
  final stats = service.calculateAttendanceStats(records: records);
  debugPrint('Attendance Stats:');
  debugPrint('Total Days: ${stats['total_days']}');
  debugPrint('Present Days: ${stats['present_days']}');
  debugPrint('Late Days: ${stats['late_days']}');
  debugPrint('Half Days: ${stats['half_days']}');
  debugPrint('Absent Days: ${stats['absent_days']}');
  debugPrint('Attendance Percentage: ${stats['attendance_percentage']}%');
  
  // Test getAttendancePercentage
  final percentage = service.getAttendancePercentage(records);
  debugPrint('\nAttendance Percentage (from getAttendancePercentage): $percentage%');
  
  // Manual calculation to verify
  // 2 present + 1 late + 2 half days (counted as 1 full day equivalent) = 4 effective days
  // Out of 6 total days = (4/6) * 100 = 66.67%
  final expectedPercentage = ((2 + 1 + (2 * 0.5)) / 6) * 100;
  debugPrint('\nExpected Percentage: ${expectedPercentage.toStringAsFixed(2)}%');
  
  // Verify that both methods return the same result
  if (stats['attendance_percentage'] == percentage) {
    debugPrint('\n✓ Both methods return the same result');
  } else {
    debugPrint('\n✗ Methods return different results');
  }
  
  // Verify the calculation is correct
  if ((stats['attendance_percentage'] - expectedPercentage).abs() < 0.01) {
    debugPrint('✓ Attendance percentage calculation is correct');
  } else {
    debugPrint('✗ Attendance percentage calculation is incorrect');
  }
}