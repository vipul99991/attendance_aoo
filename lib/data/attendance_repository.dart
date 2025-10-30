import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/employee_model.dart';
import '../utils/date_utils.dart';

/// Repository class for managing attendance data persistence
class AttendanceRepository {
  static const String _attendanceBoxName = 'attendance_records';
  Box? _attendanceBox;

  Future<void> initialize() async {
    _attendanceBox = await Hive.openBox(_attendanceBoxName);
  }

  Box get attendanceBox {
    if (_attendanceBox == null) {
      throw Exception('AttendanceRepository not initialized');
    }
    return _attendanceBox!;
  }

  /// Saves an attendance record to the database
  Future<void> saveAttendanceRecord(AttendanceRecord record) async {
    try {
      // Use a unique key that combines date and record ID to support multiple records per day
      final recordKey = '${DateUtils.formatDate(record.date)}_${record.id}';
      await attendanceBox.put(recordKey, record.toJson());
    } catch (e) {
      debugPrint('Error saving attendance record: $e');
      rethrow;
    }
  }

  /// Retrieves today's attendance record
  /// Prioritizes incomplete records (active sessions) over completed ones
  Future<AttendanceRecord?> getTodayAttendance() async {
    try {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final allRecords = await getAllAttendanceRecords();

      // Filter records for today (same date)
      final todayRecords = allRecords
          .where(
            (record) =>
                record.date.year == todayStart.year &&
                record.date.month == todayStart.month &&
                record.date.day == todayStart.day,
          )
          .toList();

      if (todayRecords.isEmpty) {
        return null;
      }

      // First priority: Return any incomplete record (checked in but not out)
      final incompleteRecords = todayRecords
          .where(
            (record) =>
                record.checkInTime != null && record.checkOutTime == null,
          )
          .toList();

      if (incompleteRecords.isNotEmpty) {
        // Sort by check-in time descending to get the most recent active session
        incompleteRecords.sort(
          (a, b) => b.checkInTime!.compareTo(a.checkInTime!),
        );
        return incompleteRecords.first;
      }

      // Second priority: Return the most recent completed record
      final completedRecords = todayRecords
          .where(
            (record) =>
                record.checkInTime != null && record.checkOutTime != null,
          )
          .toList();

      if (completedRecords.isNotEmpty) {
        completedRecords.sort(
          (a, b) => b.checkOutTime!.compareTo(a.checkOutTime!),
        );
        return completedRecords.first;
      }

      // Fallback: return any record for today
      todayRecords.sort(
        (a, b) => (b.checkInTime ?? DateTime(0)).compareTo(
          a.checkInTime ?? DateTime(0),
        ),
      );
      return todayRecords.first;
    } catch (e) {
      debugPrint('Error getting today attendance: $e');
      return null;
    }
  }

  /// Retrieves all attendance records
  Future<List<AttendanceRecord>> getAllAttendanceRecords() async {
    try {
      final records = attendanceBox.values.toList();
      final attendanceRecords =
          records
              .map(
                (record) => AttendanceRecord.fromJson(
                  Map<String, dynamic>.from(record),
                ),
              )
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
      return attendanceRecords;
    } catch (e) {
      debugPrint('Error getting all attendance records: $e');
      return [];
    }
  }

  /// Retrieves attendance records for a specific date range
  Future<List<AttendanceRecord>> getAttendanceForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allRecords = await getAllAttendanceRecords();
      final records = allRecords.where((record) {
        return record.date.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
            record.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      records.sort((a, b) => b.date.compareTo(a.date));
      return records;
    } catch (e) {
      debugPrint('Error getting attendance for date range: $e');
      return [];
    }
  }

  /// Gets a specific attendance record by date
  Future<AttendanceRecord?> getAttendanceForDate(DateTime date) async {
    try {
      final dateFormatted = DateUtils.formatDate(date);
      final allRecords = await getAllAttendanceRecords();
      final dateRecords = allRecords
          .where((record) => DateUtils.formatDate(record.date) == dateFormatted)
          .toList();

      // Return the first record for the date (or most recent if there are multiple)
      if (dateRecords.isNotEmpty) {
        // Sort by check-in time descending to get the most recent
        dateRecords.sort((a, b) => b.checkInTime!.compareTo(a.checkInTime!));
        return dateRecords.first;
      }

      return null;
    } catch (e) {
      debugPrint('Error getting attendance for date: $e');
      return null;
    }
  }

  /// Clears all attendance records (for testing purposes)
  Future<void> clearAllRecords() async {
    try {
      await attendanceBox.clear();
    } catch (e) {
      debugPrint('Error clearing all records: $e');
      rethrow;
    }
  }
}
