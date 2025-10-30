import 'package:flutter/foundation.dart';

class Employee {
  final String employeeId;
  final String name;
  final String email;
  final String department;
  final String position;
  final String phone;
  final String? profileImage;
  final WorkingHours workingHours;
  final List<String> hrEmails;
  final OfficeLocation location;
  final List<String> permissions;

  Employee({
    required this.employeeId,
    required this.name,
    required this.email,
    required this.department,
    required this.position,
    required this.phone,
    this.profileImage,
    required this.workingHours,
    required this.hrEmails,
    required this.location,
    required this.permissions,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employee_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      position: json['position'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      workingHours: WorkingHours.fromJson(json['working_hours'] ?? {}),
      hrEmails: List<String>.from(json['hr_emails'] ?? []),
      location: OfficeLocation.fromJson(json['location'] ?? {}),
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'name': name,
      'email': email,
      'department': department,
      'position': position,
      'phone': phone,
      'profile_image': profileImage,
      'working_hours': workingHours.toJson(),
      'hr_emails': hrEmails,
      'location': location.toJson(),
      'permissions': permissions,
    };
  }
}

class WorkingHours {
  final String startTime;
  final String endTime;
  final int breakDuration; // minutes

  WorkingHours({
    required this.startTime,
    required this.endTime,
    required this.breakDuration,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      startTime: json['start_time'] ?? '09:00',
      endTime: json['end_time'] ?? '17:00',
      breakDuration: json['break_duration'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'break_duration': breakDuration,
    };
  }

  Duration get totalWorkDuration {
    try {
      final start = parseTime(startTime);
      final end = parseTime(endTime);
      final workDuration = end.difference(start);
      
      // Ensure the break duration doesn't exceed the total work duration
      final breakDurationMs = Duration(minutes: breakDuration).inMilliseconds;
      final workDurationMs = workDuration.inMilliseconds;
      
      if (breakDurationMs > workDurationMs) {
        // If break is longer than total duration, return zero
        return Duration.zero;
      }
      
      return Duration(milliseconds: workDurationMs - breakDurationMs);
    } catch (e) {
      debugPrint('Error calculating total work duration: $e');
      return Duration.zero; // Return zero if there's an error
    }
  }

  DateTime parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}

class OfficeLocation {
  final double latitude;
  final double longitude;
  final int allowedRadius; // meters

  OfficeLocation({
    required this.latitude,
    required this.longitude,
    required this.allowedRadius,
  });

  factory OfficeLocation.fromJson(Map<String, dynamic> json) {
    return OfficeLocation(
      latitude: (json['office_latitude'] ?? 0.0).toDouble(),
      longitude: (json['office_longitude'] ?? 0.0).toDouble(),
      allowedRadius: json['allowed_radius'] ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'office_latitude': latitude,
      'office_longitude': longitude,
      'allowed_radius': allowedRadius,
    };
  }
}

class AttendanceRecord {
  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? checkInPhoto;
  final String? checkOutPhoto;
  final Duration? totalWorkTime;
  final Duration? overtimeHours;
  final AttendanceStatus status;
  final String? notes;

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    this.checkInPhoto,
    this.checkOutPhoto,
    this.totalWorkTime,
    this.overtimeHours,
    required this.status,
    this.notes,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      date: DateTime.parse(json['date']),
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'])
          : null,
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'])
          : null,
      checkInLocation: json['check_in_location'],
      checkOutLocation: json['check_out_location'],
      checkInPhoto: json['check_in_photo'],
      checkOutPhoto: json['check_out_photo'],
      totalWorkTime: json['total_work_time'] != null
          ? Duration(minutes: json['total_work_time'])
          : null,
      overtimeHours: json['overtime_hours'] != null
          ? Duration(minutes: json['overtime_hours'])
          : null,
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AttendanceStatus.present,
      ),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'date': date.toIso8601String(),
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'check_in_location': checkInLocation,
      'check_out_location': checkOutLocation,
      'check_in_photo': checkInPhoto,
      'check_out_photo': checkOutPhoto,
      'total_work_time': totalWorkTime?.inMinutes,
      'overtime_hours': overtimeHours?.inMinutes,
      'status': status.toString().split('.').last,
      'notes': notes,
    };
  }

  // Backward compatibility properties
  Duration? get totalHours => totalWorkTime;

  String get formattedTotalHours {
    if (totalWorkTime == null) return '0h 0m';
    final hours = totalWorkTime!.inHours;
    final minutes = totalWorkTime!.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}

enum AttendanceStatus {
  present,
  absent,
  late,
  halfDay,
  leave,
  workFromHome,
  holiday,
}

class LeaveRequest {
  final String id;
  final String employeeId;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DateTime createdAt;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.createdAt,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      type: LeaveType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => LeaveType.sick,
      ),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      reason: json['reason'] ?? '',
      status: LeaveStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => LeaveStatus.pending,
      ),
      approvedBy: json['approved_by'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
      rejectionReason: json['rejection_reason'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'type': type.toString().split('.').last,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'reason': reason,
      'status': status.toString().split('.').last,
      'approved_by': approvedBy,
      'approved_at': approvedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  int get totalDays {
    return endDate.difference(startDate).inDays + 1;
  }
}

enum LeaveType {
  sick,
  vacation,
  personal,
  emergency,
  maternity,
  paternity,
  workFromHome,
}

enum LeaveStatus { pending, approved, rejected, cancelled }
