class Attendance {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInLocation;
  final String? checkOutLocation;
  final AttendanceStatus status;
  final String? notes;
  final Duration? totalHours;
  final bool isLateCheckIn;
  final bool isEarlyCheckOut;

  Attendance({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    this.status = AttendanceStatus.absent,
    this.notes,
    this.totalHours,
    this.isLateCheckIn = false,
    this.isEarlyCheckOut = false,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      checkInLocation: json['checkInLocation'],
      checkOutLocation: json['checkOutLocation'],
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${json['status']}',
        orElse: () => AttendanceStatus.absent,
      ),
      notes: json['notes'],
      totalHours: json['totalHours'] != null
          ? Duration(milliseconds: json['totalHours'])
          : null,
      isLateCheckIn: json['isLateCheckIn'] ?? false,
      isEarlyCheckOut: json['isEarlyCheckOut'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'checkInLocation': checkInLocation,
      'checkOutLocation': checkOutLocation,
      'status': status.toString().split('.').last,
      'notes': notes,
      'totalHours': totalHours?.inMilliseconds,
      'isLateCheckIn': isLateCheckIn,
      'isEarlyCheckOut': isEarlyCheckOut,
    };
  }

  Attendance copyWith({
    String? id,
    String? userId,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInLocation,
    String? checkOutLocation,
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

  bool get isPresent => status == AttendanceStatus.present;
  bool get isAbsent => status == AttendanceStatus.absent;
  bool get isOnLeave => status == AttendanceStatus.onLeave;
  bool get isHalfDay => status == AttendanceStatus.halfDay;

  String get formattedTotalHours {
    if (totalHours == null) return '0h 0m';
    final hours = totalHours!.inHours;
    final minutes = totalHours!.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

enum AttendanceStatus { present, absent, onLeave, halfDay, workFromHome }
