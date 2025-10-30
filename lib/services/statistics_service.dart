import 'package:flutter/foundation.dart';
import '../models/employee_model.dart';

/// Service class for calculating attendance statistics and metrics
class StatisticsService {
  /// Validates input parameters before processing
  /// Throws ArgumentError if validation fails
  void _validateInputRecords(List<AttendanceRecord>? records) {
    if (records == null) {
      throw ArgumentError('Attendance records cannot be null');
    }
    
    for (final record in records) {
      if (record.id.isEmpty) {
        throw ArgumentError('Attendance record ID cannot be empty');
      }
      
      if (record.totalWorkTime != null && record.totalWorkTime!.inMilliseconds < 0) {
        throw ArgumentError('Total work time cannot be negative for record ${record.id}');
      }
      
      if (record.overtimeHours != null && record.overtimeHours!.inMilliseconds < 0) {
        throw ArgumentError('Overtime hours cannot be negative for record ${record.id}');
      }
    }
  }

  /// Performs cross-validation checks on calculated statistics
  /// Verifies the integrity and consistency of all integrated components
  bool validateCalculatedStats(Map<String, dynamic> stats, List<AttendanceRecord>? records) {
    if (records == null) return false;
    
    // Validate that total days match the input records count
    final expectedTotalDays = records.length;
    final actualTotalDays = stats['total_days'] as int;
    if (expectedTotalDays != actualTotalDays) {
      debugPrint('Validation failed: Expected total days $expectedTotalDays, got $actualTotalDays');
      return false;
    }
    
    // Calculate expected total counted days
    int expectedCountedDays = 0;
    for (final record in records) {
      if (record.status != AttendanceStatus.holiday) {
        expectedCountedDays++;
      }
    }
    
    final actualCountedDays = stats['total_counted_days'] as int;
    if (expectedCountedDays != actualCountedDays) {
      debugPrint('Validation failed: Expected counted days $expectedCountedDays, got $actualCountedDays');
      return false;
    }
    
    // Validate that individual day counts sum to total counted days
    final presentDays = stats['present_days'] as int;
    final lateDays = stats['late_days'] as int;
    final halfDays = stats['half_days'] as int;
    final absentDays = stats['absent_days'] as int;
    final leaveDays = stats['leave_days'] as int;
    final workFromHomeDays = stats['work_from_home_days'] as int;
    final holidayDays = stats['holiday_days'] as int;
    
    final sumOfDayTypes = presentDays + lateDays + halfDays + absentDays + leaveDays + workFromHomeDays + holidayDays;
    if (sumOfDayTypes != expectedTotalDays) {
      debugPrint('Validation failed: Sum of day types $sumOfDayTypes does not match total records $expectedTotalDays');
      return false;
    }
    
    // Validate that counted days (excluding holidays) match the sum of non-holiday day types
    final countedDaysSum = presentDays + lateDays + halfDays + absentDays + leaveDays + workFromHomeDays;
    if (countedDaysSum != actualCountedDays) {
      debugPrint('Validation failed: Sum of counted day types $countedDaysSum does not match total counted days $actualCountedDays');
      return false;
    }
    
    // Validate attendance percentage calculation
    final expectedPercentage = calculateAttendancePercentage(presentDays, lateDays, halfDays, actualCountedDays);
    final actualPercentage = stats['attendance_percentage'] as double;
    
    // Use a small tolerance for floating point comparison
    if ((expectedPercentage - actualPercentage).abs() > 0.01) {
      debugPrint('Validation failed: Expected attendance percentage $expectedPercentage, got $actualPercentage');
      return false;
    }
    
    // Validate that total work time and overtime hours are non-negative
    final totalWorkTime = stats['total_work_time'] as double;
    if (totalWorkTime < 0) {
      debugPrint('Validation failed: Total work time cannot be negative: $totalWorkTime');
      return false;
    }
    
    final totalOvertimeHours = stats['total_overtime_hours'] as double;
    if (totalOvertimeHours < 0) {
      debugPrint('Validation failed: Total overtime hours cannot be negative: $totalOvertimeHours');
      return false;
    }
    
    return true;
  }

