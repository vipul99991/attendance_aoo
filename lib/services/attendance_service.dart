import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../models/employee_model.dart';
import '../services/location_service.dart';
import '../services/camera_service.dart';
import '../utils/constants.dart';

/// Service class responsible for attendance-related business logic
class AttendanceService {
  final LocationService _locationService;
  final CameraService _cameraService;
 final Uuid _uuid;

  AttendanceService({
    required LocationService locationService,
    required CameraService cameraService,
    required Uuid uuid,
  })  : _locationService = locationService,
        _cameraService = cameraService,
        _uuid = uuid;

 LocationService get locationService => _locationService;
  CameraService get cameraService => _cameraService;
  Uuid get uuid => _uuid;

  /// Validates if the user is within the office location radius
  Future<bool> validateLocation({
    required Position position,
    required OfficeLocation officeLocation,
  }) async {
    try {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        officeLocation.latitude,
        officeLocation.longitude,
      );
      return distance <= officeLocation.allowedRadius;
    } catch (e) {
      debugPrint('Error validating location: $e');
      return false;
    }
  }

   /// Captures location data if required
   Future<String?> captureLocation({
     required bool requireLocation,
     required OfficeLocation officeLocation,
   }) async {
     if (!requireLocation) return null;
 
     final position = await _locationService.getCurrentLocation();
     if (position == null) {
       throw Exception(Messages.locationError);
     }
 
     // Verify location is within office area
     final isValidLocation = await validateLocation(
       position: position,
       officeLocation: officeLocation,
     );
     
     if (!isValidLocation) {
       throw Exception(Messages.outsideOfficeArea);
     }
 
     return '${position.latitude},${position.longitude}';
   }
 
  /// Captures photo if required
   Future<String?> capturePhoto({required bool requirePhoto}) async {
     if (!requirePhoto) return null;
     
     try {
       return await _cameraService.takePicture();
     } catch (e) {
       // Photo capture is optional, don't fail if camera fails
       return null;
     }
   }

  /// Calculates work duration and overtime
  WorkTimeResult calculateWorkTime({
    required DateTime checkInTime,
    required DateTime checkOutTime,
    required WorkingHours workingHours,
  }) {
    final totalWorkTime = checkOutTime.difference(checkInTime);
    final standardWorkTime = workingHours.totalWorkDuration;
    
    Duration? overtimeHours;
    if (totalWorkTime > standardWorkTime) {
      overtimeHours = totalWorkTime - standardWorkTime;
    }

    return WorkTimeResult(
      totalWorkTime: totalWorkTime,
      overtimeHours: overtimeHours,
    );
 }

  /// Determines attendance status based on check-in/out times and working hours
  AttendanceStatus determineAttendanceStatus({
    required DateTime checkIn,
    required DateTime checkOut,
    required WorkingHours workingHours,
  }) {
    try {
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
    } catch (e) {
      debugPrint('Error determining attendance status: $e');
      return AttendanceStatus.present; // Default to present if there's an error
    }
 }
}

/// Result class for work time calculations
class WorkTimeResult {
  final Duration totalWorkTime;
  final Duration? overtimeHours;

  WorkTimeResult({
    required this.totalWorkTime,
    this.overtimeHours,
  });
}