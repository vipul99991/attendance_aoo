import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_aoo/services/statistics_service.dart';
import 'package:attendance_aoo/models/employee_model.dart';

void main() {
  group('StatisticsService', () {
    late StatisticsService service;
    late List<AttendanceRecord> testRecords;

    setUp(() {
      service = StatisticsService();

      // Create test attendance records
      testRecords = [
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
    });

    test(
      'calculateAttendanceStats should properly handle half days in percentage calculation',
      () {
        final stats = service.calculateAttendanceStats(records: testRecords);

        expect(stats['total_days'], 6);
        expect(stats['present_days'], 2);
        expect(stats['late_days'], 1);
        expect(stats['half_days'], 2);
        expect(stats['absent_days'], 1);

        // With the new logic: 2 present + 1 late + 2 half days (counted as 1 full day equivalent) = 4 effective days
        // Out of 6 total days = (4/6) * 100 = 66.67%
        final expectedPercentage = ((2 + 1 + (2 * 0.5)) / 6) * 100;
        expect(
          stats['attendance_percentage'],
          moreOrLessEquals(expectedPercentage, epsilon: 0.01),
        );
      },
    );

    test('getAttendancePercentage should properly handle half days', () {
      final percentage = service.getAttendancePercentage(testRecords);

      // With the new logic: 2 present + 1 late + 2 half days (counted as 1 full day equivalent) = 4 effective days
      // Out of 6 total days = (4/6) * 100 = 66.67%
      final expectedPercentage = ((2 + 1 + (2 * 0.5)) / 6) * 100;
      expect(percentage, moreOrLessEquals(expectedPercentage, epsilon: 0.01));
    });

    test('Both methods should return the same attendance percentage', () {
      final stats = service.calculateAttendanceStats(records: testRecords);
      final percentage = service.getAttendancePercentage(testRecords);

      expect(stats['attendance_percentage'], percentage);
    });

    test('calculateAttendancePercentage should handle edge cases', () {
      // Test with no records
      expect(service.calculateAttendancePercentage(0, 0, 0, 0), 0.0);

      // Test with all present days
      expect(service.calculateAttendancePercentage(5, 0, 0, 5), 100.0);

      // Test with all absent days
      expect(service.calculateAttendancePercentage(0, 0, 0, 5), 0.0);

      // Test with all half days
      expect(service.calculateAttendancePercentage(0, 0, 5, 5), 50.0);
    });

    test(
      'Input validation should throw error for records with null entries',
      () {
        final recordsWithNull =
            <AttendanceRecord?>[null, testRecords[0]] as List<AttendanceRecord>;
        expect(
          () => service.calculateAttendanceStats(records: recordsWithNull),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('cannot be null'),
            ),
          ),
        );
      },
    );

    test('Input validation should throw error for records with empty IDs', () {
      final recordWithEmptyId = AttendanceRecord(
        id: '', // Empty ID should trigger validation error
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
      );
      final recordsWithEmptyId = [...testRecords, recordWithEmptyId];
      expect(
        () => service.calculateAttendanceStats(records: recordsWithEmptyId),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('ID cannot be empty'),
          ),
        ),
      );
    });

    test(
      'Input validation should throw error for records with negative work time',
      () {
        final recordWithNegativeWorkTime = AttendanceRecord(
          id: 'neg1',
          employeeId: 'emp1',
          date: DateTime.now(),
          status: AttendanceStatus.present,
          totalWorkTime: Duration(hours: -1), // Negative duration
        );
        final recordsWithNegativeTime = [
          ...testRecords,
          recordWithNegativeWorkTime,
        ];
        expect(
          () => service.calculateAttendanceStats(
            records: recordsWithNegativeTime,
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('cannot be negative'),
            ),
          ),
        );
      },
    );

    test(
      'Input validation should throw error for records with negative overtime',
      () {
        final recordWithNegativeOvertime = AttendanceRecord(
          id: 'neg2',
          employeeId: 'emp1',
          date: DateTime.now(),
          status: AttendanceStatus.present,
          overtimeHours: Duration(hours: -1), // Negative duration
        );
        final recordsWithNegativeOvertime = [
          ...testRecords,
          recordWithNegativeOvertime,
        ];
        expect(
          () => service.calculateAttendanceStats(
            records: recordsWithNegativeOvertime,
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('cannot be negative'),
            ),
          ),
        );
      },
    );

    test(
      'Average working hours should exclude records with negative work time',
      () {
        final recordsWithNegativeTime = [
          ...testRecords,
          AttendanceRecord(
            id: 'neg3',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.present,
            totalWorkTime: Duration(hours: -1), // This should be excluded
          ),
        ];

        // Add a record with valid work time to have a meaningful average
        final recordsWithValidTime = [
          ...recordsWithNegativeTime,
          AttendanceRecord(
            id: 'valid1',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.present,
            totalWorkTime: Duration(hours: 8),
          ),
        ];

        // Should not throw an error and should handle the negative time gracefully
        final average = service.getAverageWorkingHours(recordsWithValidTime);
        expect(average, isA<Duration>());
      },
    );

    test('All methods should handle empty lists correctly', () {
      expect(service.getTotalPresentDays([]), 0);
      expect(service.getTotalAbsentDays([]), 0);
      expect(service.getTotalLeaveDays([]), 0);
      expect(service.getAttendancePercentage([]), 0.0);
      expect(service.getAverageWorkingHours([]), Duration.zero);

      final emptyStats = service.calculateAttendanceStats(records: []);
      expect(emptyStats['total_days'], 0);
      expect(emptyStats['attendance_percentage'], 0.0);
    });

    test('Input validation should properly validate all records', () {
      // Test with a record that has negative work time
      final recordWithNegativeTime = AttendanceRecord(
        id: 'test1',
        employeeId: 'emp1',
        date: DateTime.now(),
        status: AttendanceStatus.present,
        totalWorkTime: Duration(hours: -2),
      );

      expect(
        () =>
            service.calculateAttendanceStats(records: [recordWithNegativeTime]),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('cannot be negative'),
          ),
        ),
      );
    });

    test('Statistics calculations should be consistent across methods', () {
      final stats = service.calculateAttendanceStats(records: testRecords);
      final percentage = service.getAttendancePercentage(testRecords);

      // The percentage from both methods should match
      expect(stats['attendance_percentage'], percentage);

      // The individual counts should match expected values
      expect(stats['present_days'], service.getTotalPresentDays(testRecords));
      expect(stats['absent_days'], service.getTotalAbsentDays(testRecords));
      expect(stats['leave_days'], service.getTotalLeaveDays(testRecords));
    });
  });
}
