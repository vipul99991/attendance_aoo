import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_aoo/services/statistics_service.dart';
import 'package:attendance_aoo/models/employee_model.dart';

void main() {
  group('Comprehensive StatisticsService Tests', () {
    late StatisticsService service;
    late List<AttendanceRecord> testRecords;

    setUp(() {
      service = StatisticsService();
    });

    group('Input Validation Tests', () {
      test('should throw ArgumentError for null records', () {
        expect(
          () => service.calculateAttendanceStats(records: null),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('cannot be null'),
            ),
          ),
        );
      });

      test('should throw ArgumentError for records with null entries', () {
        final recordsWithNull =
            <AttendanceRecord?>[null] as List<AttendanceRecord>;
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
      });

      test('should throw ArgumentError for records with empty IDs', () {
        final recordWithEmptyId = AttendanceRecord(
          id: '', // Empty ID should trigger validation error
          employeeId: 'emp1',
          date: DateTime.now(),
          status: AttendanceStatus.present,
        );
        final recordsWithEmptyId = [recordWithEmptyId];
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
        'should throw ArgumentError for records with negative work time',
        () {
          final recordWithNegativeWorkTime = AttendanceRecord(
            id: 'neg1',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.present,
            totalWorkTime: Duration(hours: -1), // Negative duration
          );
          final recordsWithNegativeTime = [recordWithNegativeWorkTime];
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

      test('should throw ArgumentError for records with negative overtime', () {
        final recordWithNegativeOvertime = AttendanceRecord(
          id: 'neg2',
          employeeId: 'emp1',
          date: DateTime.now(),
          status: AttendanceStatus.present,
          overtimeHours: Duration(hours: -1), // Negative duration
        );
        final recordsWithNegativeOvertime = [recordWithNegativeOvertime];
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
      });
    });

    group('Mathematical Calculations Tests', () {
      test('should correctly calculate attendance percentage with half days', () {
        // Create test records with different attendance statuses
        testRecords = [
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
          AttendanceRecord(
            id: '3',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.late,
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
            status: AttendanceStatus.halfDay,
          ),
          AttendanceRecord(
            id: '6',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.absent,
          ),
        ];

        final stats = service.calculateAttendanceStats(records: testRecords);

        // With the new logic: 2 present + 1 late + 2 half days (counted as 1 full day equivalent) = 4 effective days
        // Out of 6 total days = (4/6) * 100 = 66.67%
        final expectedPercentage = ((2 + 1 + (2 * 0.5)) / 6) * 100;
        expect(
          stats['attendance_percentage'],
          moreOrLessEquals(expectedPercentage, epsilon: 0.01),
        );
        expect(stats['present_days'], 2);
        expect(stats['late_days'], 1);
        expect(stats['half_days'], 2);
        expect(stats['absent_days'], 1);
        expect(stats['total_days'], 6);
      });

      test(
        'should correctly calculate attendance percentage with all present days',
        () {
          testRecords = [
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
            AttendanceRecord(
              id: '3',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.present,
            ),
          ];

          final stats = service.calculateAttendanceStats(records: testRecords);
          expect(stats['attendance_percentage'], 100.0);
          expect(stats['present_days'], 3);
          expect(stats['total_days'], 3);
        },
      );

      test(
        'should correctly calculate attendance percentage with all absent days',
        () {
          testRecords = [
            AttendanceRecord(
              id: '1',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.absent,
            ),
            AttendanceRecord(
              id: '2',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.absent,
            ),
          ];

          final stats = service.calculateAttendanceStats(records: testRecords);
          expect(stats['attendance_percentage'], 0.0);
          expect(stats['absent_days'], 2);
          expect(stats['total_days'], 2);
        },
      );

      test(
        'should correctly calculate attendance percentage with all half days',
        () {
          testRecords = [
            AttendanceRecord(
              id: '1',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.halfDay,
            ),
            AttendanceRecord(
              id: '2',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.halfDay,
            ),
          ];

          final stats = service.calculateAttendanceStats(records: testRecords);
          // 2 half days = 1 full day equivalent out of 2 total days = 50%
          expect(stats['attendance_percentage'], 50.0);
          expect(stats['half_days'], 2);
          expect(stats['total_days'], 2);
        },
      );

      test(
        'should correctly calculate attendance percentage with late days',
        () {
          testRecords = [
            AttendanceRecord(
              id: '1',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.late,
            ),
            AttendanceRecord(
              id: '2',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.present,
            ),
          ];

          final stats = service.calculateAttendanceStats(records: testRecords);
          expect(stats['attendance_percentage'], 100.0);
          expect(stats['late_days'], 1);
          expect(stats['present_days'], 1);
          expect(stats['total_days'], 2);
        },
      );

      test('should handle empty records list', () {
        final stats = service.calculateAttendanceStats(records: []);
        expect(stats['total_days'], 0);
        expect(stats['attendance_percentage'], 0.0);
        expect(stats['present_days'], 0);
        expect(stats['absent_days'], 0);
        expect(stats['late_days'], 0);
        expect(stats['half_days'], 0);
        expect(stats['leave_days'], 0);
        expect(stats['work_from_home_days'], 0);
        expect(stats['holiday_days'], 0);
        expect(stats['total_counted_days'], 0);
        expect(stats['total_work_time'], 0);
        expect(stats['total_overtime_hours'], 0);
      });

      test('should calculate work time and overtime correctly', () {
        testRecords = [
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
        // Total work time: 8 + 7 = 15 hours
        expect(stats['total_work_time'], 15.0);
        // Total overtime: 2 + 1 = 3 hours
        expect(stats['total_overtime_hours'], 3.0);
      });
    });

    group('Parameter Linkages Tests', () {
      test('should return same percentage from both calculation methods', () {
        testRecords = [
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
            status: AttendanceStatus.absent,
          ),
        ];

        final stats = service.calculateAttendanceStats(records: testRecords);
        final percentage = service.getAttendancePercentage(testRecords);

        expect(stats['attendance_percentage'], percentage);
      });

      test('should return same day counts from both calculation methods', () {
        testRecords = [
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
          AttendanceRecord(
            id: '3',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.absent,
          ),
          AttendanceRecord(
            id: '4',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.leave,
          ),
        ];

        final stats = service.calculateAttendanceStats(records: testRecords);

        expect(stats['present_days'], service.getTotalPresentDays(testRecords));
        expect(stats['absent_days'], service.getTotalAbsentDays(testRecords));
        expect(stats['leave_days'], service.getTotalLeaveDays(testRecords));
      });

      test('should calculate average working hours correctly', () {
        testRecords = [
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
        // (8 + 6) / 2 = 7 hours average
        expect(average.inHours, 7);
      });

      test('should handle null totalWorkTime in average calculation', () {
        testRecords = [
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
            totalWorkTime: null, // No work time
          ),
        ];

        final average = service.getAverageWorkingHours(testRecords);
        // Only 1 record has valid work time (8 hours), so average is 8 hours
        expect(average.inHours, 8);
      });
    });

    group('Cross-Validation Checks Tests', () {
      test('should validate calculated stats correctly', () {
        testRecords = [
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
            status: AttendanceStatus.absent,
          ),
        ];

        final stats = service.calculateAttendanceStats(records: testRecords);
        final isValid = service.validateCalculatedStats(stats, testRecords);

        expect(isValid, true);
      });

      test('should detect invalid stats when total days mismatch', () {
        testRecords = [
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

        final stats = {
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

        final isValid = service.validateCalculatedStats(stats, testRecords);
        expect(isValid, false);
      });

      test('should detect invalid stats when day types sum mismatch', () {
        testRecords = [
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

        final stats = {
          'total_days': 2,
          'present_days': 3, // Incorrect - more than total days
          'late_days': 0,
          'half_days': 0,
          'absent_days': 0,
          'leave_days': 0,
          'work_from_home_days': 0,
          'holiday_days': 0,
          'total_counted_days': 3, // Should be 2
          'total_work_time': 0,
          'total_overtime_hours': 0,
          'attendance_percentage': 150.0, // Invalid percentage
        };

        final isValid = service.validateCalculatedStats(stats, testRecords);
        expect(isValid, false);
      });

      test(
        'should detect invalid stats when attendance percentage is wrong',
        () {
          testRecords = [
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

          final stats = {
            'total_days': 2,
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
            'attendance_percentage': 50.0, // Should be 100%
          };

          final isValid = service.validateCalculatedStats(stats, testRecords);
          expect(isValid, false);
        },
      );

      test('should detect negative work time values', () {
        testRecords = [
          AttendanceRecord(
            id: '1',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.present,
          ),
        ];

        final stats = {
          'total_days': 1,
          'present_days': 1,
          'late_days': 0,
          'half_days': 0,
          'absent_days': 0,
          'leave_days': 0,
          'work_from_home_days': 0,
          'holiday_days': 0,
          'total_counted_days': 1,
          'total_work_time': -5.0, // Negative value
          'total_overtime_hours': 0,
          'attendance_percentage': 100.0,
        };

        final isValid = service.validateCalculatedStats(stats, testRecords);
        expect(isValid, false);
      });

      test('should detect negative overtime values', () {
        testRecords = [
          AttendanceRecord(
            id: '1',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.present,
          ),
        ];

        final stats = {
          'total_days': 1,
          'present_days': 1,
          'late_days': 0,
          'half_days': 0,
          'absent_days': 0,
          'leave_days': 0,
          'work_from_home_days': 0,
          'holiday_days': 0,
          'total_counted_days': 1,
          'total_work_time': 8.0,
          'total_overtime_hours': -2.0, // Negative value
          'attendance_percentage': 100.0,
        };

        final isValid = service.validateCalculatedStats(stats, testRecords);
        expect(isValid, false);
      });

      test('should perform comprehensive validation correctly', () {
        testRecords = [
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
            status: AttendanceStatus.absent,
          ),
        ];

        final stats = service.calculateAttendanceStats(records: testRecords);
        final validationResults = service.performComprehensiveValidation(
          stats,
          testRecords,
        );

        // Should have no errors or warnings for valid data
        expect(validationResults.containsKey('errors'), false);
        expect(validationResults.containsKey('warnings'), false);
      });

      test('should detect errors in comprehensive validation', () {
        testRecords = [
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

        final stats = {
          'total_days': 3, // Incorrect
          'present_days': 3, // Incorrect
          'late_days': 0,
          'half_days': 0,
          'absent_days': 0,
          'leave_days': 0,
          'work_from_home_days': 0,
          'holiday_days': 0,
          'total_counted_days': 3, // Incorrect
          'total_work_time': 0,
          'total_overtime_hours': 0,
          'attendance_percentage': 150.0, // Invalid
        };

        final validationResults = service.performComprehensiveValidation(
          stats,
          testRecords,
        );

        // Should have errors
        expect(validationResults.containsKey('errors'), true);
        expect(validationResults['errors'], isA<List<String>>());
        expect(validationResults['errors']!.length, greaterThan(0));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle records with all status types', () {
        testRecords = [
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
            status: AttendanceStatus.absent,
          ),
          AttendanceRecord(
            id: '5',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.leave,
          ),
          AttendanceRecord(
            id: '6',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.workFromHome,
          ),
          AttendanceRecord(
            id: '7',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.holiday,
          ),
        ];

        final stats = service.calculateAttendanceStats(records: testRecords);

        expect(stats['total_days'], 7);
        expect(stats['present_days'], 1);
        expect(stats['late_days'], 1);
        expect(stats['half_days'], 1);
        expect(stats['absent_days'], 1);
        expect(stats['leave_days'], 1);
        expect(stats['work_from_home_days'], 1);
        expect(stats['holiday_days'], 1);
        // Total counted days should exclude holidays: 6
        expect(stats['total_counted_days'], 6);
      });

      test('should handle null records gracefully in individual methods', () {
        expect(service.getTotalPresentDays(null), 0);
        expect(service.getTotalAbsentDays(null), 0);
        expect(service.getTotalLeaveDays(null), 0);
        expect(service.getAttendancePercentage(null), 0.0);
        expect(service.getAverageWorkingHours(null), Duration.zero);
      });

      test('should handle records with holidays correctly', () {
        testRecords = [
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
          AttendanceRecord(
            id: '4',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.holiday,
          ),
        ];

        final stats = service.calculateAttendanceStats(records: testRecords);

        expect(stats['total_days'], 4);
        expect(stats['present_days'], 2);
        expect(stats['holiday_days'], 2);
        // Total counted days should exclude holidays: 2
        expect(stats['total_counted_days'], 2);
        // Attendance percentage should be calculated based on counted days (2 present out of 2 counted) = 10%
        expect(stats['attendance_percentage'], 100.0);
      });

      test(
        'should handle records with negative values gracefully in validation',
        () {
          testRecords = [
            AttendanceRecord(
              id: '1',
              employeeId: 'emp1',
              date: DateTime.now(),
              status: AttendanceStatus.present,
            ),
          ];

          final stats = {
            'total_days': -1, // Invalid
            'present_days': -1, // Invalid
            'late_days': -1, // Invalid
            'half_days': -1, // Invalid
            'absent_days': -1, // Invalid
            'leave_days': -1, // Invalid
            'work_from_home_days': -1, // Invalid
            'holiday_days': -1, // Invalid
            'total_counted_days': -1, // Invalid
            'total_work_time': -1.0, // Invalid
            'total_overtime_hours': -1.0, // Invalid
            'attendance_percentage': -1.0, // Invalid
          };

          final validationResults = service.performComprehensiveValidation(
            stats,
            testRecords,
          );

          expect(validationResults.containsKey('errors'), true);
          expect(validationResults['errors'], isA<List<String>>());
          expect(validationResults['errors']!.length, greaterThan(0));
        },
      );

      test('should handle large number of records efficiently', () {
        // Create 100 records to test performance
        testRecords = [];
        for (int i = 0; i < 1000; i++) {
          testRecords.add(
            AttendanceRecord(
              id: 'id_$i',
              employeeId: 'emp1',
              date: DateTime.now().add(Duration(days: i)),
              status: i % 3 == 0
                  ? AttendanceStatus.present
                  : i % 3 == 1
                  ? AttendanceStatus.late
                  : AttendanceStatus.absent,
            ),
          );
        }

        final stopwatch = Stopwatch()..start();
        final stats = service.calculateAttendanceStats(records: testRecords);
        stopwatch.stop();

        // Should complete in reasonable time (less than 1 second)
        expect(stopwatch.elapsed.inMilliseconds, lessThan(100));

        // Should have correct total
        expect(stats['total_days'], 1000);
      });
    });

    group('Integration Tests', () {
      test('should maintain consistency across all components', () {
        testRecords = [
          AttendanceRecord(
            id: '1',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.present,
            totalWorkTime: Duration(hours: 8),
            overtimeHours: Duration(hours: 1),
          ),
          AttendanceRecord(
            id: '2',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.late,
            totalWorkTime: Duration(hours: 7),
            overtimeHours: Duration(hours: 0),
          ),
          AttendanceRecord(
            id: '3',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.halfDay,
            totalWorkTime: Duration(hours: 4),
            overtimeHours: Duration(hours: 0),
          ),
          AttendanceRecord(
            id: '4',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.absent,
            totalWorkTime: Duration.zero,
            overtimeHours: Duration.zero,
          ),
        ];

        // Calculate stats
        final stats = service.calculateAttendanceStats(records: testRecords);

        // Verify all components work together
        expect(stats['total_days'], 4);
        expect(stats['present_days'], 1);
        expect(stats['late_days'], 1);
        expect(stats['half_days'], 1);
        expect(stats['absent_days'], 1);
        expect(stats['total_counted_days'], 3); // Excluding the absent day
        expect(stats['total_work_time'], 19.0); // 8 + 7 + 4 = 19 hours
        expect(stats['total_overtime_hours'], 1.0); // 1 + 0 + 0 + 0 = 1 hour
        expect(
          stats['attendance_percentage'],
          moreOrLessEquals(66.67, epsilon: 0.01),
        ); // (1 + 1 + 0.5) / 3 * 100

        // Verify cross-validation passes
        final isValid = service.validateCalculatedStats(stats, testRecords);
        expect(isValid, true);

        // Verify comprehensive validation passes
        final validationResults = service.performComprehensiveValidation(
          stats,
          testRecords,
        );
        expect(validationResults.containsKey('errors'), false);
      });

      test('should handle complex scenarios with multiple employees', () {
        // Create records for multiple employees
        final employee1Records = [
          AttendanceRecord(
            id: 'e1_1',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.present,
          ),
          AttendanceRecord(
            id: 'e1_2',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.late,
          ),
          AttendanceRecord(
            id: 'e1_3',
            employeeId: 'emp1',
            date: DateTime.now(),
            status: AttendanceStatus.halfDay,
          ),
        ];

        final employee2Records = [
          AttendanceRecord(
            id: 'e2_1',
            employeeId: 'emp2',
            date: DateTime.now(),
            status: AttendanceStatus.present,
          ),
          AttendanceRecord(
            id: 'e2_2',
            employeeId: 'emp2',
            date: DateTime.now(),
            status: AttendanceStatus.absent,
          ),
          AttendanceRecord(
            id: 'e2_3',
            employeeId: 'emp2',
            date: DateTime.now(),
            status: AttendanceStatus.leave,
          ),
        ];

        // Test each employee separately
        final emp1Stats = service.calculateAttendanceStats(
          records: employee1Records,
        );
        final emp2Stats = service.calculateAttendanceStats(
          records: employee2Records,
        );

        // Verify employee 1 stats
        expect(emp1Stats['total_days'], 3);
        expect(emp1Stats['present_days'], 1);
        expect(emp1Stats['late_days'], 1);
        expect(emp1Stats['half_days'], 1);
        expect(
          emp1Stats['attendance_percentage'],
          moreOrLessEquals(66.67, epsilon: 0.01),
        ); // (1 + 1 + 0.5) / 3 * 100

        // Verify employee 2 stats
        expect(emp2Stats['total_days'], 3);
        expect(emp2Stats['present_days'], 1);
        expect(emp2Stats['absent_days'], 1);
        expect(emp2Stats['leave_days'], 1);
        expect(
          emp2Stats['attendance_percentage'],
          moreOrLessEquals(66.67, epsilon: 0.01),
        ); // (1 + 0 + 0) / 3 * 100

        // Verify validations pass for both
        expect(
          service.validateCalculatedStats(emp1Stats, employee1Records),
          true,
        );
        expect(
          service.validateCalculatedStats(emp2Stats, employee2Records),
          true,
        );
      });
    });
  });
}