  /// Performs comprehensive validation of statistics across different operational scenarios
  Map<String, List<String>> performComprehensiveValidation(Map<String, dynamic> stats, List<AttendanceRecord>? records) {
    final validationResults = <String, List<String>>{};
    
    // Check for null or empty records
    if (records == null || records.isEmpty) {
      validationResults['critical'] = ['Records list is null or empty'];
      return validationResults;
    }
    
    // Initialize error list
    final errors = <String>[];
    final warnings = <String>[];
    
    try {
      // Validate total days consistency
      final expectedTotalDays = records.length;
      final actualTotalDays = stats['total_days'] as int;
      if (expectedTotalDays != actualTotalDays) {
        errors.add('Total days mismatch: Expected $expectedTotalDays, got $actualTotalDays');
      }
      
      // Validate counted days (excluding holidays)
      final actualCountedDays = stats['total_counted_days'] as int;
      int expectedCountedDays = 0;
      for (final record in records) {
        if (record.status != AttendanceStatus.holiday) {
          expectedCountedDays++;
        }
      }
      if (expectedCountedDays != actualCountedDays) {
        errors.add('Counted days mismatch: Expected $expectedCountedDays, got $actualCountedDays');
      }
      
      // Validate individual day counts
      final presentDays = stats['present_days'] as int;
      final lateDays = stats['late_days'] as int;
      final halfDays = stats['half_days'] as int;
      final absentDays = stats['absent_days'] as int;
      final leaveDays = stats['leave_days'] as int;
      final workFromHomeDays = stats['work_from_home_days'] as int;
      final holidayDays = stats['holiday_days'] as int;
      
      // Verify that all day counts are non-negative
      if (presentDays < 0) errors.add('Present days cannot be negative: $presentDays');
      if (lateDays < 0) errors.add('Late days cannot be negative: $lateDays');
      if (halfDays < 0) errors.add('Half days cannot be negative: $halfDays');
      if (absentDays < 0) errors.add('Absent days cannot be negative: $absentDays');
      if (leaveDays < 0) errors.add('Leave days cannot be negative: $leaveDays');
      if (workFromHomeDays < 0) errors.add('Work from home days cannot be negative: $workFromHomeDays');
      if (holidayDays < 0) errors.add('Holiday days cannot be negative: $holidayDays');
      
      // Verify that day counts sum correctly
      final sumOfDayTypes = presentDays + lateDays + halfDays + absentDays + leaveDays + workFromHomeDays + holidayDays;
      if (sumOfDayTypes != expectedTotalDays) {
        errors.add('Day types sum mismatch: $sumOfDayTypes != $expectedTotalDays');
      }
      
      final countedDaysSum = presentDays + lateDays + halfDays + absentDays + leaveDays + workFromHomeDays;
      if (countedDaysSum != actualCountedDays) {
        errors.add('Counted day types sum mismatch: $countedDaysSum != $actualCountedDays');
      }
      
      // Validate attendance percentage
      final actualPercentage = stats['attendance_percentage'] as double;
      if (actualPercentage < 0 || actualPercentage > 100) {
        errors.add('Attendance percentage out of range: $actualPercentage');
      }
      
      // Check for unusual patterns that might indicate data issues
      if (presentDays > actualCountedDays) {
        warnings.add('Present days ($presentDays) exceeds counted days ($actualCountedDays)');
      }
      
      if (actualPercentage > 100 && actualCountedDays > 0) {
        warnings.add('Attendance percentage exceeds 100%: $actualPercentage');
      }
      
      // Validate work time and overtime values
      final totalWorkTime = stats['total_work_time'] as double;
      if (totalWorkTime < 0) {
        errors.add('Total work time is negative: $totalWorkTime');
      }
      
      final totalOvertimeHours = stats['total_overtime_hours'] as double;
      if (totalOvertimeHours < 0) {
        errors.add('Total overtime hours is negative: $totalOvertimeHours');
      }
      
      // Check for unusual work time patterns
      if (totalWorkTime > actualCountedDays * 24) { // More than 24 hours per day seems unusual
        warnings.add('Total work time (${totalWorkTime.toStringAsFixed(2)} hours) seems unusually high for $actualCountedDays days');
      }
    } catch (e) {
      errors.add('Error during validation: $e');
    }
    
    if (errors.isNotEmpty) {
      validationResults['errors'] = errors;
    }
    
    if (warnings.isNotEmpty) {
      validationResults['warnings'] = warnings;
    }
    
    return validationResults;
  }

