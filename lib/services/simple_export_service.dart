import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/employee_model.dart';
import '../utils/constants.dart';

class SimpleExportService {
  static final SimpleExportService _instance = SimpleExportService._internal();
  factory SimpleExportService() => _instance;
  SimpleExportService._internal();

  // Export attendance data to CSV (which can be opened in Excel)
  Future<String?> exportAttendanceToCSV({
    required List<AttendanceRecord> records,
    required Employee employee,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Filter records by date range if provided
      List<AttendanceRecord> filteredRecords = records;
      if (startDate != null && endDate != null) {
        filteredRecords = records.where((record) {
          return record.date.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              record.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();
      }

      // Sort records by date
      filteredRecords.sort((a, b) => a.date.compareTo(b.date));

      final StringBuffer csvContent = StringBuffer();

      // Header section
      csvContent.writeln('ATTENDANCE REPORT');
      csvContent.writeln('');
      csvContent.writeln('Employee Name,${employee.name}');
      csvContent.writeln('Employee ID,${employee.employeeId}');
      csvContent.writeln('Department,${employee.department}');
      csvContent.writeln('Position,${employee.position}');
      csvContent.writeln('Email,${employee.email}');

      if (startDate != null && endDate != null) {
        csvContent.writeln(
          'Period,${DateFormat('MMM dd yyyy').format(startDate)} - ${DateFormat('MMM dd yyyy').format(endDate)}',
        );
      }

      csvContent.writeln(
        'Generated,${DateFormat('MMM dd yyyy HH:mm').format(DateTime.now())}',
      );
      csvContent.writeln('');

      // Table headers
      csvContent.writeln(
        'Date,Check In,Check Out,Working Hours,Overtime,Status,Location,Notes',
      );

      // Data rows
      for (final record in filteredRecords) {
        csvContent.write('${DateFormat('MMM dd yyyy').format(record.date)},');
        csvContent.write(
          '${record.checkInTime != null ? DateFormat('HH:mm').format(record.checkInTime!) : '-'},',
        );
        csvContent.write(
          '${record.checkOutTime != null ? DateFormat('HH:mm').format(record.checkOutTime!) : '-'},',
        );
        csvContent.write(
          '${record.totalWorkTime != null ? _formatDuration(record.totalWorkTime!) : '-'},',
        );
        csvContent.write(
          '${record.overtimeHours != null ? _formatDuration(record.overtimeHours!) : '-'},',
        );
        csvContent.write('${_getStatusDisplayName(record.status)},');
        csvContent.write('-,');
        csvContent.writeln('${record.notes ?? '-'}');
      }

      // Summary section
      csvContent.writeln('');
      csvContent.writeln('SUMMARY');

      final presentDays = filteredRecords
          .where((r) => r.status == AttendanceStatus.present)
          .length;
      final absentDays = filteredRecords
          .where((r) => r.status == AttendanceStatus.absent)
          .length;
      final lateDays = filteredRecords
          .where((r) => r.status == AttendanceStatus.late)
          .length;
      final halfDays = filteredRecords
          .where((r) => r.status == AttendanceStatus.halfDay)
          .length;

      csvContent.writeln('Total Days,${filteredRecords.length}');
      csvContent.writeln('Present Days,$presentDays');
      csvContent.writeln('Absent Days,$absentDays');
      csvContent.writeln('Late Days,$lateDays');
      csvContent.writeln('Half Days,$halfDays');

      // Calculate attendance percentage
      final workingDays = presentDays + lateDays + (halfDays * 0.5);
      final totalDays = filteredRecords.length;
      final attendancePercentage = totalDays > 0
          ? (workingDays / totalDays * 100)
          : 0;

      csvContent.writeln(
        'Attendance %,${attendancePercentage.toStringAsFixed(1)}%',
      );

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'attendance_report_${employee.employeeId}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(csvContent.toString());

      debugPrint('CSV file exported to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error exporting to CSV: $e');
      return null;
    }
  }

  // Export leave requests to CSV
  Future<String?> exportLeaveRequestsToCSV({
    required List<LeaveRequest> requests,
    required Employee employee,
  }) async {
    try {
      // Sort requests by date
      final sortedRequests = List<LeaveRequest>.from(requests);
      sortedRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final StringBuffer csvContent = StringBuffer();

      // Header section
      csvContent.writeln('LEAVE REQUESTS REPORT');
      csvContent.writeln('');
      csvContent.writeln('Employee Name,${employee.name}');
      csvContent.writeln('Employee ID,${employee.employeeId}');
      csvContent.writeln('Department,${employee.department}');
      csvContent.writeln(
        'Generated,${DateFormat('MMM dd yyyy HH:mm').format(DateTime.now())}',
      );
      csvContent.writeln('');

      // Table headers
      csvContent.writeln(
        'Request Date,Leave Type,Start Date,End Date,Days,Status,Reason,Admin Comments',
      );

      // Data rows
      for (final request in sortedRequests) {
        csvContent.write(
          '${DateFormat('MMM dd yyyy').format(request.createdAt)},',
        );
        csvContent.write('${_getLeaveTypeDisplayName(request.type)},');
        csvContent.write(
          '${DateFormat('MMM dd yyyy').format(request.startDate)},',
        );
        csvContent.write(
          '${DateFormat('MMM dd yyyy').format(request.endDate)},',
        );
        csvContent.write('${request.leaveDays},');
        csvContent.write('${_getLeaveStatusDisplayName(request.status)},');
        csvContent.write('"${request.reason}",');
        csvContent.writeln('"${request.adminComments ?? '-'}"');
      }

      // Summary section
      csvContent.writeln('');
      csvContent.writeln('SUMMARY');

      final pendingRequests = sortedRequests
          .where((r) => r.status == LeaveStatus.pending)
          .length;
      final approvedRequests = sortedRequests
          .where((r) => r.status == LeaveStatus.approved)
          .length;
      final rejectedRequests = sortedRequests
          .where((r) => r.status == LeaveStatus.rejected)
          .length;
      final totalLeaveDays = sortedRequests
          .where((r) => r.status == LeaveStatus.approved)
          .fold<int>(0, (sum, r) => sum + r.leaveDays);

      csvContent.writeln('Total Requests,${sortedRequests.length}');
      csvContent.writeln('Pending,$pendingRequests');
      csvContent.writeln('Approved,$approvedRequests');
      csvContent.writeln('Rejected,$rejectedRequests');
      csvContent.writeln('Total Leave Days Taken,$totalLeaveDays');

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'leave_requests_${employee.employeeId}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(csvContent.toString());

      debugPrint('Leave requests CSV exported to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error exporting leave requests to CSV: $e');
      return null;
    }
  }

  // Share exported file
  Future<bool> shareFile(String filePath, {String? subject}) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('File does not exist: $filePath');
        return false;
      }

      final fileName = filePath.split('/').last;
      final xFile = XFile(filePath);

      await Share.shareXFiles(
        [xFile],
        subject: subject ?? 'Report - $fileName',
        text: 'Please find the attached report.',
      );

      return true;
    } catch (e) {
      debugPrint('Error sharing file: $e');
      return false;
    }
  }

  // Get all exported files
  Future<List<String>> getExportedFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory
          .listSync()
          .where(
            (entity) =>
                entity is File &&
                (entity.path.endsWith('.csv') ||
                    entity.path.endsWith('.xlsx') ||
                    entity.path.endsWith('.pdf')),
          )
          .map((entity) => entity.path)
          .toList();

      // Sort by modification date (newest first)
      files.sort((a, b) {
        return File(b).lastModifiedSync().compareTo(File(a).lastModifiedSync());
      });

      return files;
    } catch (e) {
      debugPrint('Error getting exported files: $e');
      return [];
    }
  }

  // Delete exported file
  Future<bool> deleteExportedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('File deleted: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }

  // Helper methods
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String _getStatusDisplayName(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.workFromHome:
        return 'WFH';

      case AttendanceStatus.holiday:
        return 'Holiday';
      case AttendanceStatus.leave:
        return 'Leave';
    }
  }

  String _getLeaveTypeDisplayName(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'Annual Leave';
      case LeaveType.sick:
        return 'Sick Leave';
      case LeaveType.personal:
        return 'Personal Leave';
      case LeaveType.emergency:
        return 'Emergency Leave';
      case LeaveType.maternity:
        return 'Maternity Leave';
      case LeaveType.paternity:
        return 'Paternity Leave';
      case LeaveType.workFromHome:
        return 'Work From Home';
    }
  }

  String _getLeaveStatusDisplayName(LeaveStatus status) {
    switch (status) {
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
