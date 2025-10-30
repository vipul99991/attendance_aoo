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
      final todayKey = DateUtils.formatDate(record.date);
      await attendanceBox.put(todayKey, record.toJson());
    } catch (e) {
      debugPrint('Error saving attendance record: $e');
      rethrow;
    }
 }

  /// Retrieves today's attendance record
  Future<AttendanceRecord?> getTodayAttendance() async {
    try {
      final today = DateTime.now();
      final todayKey = DateUtils.formatDate(today);
      final todayData = attendanceBox.get(todayKey);
      
      if (todayData != null) {
        return AttendanceRecord.fromJson(
          Map<String, dynamic>.from(todayData),
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error getting today attendance: $e');
      return null;
    }
  }

  /// Retrieves all attendance records
  Future<List<AttendanceRecord>> getAllAttendanceRecords() async {
    try {
      final records = attendanceBox.values.toList();
      return records
          .map((record) => AttendanceRecord.fromJson(Map<String, dynamic>.from(record)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
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
        return record.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
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
      final dateKey = DateUtils.formatDate(date);
      final data = attendanceBox.get(dateKey);
      
      if (data != null) {
        return AttendanceRecord.fromJson(
          Map<String, dynamic>.from(data),
        );
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