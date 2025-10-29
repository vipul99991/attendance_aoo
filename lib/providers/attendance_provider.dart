import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/employee_model.dart';
import '../services/location_service.dart';
import '../services/camera_service.dart';
import '../utils/constants.dart';

class AttendanceProvider extends ChangeNotifier {
  Box? _attendanceBox;
  List<AttendanceRecord> _attendanceRecords = [];
  AttendanceRecord? _todayAttendance;
  bool _isLoading = false;
  String? _errorMessage;

  // Services
  final LocationService _locationService = LocationService();
  final CameraService _cameraService = CameraService();
  final Uuid _uuid = const Uuid();

  // Getters
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  AttendanceRecord? get todayAttendance => _todayAttendance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCheckedInToday => _todayAttendance?.checkInTime != null;
  bool get isCheckedOutToday => _todayAttendance?.checkOutTime != null;

  AttendanceProvider() {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _attendanceBox = await Hive.openBox(AppConfig.attendanceBoxName);
      await _loadAttendanceRecords();
      await _loadTodayAttendance();
    } catch (e) {
      debugPrint('Error initializing attendance Hive: $e');
    }
  }

  Future<void> _loadAttendanceRecords() async {
    try {
      final records = _attendanceBox?.values.toList() ?? [];
      _attendanceRecords = records
          .map(
            (record) =>
                AttendanceRecord.fromJson(Map<String, dynamic>.from(record)),
          )
          .toList();
      _attendanceRecords.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading attendance records: $e');
    }
  }

  Future<void> _loadTodayAttendance() async {
    try {
      final today = DateTime.now();
      final todayKey = DateFormat('yyyy-MM-dd').format(today);
      final todayData = _attendanceBox?.get(todayKey);

      if (todayData != null) {
        _todayAttendance = AttendanceRecord.fromJson(
          Map<String, dynamic>.from(todayData),
        );
      } else {
        _todayAttendance = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading today attendance: $e');
    }
  }

  Future<bool> checkIn({
    required String employeeId,
    required OfficeLocation officeLocation,
    bool requireLocation = true,
    bool requirePhoto = true,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Check if already checked in today
      if (isCheckedInToday) {
        _setError(Messages.alreadyCheckedIn);
        return false;
      }

      String? locationData;
      String? photoPath;

      // Get location if required
      if (requireLocation) {
        final position = await _locationService.getCurrentLocation();
        if (position == null) {
          _setError(Messages.locationError);
          return false;
        }

        // Verify location is within office area
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          officeLocation.latitude,
          officeLocation.longitude,
        );

        if (distance > officeLocation.allowedRadius) {
          _setError(Messages.outsideOfficeArea);
          return false;
        }

        locationData = '${position.latitude},${position.longitude}';
      }

      // Take photo if required
      if (requirePhoto) {
        photoPath = await _cameraService.takePicture();
        // Photo is optional, don't fail if camera fails
      }

      // Create attendance record
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final recordId = _uuid.v4();

      final attendanceRecord = AttendanceRecord(
        id: recordId,
        employeeId: employeeId,
        date: today,
        checkInTime: now,
        checkInLocation: locationData,
        checkInPhoto: photoPath,
        status: AttendanceStatus.present,
      );

      // Save to Hive
      final todayKey = DateFormat('yyyy-MM-dd').format(today);
      await _attendanceBox?.put(todayKey, attendanceRecord.toJson());

      // Update local data
      _todayAttendance = attendanceRecord;
      await _loadAttendanceRecords();

      _setError(null);
      return true;
    } catch (e) {
      _setError('Check-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkOut({
    required String employeeId,
    required WorkingHours workingHours,
    bool requireLocation = true,
    bool requirePhoto = true,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Check if checked in today
      if (!isCheckedInToday) {
        _setError(Messages.notCheckedIn);
        return false;
      }

      // Check if already checked out
      if (isCheckedOutToday) {
        _setError('You have already checked out today.');
        return false;
      }

      String? locationData;
      String? photoPath;

      // Get location if required
      if (requireLocation) {
        final position = await _locationService.getCurrentLocation();
        if (position != null) {
          locationData = '${position.latitude},${position.longitude}';
        }
      }

      // Take photo if required
      if (requirePhoto) {
        photoPath = await _cameraService.takePicture();
        // Photo is optional, don't fail if camera fails
      }

      // Calculate work time and overtime
      final now = DateTime.now();
      final checkInTime = _todayAttendance!.checkInTime!;
      final totalWorkTime = now.difference(checkInTime);
      final standardWorkTime = workingHours.totalWorkDuration;

      Duration? overtimeHours;
      if (totalWorkTime > standardWorkTime) {
        overtimeHours = totalWorkTime - standardWorkTime;
      }

      // Update attendance record
      final updatedRecord = AttendanceRecord(
        id: _todayAttendance!.id,
        employeeId: employeeId,
        date: _todayAttendance!.date,
        checkInTime: _todayAttendance!.checkInTime,
        checkOutTime: now,
        checkInLocation: _todayAttendance!.checkInLocation,
        checkOutLocation: locationData,
        checkInPhoto: _todayAttendance!.checkInPhoto,
        checkOutPhoto: photoPath,
        totalWorkTime: totalWorkTime,
        overtimeHours: overtimeHours,
        status: _determineAttendanceStatus(checkInTime, now, workingHours),
      );

      // Save to Hive
      final todayKey = DateFormat('yyyy-MM-dd').format(_todayAttendance!.date);
      await _attendanceBox?.put(todayKey, updatedRecord.toJson());

      // Update local data
      _todayAttendance = updatedRecord;
      await _loadAttendanceRecords();

      _setError(null);
      return true;
    } catch (e) {
      _setError('Check-out failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  AttendanceStatus _determineAttendanceStatus(
    DateTime checkIn,
    DateTime checkOut,
    WorkingHours workingHours,
  ) {
    final startTime = workingHours.parseTime(workingHours.startTime);
    final expectedStart = DateTime(
      checkIn.year,
      checkIn.month,
      checkIn.day,
      startTime.hour,
      startTime.minute,
    );

    // Check if late
    if (checkIn.isAfter(expectedStart.add(const Duration(minutes: 15)))) {
      return AttendanceStatus.late;
    }

    // Check if half day (less than 4 hours)
    final workDuration = checkOut.difference(checkIn);
    if (workDuration.inHours < 4) {
      return AttendanceStatus.halfDay;
    }

    return AttendanceStatus.present;
  }

  Future<List<AttendanceRecord>> getAttendanceForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final records = _attendanceRecords.where((record) {
      return record.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          record.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  Future<Map<String, dynamic>> getAttendanceStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final records = await getAttendanceForDateRange(startDate, endDate);

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
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Manual attendance entry (for admin or offline mode)
  Future<bool> addManualAttendance({
    required String employeeId,
    required DateTime date,
    required DateTime checkInTime,
    DateTime? checkOutTime,
    AttendanceStatus status = AttendanceStatus.present,
    String? notes,
  }) async {
    try {
      final recordId = _uuid.v4();
      Duration? totalWorkTime;

      if (checkOutTime != null) {
        totalWorkTime = checkOutTime.difference(checkInTime);
      }

      final attendanceRecord = AttendanceRecord(
        id: recordId,
        employeeId: employeeId,
        date: DateTime(date.year, date.month, date.day),
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        totalWorkTime: totalWorkTime,
        status: status,
        notes: notes,
      );

      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      await _attendanceBox?.put(dateKey, attendanceRecord.toJson());
      await _loadAttendanceRecords();

      return true;
    } catch (e) {
      debugPrint('Error adding manual attendance: $e');
      return false;
    }
  }

  Future<void> syncWithServer() async {
    // TODO: Implement server synchronization
    // This would upload local records to server and download any updates
  }

  // Backward compatibility methods for existing UI
  bool get hasCheckedInToday => isCheckedInToday;
  bool get hasCheckedOutToday => isCheckedOutToday;

  Future<void> loadAttendanceRecords(String userId) async {
    // This method is for backward compatibility
    await _loadAttendanceRecords();
    await _loadTodayAttendance();
  }

  // Statistics methods for backward compatibility
  int get totalPresentDays => _attendanceRecords
      .where((record) => record.status == AttendanceStatus.present)
      .length;

  int get totalAbsentDays => _attendanceRecords
      .where((record) => record.status == AttendanceStatus.absent)
      .length;

  int get totalLeaveDays => _attendanceRecords
      .where((record) => record.status == AttendanceStatus.leave)
      .length;

  double get attendancePercentage {
    if (_attendanceRecords.isEmpty) return 0.0;
    return (totalPresentDays / _attendanceRecords.length) * 100;
  }

  Duration get averageWorkingHours {
    final presentRecords = _attendanceRecords
        .where((record) => record.totalWorkTime != null)
        .toList();

    if (presentRecords.isEmpty) return Duration.zero;

    final totalMilliseconds = presentRecords
        .map((record) => record.totalWorkTime!.inMilliseconds)
        .fold(0, (a, b) => a + b);

    return Duration(milliseconds: totalMilliseconds ~/ presentRecords.length);
  }

  // Legacy check-in method for backward compatibility
  Future<bool> checkInLegacy({
    required String userId,
    String? location,
    String? notes,
  }) async {
    // Use a default office location for backward compatibility
    final defaultLocation = OfficeLocation(
      latitude: AppConfig.defaultOfficeLatitude,
      longitude: AppConfig.defaultOfficeLongitude,
      allowedRadius: AppConfig.defaultLocationRadius,
    );

    return await checkIn(
      employeeId: userId,
      officeLocation: defaultLocation,
      requireLocation: false,
      requirePhoto: false,
    );
  }

  // Legacy check-out method for backward compatibility
  Future<bool> checkOutLegacy({String? location, String? notes}) async {
    // Use default working hours for backward compatibility
    final defaultWorkingHours = WorkingHours(
      startTime: AppConfig.defaultStartTime,
      endTime: AppConfig.defaultEndTime,
      breakDuration: AppConfig.defaultBreakDuration,
    );

    return await checkOut(
      employeeId: 'default', // This should be provided by AuthProvider
      workingHours: defaultWorkingHours,
      requireLocation: false,
      requirePhoto: false,
    );
  }
}
