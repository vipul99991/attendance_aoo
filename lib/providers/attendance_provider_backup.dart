import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/employee_model.dart';
import '../models/attendance_model.dart';
import '../models/attendance.dart' as AttendanceModel;
import '../models/attendance.dart' show AttendanceStatus as ExternalAttendanceStatus;
import '../services/location_service.dart';
import '../services/camera_service.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
// Remove local enum to use the one from models
enum AttendanceStatus { present, absent, onLeave }

class Attendance {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInLocation;
  final ExternalAttendanceStatus status;
  final AttendanceStatus status;
  final String? notes;
  final Duration? totalHours;
  final bool isLateCheckIn;
  final bool isEarlyCheckOut;

  const Attendance({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    required this.status,
    this.notes,
    this.totalHours,
    this.isLateCheckIn = false,
    this.isEarlyCheckOut = false,
  });

  Attendance copyWith({
    String? id,
    String? userId,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInLocation,
    ExternalAttendanceStatus? status,
    AttendanceStatus? status,
    String? notes,
    Duration? totalHours,
    bool? isLateCheckIn,
    bool? isEarlyCheckOut,
  }) {
    return Attendance(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInLocation: checkInLocation ?? this.checkInLocation,
      checkOutLocation: checkOutLocation ?? this.checkOutLocation,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      totalHours: totalHours ?? this.totalHours,
      isLateCheckIn: isLateCheckIn ?? this.isLateCheckIn,
      isEarlyCheckOut: isEarlyCheckOut ?? this.isEarlyCheckOut,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'checkInTime': checkInTime?.millisecondsSinceEpoch,
      'checkOutTime': checkOutTime?.millisecondsSinceEpoch,
      'checkInLocation': checkInLocation,
      'checkOutLocation': checkOutLocation,
      'status': status.index,
      'notes': notes,
      'totalHours': totalHours?.inMilliseconds,
      'isLateCheckIn': isLateCheckIn ? 1 : 0,
      'isEarlyCheckOut': isEarlyCheckOut ? 1 : 0,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      checkInTime: map['checkInTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkInTime'])
          : null,
      checkOutTime: map['checkOutTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkOutTime'])
          : null,
      checkInLocation: map['checkInLocation'],
      status: ExternalAttendanceStatus.values[map['status']],
      status: AttendanceStatus.values[map['status']],
      notes: map['notes'],
      totalHours: map['totalHours'] != null
          ? Duration(milliseconds: map['totalHours'])
          : null,
      isLateCheckIn: map['isLateCheckIn'] == 1,
      isEarlyCheckOut: map['isEarlyCheckOut'] == 1,
    );
  }
}

enum LeaveStatus { pending, approved, rejected }

class LeaveRequest {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final DateTime requestDate;
  final String? approverNotes;

  const LeaveRequest({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = LeaveStatus.pending,
    required this.requestDate,
    this.approverNotes,
  });

  LeaveRequest copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    LeaveStatus? status,
    DateTime? requestDate,
    String? approverNotes,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      approverNotes: approverNotes ?? this.approverNotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'reason': reason,
      'status': status.index,
      'requestDate': requestDate.millisecondsSinceEpoch,
      'approverNotes': approverNotes,
    };
  }

  factory LeaveRequest.fromMap(Map<String, dynamic> map) {
    return LeaveRequest(
      id: map['id'],
      userId: map['userId'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      reason: map['reason'],
      status: LeaveStatus.values[map['status']],
      requestDate: DateTime.fromMillisecondsSinceEpoch(map['requestDate']),
      approverNotes: map['approverNotes'],
    );
  }
}

class AttendanceProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<AttendanceModel.Attendance> _attendanceRecords = [];
  List<LeaveRequest> _leaveRequests = [];
  bool _isLoading = false;
  Attendance? _todayAttendance;
  List<AttendanceModel.Attendance> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading;
  Attendance? get todayAttendance => _todayAttendance;

  bool get hasCheckedInToday => _todayAttendance?.checkInTime != null;
  bool get hasCheckedOutToday => _todayAttendance?.checkOutTime != null;

  Future<void> loadAttendanceRecords(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceRecords = await _databaseService.getAttendanceRecords(userId);
      final todayRecord = _attendanceRecords
          .where((record) => _isSameDay(record.date, DateTime.now()))
          .firstOrNull;
      
      _todayAttendance = todayRecord != null ? Attendance(
        id: todayRecord.id,
        userId: todayRecord.userId,
        date: todayRecord.date,
        checkInTime: todayRecord.checkInTime,
        checkOutTime: todayRecord.checkOutTime,
        checkInLocation: todayRecord.checkInLocation,
        checkOutLocation: todayRecord.checkOutLocation,
        status: _mapAttendanceStatus(todayRecord.status),
        notes: todayRecord.notes,
        totalHours: todayRecord.totalHours,
        isLateCheckIn: todayRecord.isLateCheckIn,
        isEarlyCheckOut: todayRecord.isEarlyCheckOut,
      ) : null;
    } catch (e) {
      debugPrint('Error loading attendance records: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkIn({
    required String userId,
    String? location,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final attendance = Attendance(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        date: today,
        checkInTime: now,
        status: ExternalAttendanceStatus.present,
        status: AttendanceStatus.present,
        notes: notes,
        isLateCheckIn: _isLateCheckIn(now),
      );

      await _databaseService.insertAttendance(attendance);
      _todayAttendance = attendance;

      // Update the list
      // Update the list
      final existingIndex = _attendanceRecords.indexWhere(
        (record) => _isSameDay(record.date, today),
      );

      if (existingIndex >= 0) {
        _attendanceRecords[existingIndex] = AttendanceModel.Attendance(
          id: attendance.id,
          userId: attendance.userId,
          date: attendance.date,
          checkInTime: attendance.checkInTime,
          checkOutTime: attendance.checkOutTime,
          checkInLocation: attendance.checkInLocation,
          checkOutLocation: attendance.checkOutLocation,
          status: attendance.status,
          notes: attendance.notes,
          totalHours: attendance.totalHours,
          isLateCheckIn: attendance.isLateCheckIn,
          isEarlyCheckOut: attendance.isEarlyCheckOut,
        );
      } else {
        _attendanceRecords.insert(0, AttendanceModel.Attendance(
          id: attendance.id,
          userId: attendance.userId,
          date: attendance.date,
          checkInTime: attendance.checkInTime,
          checkOutTime: attendance.checkOutTime,
          checkInLocation: attendance.checkInLocation,
          checkOutLocation: attendance.checkOutLocation,
          status: attendance.status,
          notes: attendance.notes,
          totalHours: attendance.totalHours,
          isLateCheckIn: attendance.isLateCheckIn,
          isEarlyCheckOut: attendance.isEarlyCheckOut,
        ));
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error checking in: $e');
      return false;
    }
      if (index >= 0) {
        _attendanceRecords[index] = AttendanceModel.Attendance(
          id: updatedAttendance.id,
          userId: updatedAttendance.userId,
          date: updatedAttendance.date,
          checkInTime: updatedAttendance.checkInTime,
          checkOutTime: updatedAttendance.checkOutTime,
          checkInLocation: updatedAttendance.checkInLocation,
          checkOutLocation: updatedAttendance.checkOutLocation,
          status: updatedAttendance.status,
          notes: updatedAttendance.notes,
          totalHours: updatedAttendance.totalHours,
          isLateCheckIn: updatedAttendance.isLateCheckIn,
          isEarlyCheckOut: updatedAttendance.isEarlyCheckOut,
        );
      }
    if (_todayAttendance == null) return false;

    try {
      final now = DateTime.now();
      final checkInTime = _todayAttendance!.checkInTime!;
      final totalHours = now.difference(checkInTime);

      final updatedAttendance = _todayAttendance!.copyWith(
        checkOutTime: now,
        checkOutLocation: location,
        notes: notes ?? _todayAttendance!.notes,
        totalHours: totalHours,
        isEarlyCheckOut: _isEarlyCheckOut(now),
      );

      await _databaseService.updateAttendance(updatedAttendance);
      _todayAttendance = updatedAttendance;

      // Update the list
      final index = _attendanceRecords.indexWhere(
        (record) => record.id == updatedAttendance.id,
      );

      if (index >= 0) {
        _attendanceRecords[index] = AttendanceModel.Attendance.fromMap(updatedAttendance.toMap());
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error checking out: $e');
      return false;
    }
  }

  int get totalPresentDays => _attendanceRecords
      .where((record) => record.status == ExternalAttendanceStatus.present)
      .length;

  int get totalAbsentDays => _attendanceRecords
      .where((record) => record.status == ExternalAttendanceStatus.absent)
      .length;

  int get totalLeaveDays => _attendanceRecords
      .where((record) => record.status == ExternalAttendanceStatus.onLeave)
      .length;
      .length;

  double get attendancePercentage {
    if (_attendanceRecords.isEmpty) return 0.0;
    return (totalPresentDays / _attendanceRecords.length) * 100;
  }

  Duration get averageWorkingHours {
    final presentRecords = _attendanceRecords
        .where((record) => record.totalHours != null)
        .toList();

    if (presentRecords.isEmpty) return Duration.zero;

    final totalMilliseconds = presentRecords
        .map((record) => record.totalHours!.inMilliseconds)
        .reduce((a, b) => a + b);

    return Duration(milliseconds: totalMilliseconds ~/ presentRecords.length);
  }

  List<AttendanceModel.Attendance> getAttendanceForMonth(DateTime month) {
    return _attendanceRecords.where((record) {
      return record.date.year == month.year && record.date.month == month.month;
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isLateCheckIn(DateTime checkInTime) {
    // Consider 9:30 AM as standard check-in time
    final standardTime = DateTime(
      checkInTime.year,
      checkInTime.month,
      checkInTime.day,
      9,
      30,
    );
    return checkInTime.isAfter(standardTime);
  }

  bool _isEarlyCheckOut(DateTime checkOutTime) {
    // Consider 5:30 PM as standard check-out time
    final standardTime = DateTime(
      checkOutTime.year,
      checkOutTime.month,
      checkOutTime.day,
      17,
      30,
    );
    return checkOutTime.isBefore(standardTime);
  }
  ExternalAttendanceStatus _mapAttendanceStatus(dynamic status) {
    if (status is ExternalAttendanceStatus) return status;
    // Assuming the external AttendanceStatus has similar values
    switch (status.toString().split('.').last) {
      case 'present':
        return ExternalAttendanceStatus.present;
      case 'absent':
        return ExternalAttendanceStatus.absent;
      case 'onLeave':
        return ExternalAttendanceStatus.onLeave;
      default:
        return ExternalAttendanceStatus.absent;
    }
  }
  }
}

extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
