import 'package:flutter/foundation.dart';
import 'package:attendance_aoo/services/statistics_service.dart';
import 'package:attendance_aoo/models/employee_model.dart';

void main() {
  debugPrint('Running Simple Statistics Service Tests...');

  final service = StatisticsService();
  int passedTests = 0;
  int totalTests = 0;

  // Test 1: Input validation for null records
  totalTests++;
  bool test1Passed = false;
  try {
    service.calculateAttendanceStats(records: null);
    debugPrint('❌ Test 1 failed: Should throw error for null records');
  } catch (e) {
    if (e is ArgumentError && e.message.contains('cannot be null')) {
      debugPrint('✅ Test 1 passed: Input validation for null records');
      test1Passed = true;
    } else {
      debugPrint('❌ Test 1 failed: Wrong error type for null records: $e');
    }
  }
  if (test1Passed) passedTests++;

  // Test 2: Attendance percentage calculation with half days
  totalTests++;
  bool test2Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.late,
      ),
      AttendanceRecord(
        id: '3',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.halfDay,
      ),
      AttendanceRecord(
        id: '4',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.halfDay,
      ),
      AttendanceRecord(
        id: '5',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.absent,
      ),
    ];

    final stats = service.calculateAttendanceStats(records: testRecords);

    // Expected: (2 present + 1 late + 2 half days * 0.5) / 5 total days * 100 = 80%
    final expectedPercentage = ((2 + 1 + (2 * 0.5)) / 5) * 100;
    final percentageMatch =
        ((stats['attendance_percentage'] as double) - expectedPercentage)
            .abs() <
        0.01;

    if (percentageMatch &&
        stats['present_days'] == 2 &&
        stats['late_days'] == 1 &&
        stats['half_days'] == 2 &&
        stats['absent_days'] == 1 &&
        stats['total_days'] == 5) {
      debugPrint(
        '✅ Test 2 passed: Attendance percentage calculation with half days',
      );
      test2Passed = true;
    } else {
      debugPrint(
        '❌ Test 2 failed: Attendance percentage calculation. Got: ${stats['attendance_percentage']}, Expected: $expectedPercentage',
      );
      debugPrint(
        'Details: Present: ${stats['present_days']}, Late: ${stats['late_days']}, Half: ${stats['half_days']}, Absent: ${stats['absent_days']}',
      );
    }
  } catch (e) {
    debugPrint('❌ Test 2 failed with error: $e');
  }
  if (test2Passed) passedTests++;

  // Test 3: Cross-validation check
  totalTests++;
  bool test3Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.late,
      ),
      AttendanceRecord(
        id: '3',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.halfDay,
      ),
    ];

    final stats = service.calculateAttendanceStats(records: testRecords);
    final isValid = service.validateCalculatedStats(stats, testRecords);

    if (isValid) {
      debugPrint('✅ Test 3 passed: Cross-validation check');
      test3Passed = true;
    } else {
      debugPrint('❌ Test 3 failed: Cross-validation check failed');
    }
  } catch (e) {
    debugPrint('❌ Test 3 failed with error: $e');
  }
  if (test3Passed) passedTests++;

  // Test 4: Parameter linkage consistency
  totalTests++;
  bool test4Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.absent,
      ),
    ];

    final stats = service.calculateAttendanceStats(records: testRecords);
    final percentage = service.getAttendancePercentage(testRecords);

    if (stats['attendance_percentage'] == percentage) {
      debugPrint('✅ Test 4 passed: Parameter linkage consistency');
      test4Passed = true;
    } else {
      debugPrint(
        '❌ Test 4 failed: Parameter linkage inconsistency. Stats: ${stats['attendance_percentage']}, Method: $percentage',
      );
    }
  } catch (e) {
    debugPrint('❌ Test 4 failed with error: $e');
  }
  if (test4Passed) passedTests++;

  // Test 5: Work time and overtime calculation
  totalTests++;
  bool test5Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
        totalWorkTime: Duration(hours: 8),
        overtimeHours: Duration(hours: 2),
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
        totalWorkTime: Duration(hours: 7),
        overtimeHours: Duration(hours: 1),
      ),
    ];

    final stats = service.calculateAttendanceStats(records: testRecords);

    if (stats['total_work_time'] == 15.0 &&
        stats['total_overtime_hours'] == 3.0) {
      debugPrint('✅ Test 5 passed: Work time and overtime calculation');
      test5Passed = true;
    } else {
      debugPrint(
        '❌ Test 5 failed: Work time calculation. Got work: ${stats['total_work_time']}, overtime: ${stats['total_overtime_hours']}',
      );
    }
  } catch (e) {
    debugPrint('❌ Test 5 failed with error: $e');
  }
  if (test5Passed) passedTests++;

  // Test 6: Comprehensive validation
  totalTests++;
  bool test6Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.late,
      ),
    ];

    final stats = service.calculateAttendanceStats(records: testRecords);
    final validationResults = service.performComprehensiveValidation(
      stats,
      testRecords,
    );

    if (!validationResults.containsKey('errors')) {
      debugPrint('✅ Test 6 passed: Comprehensive validation');
      test6Passed = true;
    } else {
      debugPrint(
        '❌ Test 6 failed: Comprehensive validation has errors: ${validationResults['errors']}',
      );
    }
  } catch (e) {
    debugPrint('❌ Test 6 failed with error: $e');
  }
  if (test6Passed) passedTests++;

  // Test 7: Edge case with holidays
  totalTests++;
  bool test7Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.holiday,
      ),
      AttendanceRecord(
        id: '3',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
    ];

    final stats = service.calculateAttendanceStats(records: testRecords);

    if (stats['total_days'] == 3 &&
        stats['present_days'] == 2 &&
        stats['holiday_days'] == 1 &&
        stats['total_counted_days'] == 2) {
      debugPrint('✅ Test 7 passed: Holiday handling');
      test7Passed = true;
    } else {
      debugPrint(
        '❌ Test 7 failed: Holiday handling. Total: ${stats['total_days']}, Present: ${stats['present_days']}, Holidays: ${stats['holiday_days']}, Counted: ${stats['total_counted_days']}',
      );
    }
  } catch (e) {
    debugPrint('❌ Test 7 failed with error: $e');
  }
  if (test7Passed) passedTests++;

  // Test 8: Empty records
  totalTests++;
  bool test8Passed = false;
  try {
    final stats = service.calculateAttendanceStats(records: []);

    if (stats['total_days'] == 0 &&
        stats['attendance_percentage'] == 0.0 &&
        stats['present_days'] == 0) {
      debugPrint('✅ Test 8 passed: Empty records handling');
      test8Passed = true;
    } else {
      debugPrint('❌ Test 8 failed: Empty records handling');
    }
  } catch (e) {
    debugPrint('❌ Test 8 failed with error: $e');
  }
  if (test8Passed) passedTests++;

  // Test 9: Average working hours calculation
  totalTests++;
  bool test9Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
        totalWorkTime: Duration(hours: 8),
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
        totalWorkTime: Duration(hours: 6),
      ),
    ];

    final average = service.getAverageWorkingHours(testRecords);

    if (average.inHours == 7) {
      debugPrint('✅ Test 9 passed: Average working hours calculation');
      test9Passed = true;
    } else {
      debugPrint(
        '❌ Test 9 failed: Average working hours calculation. Got: ${average.inHours}, Expected: 7',
      );
    }
  } catch (e) {
    debugPrint('❌ Test 9 failed with error: $e');
  }
  if (test9Passed) passedTests++;

  // Test 10: Validation detects invalid stats
  totalTests++;
  bool test10Passed = false;
  try {
    final testRecords = [
      AttendanceRecord(
        id: '1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: '2',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      ),
    ];

    final invalidStats = {
      'total_days': 3, // Incorrect - should be 2
      'present_days': 2,
      'late_days': 0,
      'half_days': 0,
      'absent_days': 0,
      'leave_days': 0,
      'work_from_home_days': 0,
      'holiday_days': 0,
      'total_counted_days': 2,
      'total_work_time': 0,
      'total_overtime_hours': 0,
      'attendance_percentage': 100.0,
    };

    final isValid = service.validateCalculatedStats(invalidStats, testRecords);

    if (!isValid) {
      debugPrint('✅ Test 10 passed: Validation detects invalid stats');
      test10Passed = true;
    } else {
      debugPrint(
        '❌ Test 10 failed: Validation should detect invalid stats but didn\'t',
      );
    }
  } catch (e) {
    debugPrint('❌ Test 10 failed with error: $e');
  }
  if (test10Passed) passedTests++;

  debugPrint('\nFinal Test Results: $passedTests/$totalTests tests passed');

  if (passedTests == totalTests) {
    debugPrint(
      '🎉 All tests passed! The statistics service is working correctly.',
    );
  } else {
    debugPrint(
      '⚠️ Some tests failed. Please review the statistics service implementation.',
    );
  }
}
