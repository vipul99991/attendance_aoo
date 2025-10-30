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
  bool get isCheckedOutToday {
    // Check if today's attendance exists and has both check-in and check-out times
    // This indicates a completed cycle for the current record
    return _todayAttendance?.checkInTime != null && _todayAttendance?.checkOutTime != null;
  }
  
  // Check if there is a current incomplete attendance cycle
  bool get hasActiveCheckIn => _todayAttendance?.checkInTime != null && _todayAttendance?.checkOutTime == null;

  AttendanceProvider({
    required AttendanceService attendanceService,
    required StatisticsService statisticsService,
    required AttendanceRepository attendanceRepository,
    required Uuid uuid,
  }) : _attendanceService = attendanceService,
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
          (_attendanceRecords.isNotEmpty &&
              records.isNotEmpty &&
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
      _todayAttendance = todayAttendance;
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

      // Refresh today's attendance to ensure we have the latest state
      await _loadTodayAttendance();

      // Check if already checked in today but not yet checked out for the current cycle
      // Only prevent check-in if there's an active/incomplete check-in cycle
      if (hasActiveCheckIn) {
        _setError(Messages.alreadyCheckedIn);
        return false;
      }
      
      // Refresh today's attendance again right before creating new record
      await _loadTodayAttendance();

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
      notifyListeners(); // Ensure UI updates immediately

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

      // Refresh today's attendance to ensure we have the latest state
      await _loadTodayAttendance();

      // Check if checked in today
      if (!isCheckedInToday) {
        _setError(Messages.notCheckedIn);
        return false;
      }

      // Check if already checked out for the current cycle
      // If the current attendance record already has a check-out time,
      // the user needs to start a new cycle with a new check-in
      if (isCheckedOutToday) {
        _setError('You have already checked out for this cycle. Please check in again to start a new cycle.');
        return false;
      }

      String? locationData;
      String? photoPath;

      // Get location if required
      if (requireLocation) {
        final position = await _attendanceService.locationService
            .getCurrentLocation();
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
      // Don't call notifyListeners() here yet, we'll do it after the cycle reset
      
      _setError(null);
      
      // Allow immediate new check-in cycle after successful check-out
      await Future.delayed(const Duration(milliseconds: 50)); // Small delay for UI consistency
      await _loadTodayAttendance(); // Reload to get the latest state
      notifyListeners(); // Ensure UI updates immediately

      return true;
    } catch (e) {
      _setError('Check-out failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startNewAttendanceCycle() async {
    // Refresh today's attendance to get the latest state
    // This will load the most recent attendance record which may be a completed one
    await _loadTodayAttendance();
    notifyListeners();
  }
  
  // Method to force clear the current attendance state to allow immediate check-in
  Future<void> resetForNewCheckIn() async {
    // Reload today's attendance which will get the latest state
    await _loadTodayAttendance();
    // If the current record is completed, we still want to allow new check-ins
    // The UI will determine this based on the hasActiveCheckIn property
    notifyListeners();
  }
  
  // Method to create a new attendance cycle after check-out
  Future<void> prepareForNewCycle() async {
    // Refresh to get the latest state after check-out
    await _loadTodayAttendance();
    // This will ensure that if the most recent record is completed,
    // the UI will show the check-in button
    notifyListeners();
  }
  
  // Method to explicitly allow a new check-in cycle after check-out
  Future<void> allowNewCheckInCycle() async {
    // Refresh today's attendance to get the latest state
    // This will load the most recent record, which could be completed
    await _loadTodayAttendance();
    // Notify listeners to update the UI
    notifyListeners();
  }

  Future<List<AttendanceRecord>> getAttendanceForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _attendanceRepository.getAttendanceForDateRange(
      startDate,
      endDate,
    );
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
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // In a real app, this would:
      // 1. Upload unsynced local records to server
      // 2. Download latest records from server
      // 3. Merge and resolve conflicts
      // 4. Update local storage

      // For now, we'll just simulate the sync process
      await Future.delayed(const Duration(seconds: 2));

      // Mark all records as synced
      for (var record in _attendanceRecords) {
        // In real implementation, you would update sync status
        // record.isSynced = true;
      }

      debugPrint('Server synchronization completed');
    } catch (e) {
      _errorMessage = 'Sync failed: $e';
      debugPrint('Sync error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
  int get totalPresentDays =>
      _statisticsService.getTotalPresentDays(_attendanceRecords);

  int get totalAbsentDays =>
      _statisticsService.getTotalAbsentDays(_attendanceRecords);

  int get totalLeaveDays =>
      _statisticsService.getTotalLeaveDays(_attendanceRecords);

  double get attendancePercentage =>
      _statisticsService.getAttendancePercentage(_attendanceRecords);

  Duration get averageWorkingHours =>
      _statisticsService.getAverageWorkingHours(_attendanceRecords);

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
