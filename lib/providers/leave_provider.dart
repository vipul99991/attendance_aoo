import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/employee_model.dart';
import '../utils/constants.dart';

class LeaveProvider extends ChangeNotifier {
  Box? _leaveBox;
  List<LeaveRequest> _leaveRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  final Uuid _uuid = const Uuid();

  // Getters
  List<LeaveRequest> get leaveRequests => _leaveRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<LeaveRequest> get pendingRequests => _leaveRequests
      .where((request) => request.status == LeaveStatus.pending)
      .toList();

  List<LeaveRequest> get approvedRequests => _leaveRequests
      .where((request) => request.status == LeaveStatus.approved)
      .toList();

  List<LeaveRequest> get rejectedRequests => _leaveRequests
      .where((request) => request.status == LeaveStatus.rejected)
      .toList();

  LeaveProvider() {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      _leaveBox = await Hive.openBox(AppConfig.leaveBoxName);
      await _loadLeaveRequests();
    } catch (e) {
      debugPrint('Error initializing leave Hive: $e');
    }
  }

  Future<void> _loadLeaveRequests() async {
    try {
      final requests = _leaveBox?.values.toList() ?? [];
      _leaveRequests = requests
          .map(
            (request) =>
                LeaveRequest.fromJson(Map<String, dynamic>.from(request)),
          )
          .toList();

      // Sort by date descending
      _leaveRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading leave requests: $e');
      _setError('Failed to load leave requests');
    }
  }

  Future<bool> submitLeaveRequest({
    required String employeeId,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    List<String>? attachments,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Validate dates
      if (startDate.isAfter(endDate)) {
        _setError('Start date cannot be after end date');
        return false;
      }

      if (startDate.isBefore(
        DateTime.now().subtract(const Duration(days: 1)),
      )) {
        _setError('Cannot apply for leave in the past');
        return false;
      }

      // Check for overlapping requests
      final hasOverlap = _leaveRequests.any(
        (request) =>
            request.employeeId == employeeId &&
            request.status != LeaveStatus.rejected &&
            _datesOverlap(
              request.startDate,
              request.endDate,
              startDate,
              endDate,
            ),
      );

      if (hasOverlap) {
        _setError('You already have a leave request for this period');
        return false;
      }

      // Calculate leave days
      final leaveDays = _calculateLeaveDays(startDate, endDate);

      final leaveRequest = LeaveRequest(
        id: _uuid.v4(),
        employeeId: employeeId,
        type: type,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        status: LeaveStatus.pending,
        leaveDays: leaveDays,
        createdAt: DateTime.now(),
        attachments: attachments ?? [],
      );

      // Save to Hive
      await _leaveBox?.put(leaveRequest.id, leaveRequest.toJson());

      // Add to local list
      _leaveRequests.insert(0, leaveRequest);

      // Simulate HR notification (in real app, this would send email/notification)
      await _simulateHRNotification(leaveRequest);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error submitting leave request: $e');
      _setError('Failed to submit leave request');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateLeaveRequestStatus({
    required String requestId,
    required LeaveStatus status,
    String? adminComments,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final requestIndex = _leaveRequests.indexWhere((r) => r.id == requestId);
      if (requestIndex == -1) {
        _setError('Leave request not found');
        return false;
      }

      final updatedRequest = _leaveRequests[requestIndex].copyWith(
        status: status,
        adminComments: adminComments,
        approvedAt: status == LeaveStatus.approved ? DateTime.now() : null,
      );

      // Update in Hive
      await _leaveBox?.put(requestId, updatedRequest.toJson());

      // Update local list
      _leaveRequests[requestIndex] = updatedRequest;

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating leave request: $e');
      _setError('Failed to update leave request');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelLeaveRequest(String requestId) async {
    try {
      _setLoading(true);
      _clearError();

      final request = _leaveRequests.firstWhere(
        (r) => r.id == requestId,
        orElse: () => throw Exception('Request not found'),
      );

      if (request.status != LeaveStatus.pending) {
        _setError('Can only cancel pending requests');
        return false;
      }

      // Remove from Hive
      await _leaveBox?.delete(requestId);

      // Remove from local list
      _leaveRequests.removeWhere((r) => r.id == requestId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error canceling leave request: $e');
      _setError('Failed to cancel leave request');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  List<LeaveRequest> getLeaveRequestsForEmployee(String employeeId) {
    return _leaveRequests
        .where((request) => request.employeeId == employeeId)
        .toList();
  }

  List<LeaveRequest> getLeaveRequestsForDateRange(
    DateTime start,
    DateTime end,
  ) {
    return _leaveRequests
        .where(
          (request) =>
              _datesOverlap(request.startDate, request.endDate, start, end),
        )
        .toList();
  }

  int getTotalLeaveDaysForEmployee(String employeeId, {LeaveStatus? status}) {
    return _leaveRequests
        .where(
          (request) =>
              request.employeeId == employeeId &&
              (status == null || request.status == status),
        )
        .fold<int>(0, (total, request) => total + request.leaveDays);
  }

  Map<LeaveType, int> getLeaveBalanceForEmployee(String employeeId) {
    final approvedRequests = _leaveRequests
        .where(
          (request) =>
              request.employeeId == employeeId &&
              request.status == LeaveStatus.approved,
        )
        .toList();

    final Map<LeaveType, int> usedLeave = {};
    for (final request in approvedRequests) {
      usedLeave[request.type] =
          (usedLeave[request.type] ?? 0) + request.leaveDays;
    }

    // Standard leave entitlements (can be customized per employee)
    final Map<LeaveType, int> entitlements = {
      LeaveType.annual: 21,
      LeaveType.sick: 10,
      LeaveType.personal: 5,
      LeaveType.maternity: 90,
      LeaveType.paternity: 14,
      LeaveType.emergency: 3,
      LeaveType.workFromHome: 10,
    };

    final Map<LeaveType, int> balance = {};
    for (final type in LeaveType.values) {
      final entitlement = entitlements[type] ?? 0;
      final used = usedLeave[type] ?? 0;
      balance[type] = entitlement - used;
    }

    return balance;
  }

  Future<void> _simulateHRNotification(LeaveRequest request) async {
    // Simulate sending notification to HR
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Leave request notification sent to HR: ${request.id}');
  }

  bool _datesOverlap(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    return start1.isBefore(end2) && end1.isAfter(start2);
  }

  int _calculateLeaveDays(DateTime startDate, DateTime endDate) {
    int days = 0;
    DateTime current = startDate;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      // Skip weekends (Saturday = 6, Sunday = 7)
      if (current.weekday != DateTime.saturday &&
          current.weekday != DateTime.sunday) {
        days++;
      }
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    _leaveBox?.close();
    super.dispose();
  }
}
