class LeaveRequest {
  final String id;
  final String userId;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final DateTime requestDate;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? remarks;
  final int totalDays;

  LeaveRequest({
    required this.id,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = LeaveStatus.pending,
    required this.requestDate,
    this.approvedBy,
    this.approvedDate,
    this.remarks,
    required this.totalDays,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      userId: json['userId'],
      type: LeaveType.values.firstWhere(
        (e) => e.toString() == 'LeaveType.${json['type']}',
        orElse: () => LeaveType.casual,
      ),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'],
      status: LeaveStatus.values.firstWhere(
        (e) => e.toString() == 'LeaveStatus.${json['status']}',
        orElse: () => LeaveStatus.pending,
      ),
      requestDate: DateTime.parse(json['requestDate']),
      approvedBy: json['approvedBy'],
      approvedDate: json['approvedDate'] != null
          ? DateTime.parse(json['approvedDate'])
          : null,
      remarks: json['remarks'],
      totalDays: json['totalDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      'status': status.toString().split('.').last,
      'requestDate': requestDate.toIso8601String(),
      'approvedBy': approvedBy,
      'approvedDate': approvedDate?.toIso8601String(),
      'remarks': remarks,
      'totalDays': totalDays,
    };
  }

  LeaveRequest copyWith({
    String? id,
    String? userId,
    LeaveType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    LeaveStatus? status,
    DateTime? requestDate,
    String? approvedBy,
    DateTime? approvedDate,
    String? remarks,
    int? totalDays,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      remarks: remarks ?? this.remarks,
      totalDays: totalDays ?? this.totalDays,
    );
  }
}

enum LeaveType { casual, sick, annual, maternity, paternity, emergency }

enum LeaveStatus { pending, approved, rejected, cancelled }

extension LeaveTypeExtension on LeaveType {
  String get displayName {
    switch (this) {
      case LeaveType.casual:
        return 'Casual Leave';
      case LeaveType.sick:
        return 'Sick Leave';
      case LeaveType.annual:
        return 'Annual Leave';
      case LeaveType.maternity:
        return 'Maternity Leave';
      case LeaveType.paternity:
        return 'Paternity Leave';
      case LeaveType.emergency:
        return 'Emergency Leave';
    }
  }
}

extension LeaveStatusExtension on LeaveStatus {
  String get displayName {
    switch (this) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.cancelled:
        return 'Cancelled';
    }
  }
}
