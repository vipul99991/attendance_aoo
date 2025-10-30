import 'package:flutter/foundation.dart';
import '../models/employee_model.dart';

/// Service class for calculating attendance statistics and metrics
class StatisticsService {
  /// Calculates attendance statistics for a given date range
 Map<String, dynamic> calculateAttendanceStats({
    required List<AttendanceRecord> records,
  }) {
    try {
      int presentDays = 0;
      int lateDays = 0;
      int halfDays = 0;
      int absentDays = 0;
      Duration totalWorkTime = Duration.zero;
      Duration totalOvertimeHours = Duration.zero;

      for (final record in records) {
        switch (record.status) {
          case AttendanceStatus.present:
            presentDays++;
            break;
          case AttendanceStatus.late:
            lateDays++;
            break;
          case AttendanceStatus.halfDay:
            halfDays++;
            break;
          case AttendanceStatus.absent:
            absentDays++;
            break;
          default:
            break;
        }

        if (record.totalWorkTime != null) {
          totalWorkTime += record.totalWorkTime!;
        }
        if (record.overtimeHours != null) {
          totalOvertimeHours += record.overtimeHours!;
        }
      }

      return {
        'total_days': records.length,
        'present_days': presentDays,
        'late_days': lateDays,
        'half_days': halfDays,
        'absent_days': absentDays,
        'total_work_time': totalWorkTime.inHours,
        'total_overtime_hours': totalOvertimeHours.inHours,
        'attendance_percentage': records.isEmpty
            ? 0.0
            : (presentDays + lateDays + halfDays) / records.length * 100,
      };
    } catch (e) {
      debugPrint('Error calculating attendance stats: $e');
      return {
        'total_days': 0,
        'present_days': 0,
        'late_days': 0,
        'half_days': 0,
        'absent_days': 0,
        'total_work_time': 0,
        'total_overtime_hours': 0,
        'attendance_percentage': 0.0,
      };
    }
  }

  /// Calculates total present days
  int getTotalPresentDays(List<AttendanceRecord> records) {
    return records
        .where((record) => record.status == AttendanceStatus.present)
        .length;
  }

  /// Calculates total absent days
  int getTotalAbsentDays(List<AttendanceRecord> records) {
    return records
        .where((record) => record.status == AttendanceStatus.absent)
        .length;
  }

  /// Calculates total leave days
  int getTotalLeaveDays(List<AttendanceRecord> records) {
    return records
        .where((record) => record.status == AttendanceStatus.leave)
        .length;
  }

  /// Calculates attendance percentage
  double getAttendancePercentage(List<AttendanceRecord> records) {
    if (records.isEmpty) return 0.0;
    final presentDays = getTotalPresentDays(records);
    final lateDays = records
        .where((record) => record.status == AttendanceStatus.late)
        .length;
    final halfDays = records
        .where((record) => record.status == AttendanceStatus.halfDay)
        .length;
    return (presentDays + lateDays + halfDays) / records.length * 100;
  }

  /// Calculates average working hours
  Duration getAverageWorkingHours(List<AttendanceRecord> records) {
    final presentRecords = records
        .where((record) => record.totalWorkTime != null)
        .toList();

    if (presentRecords.isEmpty) return Duration.zero;

    final totalMilliseconds = presentRecords
        .map((record) => record.totalWorkTime!.inMilliseconds)
        .fold<int>(0, (a, b) => a + b);

    return Duration(milliseconds: totalMilliseconds ~/ presentRecords.length);
  }
}