  /// Calculates attendance statistics for a given date range
  Map<String, dynamic> calculateAttendanceStats({
     required List<AttendanceRecord>? records,
   }) {
     try {
       // Validate input parameters before processing
       _validateInputRecords(records);
       final recordsList = records!; // Safe to use ! since validation already checked for null
       
       int presentDays = 0;
       int lateDays = 0;
       int halfDays = 0;
       int absentDays = 0;
       int leaveDays = 0;
       int workFromHomeDays = 0;
       int holidayDays = 0;
       Duration totalWorkTime = Duration.zero;
       Duration totalOvertimeHours = Duration.zero;

       for (final record in recordsList) {
         // Validate attendance status and count days
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
           case AttendanceStatus.leave:
             leaveDays++;
             break;
           case AttendanceStatus.workFromHome:
             workFromHomeDays++;
             break;
           case AttendanceStatus.holiday:
             holidayDays++;
             break;
           default:
             // Log unknown status but continue processing
             debugPrint('Unknown attendance status: ${record.status}');
             break;
         }

         // Add work time if not null (validation already done in _validateInputRecords)
         if (record.totalWorkTime != null) {
           totalWorkTime += record.totalWorkTime!;
         }
         
         // Add overtime hours if not null (validation already done in _validateInputRecords)
         if (record.overtimeHours != null) {
           totalOvertimeHours += record.overtimeHours!;
         }
       }

       // Calculate total counted days (excluding holidays)
       int totalCountedDays = presentDays + lateDays + halfDays + absentDays + leaveDays + workFromHomeDays;
       
       // Validate that counted days match total records
       if (totalCountedDays != recordsList.length) {
         debugPrint('Warning: Counted days ($totalCountedDays) does not match total records (${recordsList.length})');
       }

       final stats = {
         'total_days': recordsList.length,
         'present_days': presentDays,
         'late_days': lateDays,
         'half_days': halfDays,
         'absent_days': absentDays,
         'leave_days': leaveDays,
         'work_from_home_days': workFromHomeDays,
         'holiday_days': holidayDays,
         'total_counted_days': totalCountedDays,
         'total_work_time': totalWorkTime.inMinutes / 60.0,
         'total_overtime_hours': totalOvertimeHours.inMinutes / 60.0,
         'attendance_percentage': recordsList.isEmpty
             ? 0.0
             : calculateAttendancePercentage(presentDays, lateDays, halfDays, totalCountedDays),
       };
       
       // Perform cross-validation to verify integrity of calculated statistics
       final validationResults = performComprehensiveValidation(stats, recordsList);
       if (validationResults.containsKey('errors')) {
         debugPrint('Validation errors found: ${validationResults['errors']}');
         // In a production environment, you might want to throw an exception here
         // or handle the validation errors differently based on your requirements
       }
       
       if (validationResults.containsKey('warnings')) {
         debugPrint('Validation warnings found: ${validationResults['warnings']}');
       }

       return stats;
     } catch (e) {
       debugPrint('Error calculating attendance stats: $e');
       // Return a consistent error response
       return _getEmptyStats();
     }
   }

  /// Returns an empty statistics map in case of errors
 Map<String, dynamic> _getEmptyStats() {
    return {
      'total_days': 0,
      'present_days': 0,
      'late_days': 0,
      'half_days': 0,
      'absent_days': 0,
      'leave_days': 0,
      'work_from_home_days': 0,
      'holiday_days': 0,
      'total_counted_days': 0,
      'total_work_time': 0,
      'total_overtime_hours': 0,
      'attendance_percentage': 0.0,
    };
  }

  /// Calculates total present days
  int getTotalPresentDays(List<AttendanceRecord>? records) {
    // Validate input before processing
    _validateInputRecords(records);
    
    final list = records ?? [];
    return list
        .where((record) => record.status == AttendanceStatus.present)
        .length;
  }

  /// Calculates total absent days
  int getTotalAbsentDays(List<AttendanceRecord>? records) {
    // Validate input before processing
    _validateInputRecords(records);
    
    final list = records ?? [];
    return list
        .where((record) => record.status == AttendanceStatus.absent)
        .length;
  }

  /// Calculates total leave days
  int getTotalLeaveDays(List<AttendanceRecord>? records) {
    // Validate input before processing
    _validateInputRecords(records);
    
    final list = records ?? [];
    return list
        .where((record) => record.status == AttendanceStatus.leave)
        .length;
  }

  /// Calculates attendance percentage
  double getAttendancePercentage(List<AttendanceRecord>? records) {
    // Validate input before processing
    _validateInputRecords(records);
    
    final list = records ?? [];
    if (list.isEmpty) return 0.0;
    
    final presentDays = getTotalPresentDays(list);
    final lateDays = list
        .where((record) => record.status == AttendanceStatus.late)
        .length;
    final halfDays = list
        .where((record) => record.status == AttendanceStatus.halfDay)
        .length;
    return calculateAttendancePercentage(presentDays, lateDays, halfDays, list.length);
  }

  /// Calculates attendance percentage with proper handling of half days
  /// Half days are counted as 0.5 days toward attendance
  double calculateAttendancePercentage(int presentDays, int lateDays, int halfDays, int totalDays) {
    if (totalDays <= 0) return 0.0;
    // Count full days as 1 and half days as 0.5 for accurate percentage calculation
    final effectiveAttendance = presentDays + lateDays + (halfDays * 0.5);
    return (effectiveAttendance / totalDays) * 100;
  }

 /// Calculates average working hours
  Duration getAverageWorkingHours(List<AttendanceRecord>? records) {
    // Validate input before processing
    _validateInputRecords(records);
    
    // Filter records with valid (non-negative) totalWorkTime
    final list = records ?? [];
    final validRecords = list.where((record) {
      return record.totalWorkTime != null && record.totalWorkTime!.inMilliseconds >= 0;
    }).toList();

    if (validRecords.isEmpty) return Duration.zero;

    final totalMilliseconds = validRecords
        .map((record) => record.totalWorkTime!.inMilliseconds)
        .fold<int>(0, (a, b) => a + b);

    return Duration(milliseconds: totalMilliseconds ~/ validRecords.length);
  }
}