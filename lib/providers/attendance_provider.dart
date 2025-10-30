import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/employee_model.dart';
import '../services/attendance_service.dart';
import '../services/statistics_service.dart';
import '../data/attendance_repository.dart';
import '../utils/constants.dart';

class AttendanceProvider extends ChangeNotifier {
  List<AttendanceRecord> _attendanceRecords = [];
  AttendanceRecord? _todayAttendance;
  bool _isLoading = false;
  String? _errorMessage;

  // Services
  final AttendanceService _attendanceService;
  final StatisticsService _statisticsService;
  final AttendanceRepository _attendanceRepository;
  final Uuid _uuid;

  // Getters
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  AttendanceRecord? get todayAttendance => _todayAttendance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCheckedInToday => _todayAttendance?.checkInTime != null;
  bool get isCheckedOutToday => _todayAttendance?.checkOutTime != null;

  AttendanceProvider({
    required AttendanceService attendanceService,
    required StatisticsService statisticsService,
    required AttendanceRepository attendanceRepository,
    required Uuid uuid,
  })  : _attendanceService = attendanceService,
        _statisticsService = statisticsService,
        _attendanceRepository = attendanceRepository,
        _uuid = uuid {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _attendanceRepository.initialize();
      await _loadAttendanceRecords();
      await _loadTodayAttendance();
    } catch (e) {
      debugPrint('Error initializing attendance: $e');
    }
 }

  Future<void> _loadAttendanceRecords() async {
    try {
      final records = await _attendanceRepository.getAllAttendanceRecords();
      if (_attendanceRecords.length != records.length ||
          (_attendanceRecords.isNotEmpty && records.isNotEmpty &&
           _attendanceRecords.first.id != records.first.id)) {
        _attendanceRecords = records;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading attendance records: $e');
    }
 }

  Future<void> _loadTodayAttendance() async {
    try {
      final todayAttendance = await _attendanceRepository.getTodayAttendance();
      if (_todayAttendance?.id != todayAttendance?.id) {
        _todayAttendance = todayAttendance;
        notifyListeners();
      }
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

     try {
       locationData = await _attendanceService.captureLocation(
         requireLocation: requireLocation,
         officeLocation: officeLocation,
       );
     } on Exception catch (e) {
       _setError(e.toString());
       return false;
     }

     photoPath = await _attendanceService.capturePhoto(
       requirePhoto: requirePhoto,
     );

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

     // Save to repository
     await _attendanceRepository.saveAttendanceRecord(attendanceRecord);

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
        final position = await _attendanceService.locationService.getCurrentLocation();
        if (position != null) {
          locationData = '${position.latitude},${position.longitude}';
        }
      }

      // Take photo if required
      photoPath = await _attendanceService.capturePhoto(
        requirePhoto: requirePhoto,
      );

      // Calculate work time and overtime
      final now = DateTime.now();
      
      // Ensure today's attendance exists before proceeding
      if (_todayAttendance?.checkInTime == null) {
        _setError(Messages.notCheckedIn);
        return false;
      }
      
      final checkInTime = _todayAttendance!.checkInTime!;
      final workTimeResult = _attendanceService.calculateWorkTime(
        checkInTime: checkInTime,
        checkOutTime: now,
        workingHours: workingHours,
      );

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
        totalWorkTime: workTimeResult.totalWorkTime,
        overtimeHours: workTimeResult.overtimeHours,
        status: _attendanceService.determineAttendanceStatus(
          checkIn: checkInTime,
          checkOut: now,
          workingHours: workingHours,
        ),
      );

      // Save to repository
      await _attendanceRepository.saveAttendanceRecord(updatedRecord);

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

 Future<List<AttendanceRecord>> getAttendanceForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _attendanceRepository.getAttendanceForDateRange(startDate, endDate);
  }

  Future<Map<String, dynamic>> getAttendanceStats(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final records = await getAttendanceForDateRange(startDate, endDate);
    return _statisticsService.calculateAttendanceStats(records: records);
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
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

      await _attendanceRepository.saveAttendanceRecord(attendanceRecord);
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
  int get totalPresentDays => _statisticsService.getTotalPresentDays(_attendanceRecords);

  int get totalAbsentDays => _statisticsService.getTotalAbsentDays(_attendanceRecords);

  int get totalLeaveDays => _statisticsService.getTotalLeaveDays(_attendanceRecords);

  double get attendancePercentage => _statisticsService.getAttendancePercentage(_attendanceRecords);

  Duration get averageWorkingHours => _statisticsService.getAverageWorkingHours(_attendanceRecords);

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
