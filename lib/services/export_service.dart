import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/employee_model.dart';
import '../utils/constants.dart';

// Helper functions for Excel color handling
// Remove the helper function for now since the Excel package version may not support it

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  // Export attendance data to Excel
  Future<String?> exportAttendanceToExcel({
    required List<AttendanceRecord> records,
    required Employee employee,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Attendance Report'];

      // Remove default sheet
      excel.delete('Sheet1');

      // Header styling
      final headerStyle = CellStyle(
        fontFamily: 'Calibri',
        fontSize: 12,
        bold: true,
      );

      // Data styling
      final dataStyle = CellStyle(fontFamily: 'Calibri', fontSize: 11);

      // Title and employee info
      sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
        'ATTENDANCE REPORT',
      );
      sheet.cell(CellIndex.indexByString('A1')).cellStyle = CellStyle(
        fontSize: 16,
        bold: true,
      );

      sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue(
        'Employee Name:',
      );
      sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(
        employee.name,
      );
      sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue(
        'Employee ID:',
      );
      sheet.cell(CellIndex.indexByString('B4')).value = TextCellValue(
        employee.employeeId,
      );
      sheet.cell(CellIndex.indexByString('A5')).value = TextCellValue(
        'Department:',
      );
      sheet.cell(CellIndex.indexByString('B5')).value = TextCellValue(
        employee.department,
      );

      if (startDate != null && endDate != null) {
        sheet.cell(CellIndex.indexByString('A6')).value = TextCellValue(
          'Period:',
        );
        sheet.cell(CellIndex.indexByString('B6')).value = TextCellValue(
          '${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
        );
      }

      sheet.cell(CellIndex.indexByString('A7')).value = TextCellValue(
        'Generated:',
      );
      sheet.cell(CellIndex.indexByString('B7')).value = TextCellValue(
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now()),
      );

      // Table headers
      const headers = [
        'Date',
        'Check In',
        'Check Out',
        'Working Hours',
        'Overtime',
        'Status',
        'Location',
        'Notes',
      ];

      int headerRow = 9;
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: headerRow),
        );
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = headerStyle;
      }

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

      // Data rows
      for (int i = 0; i < filteredRecords.length; i++) {
        final record = filteredRecords[i];
        final row = headerRow + 1 + i;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = TextCellValue(
          DateFormat('MMM dd, yyyy').format(record.date),
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
                .cellStyle =
            dataStyle;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = TextCellValue(
          record.checkInTime != null
              ? DateFormat('HH:mm').format(record.checkInTime!)
              : '-',
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
                .cellStyle =
            dataStyle;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = TextCellValue(
          record.checkOutTime != null
              ? DateFormat('HH:mm').format(record.checkOutTime!)
              : '-',
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
                .cellStyle =
            dataStyle;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = TextCellValue(
          record.totalWorkTime != null
              ? _formatDuration(record.totalWorkTime!)
              : '-',
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
                .cellStyle =
            dataStyle;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = TextCellValue(
          record.overtimeHours != null
              ? _formatDuration(record.overtimeHours!)
              : '-',
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
                .cellStyle =
            dataStyle;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .value = TextCellValue(
          _getStatusDisplayName(record.status),
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
                .cellStyle =
            dataStyle;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
            .value = TextCellValue(
          record.checkInLocation ?? '-',
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
                .cellStyle =
            dataStyle;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
            .value = TextCellValue(
          record.notes ?? '-',
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
                .cellStyle =
            dataStyle;
      }

      // Summary section
      final summaryRow = headerRow + filteredRecords.length + 3;
      sheet
          .cell(
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: summaryRow),
          )
          .value = TextCellValue(
        'SUMMARY',
      );
      sheet
          .cell(
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: summaryRow),
          )
          .cellStyle = CellStyle(
        fontSize: 14,
        bold: true,
      );

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

      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: 0,
              rowIndex: summaryRow + 2,
            ),
          )
          .value = TextCellValue(
        'Total Days:',
      );
      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: 1,
              rowIndex: summaryRow + 2,
            ),
          )
          .value = IntCellValue(
        filteredRecords.length,
      );

      sheet
          .cell(
            CellIndex.indexByColumnRow(
              columnIndex: 0,
              rowIndex: summaryRow + 3,
            ),
          )
          .value = TextCellValue(
        'Present Days:',
      );
      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 1,
                  rowIndex: summaryRow + 3,
                ),
              )
              .value =
          IntCellValue(presentDays);

      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 0,
                  rowIndex: summaryRow + 4,
                ),
              )
              .value =
          TextCellValue('Absent Days:');
      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 1,
                  rowIndex: summaryRow + 4,
                ),
              )
              .value =
          IntCellValue(absentDays);

      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 0,
                  rowIndex: summaryRow + 5,
                ),
              )
              .value =
          TextCellValue('Late Days:');
      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 1,
                  rowIndex: summaryRow + 5,
                ),
              )
              .value =
          IntCellValue(lateDays);

      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 0,
                  rowIndex: summaryRow + 6,
                ),
              )
              .value =
          TextCellValue('Half Days:');
      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 1,
                  rowIndex: summaryRow + 6,
                ),
              )
              .value =
          IntCellValue(halfDays);

      // Calculate attendance percentage
      final workingDays = presentDays + lateDays + (halfDays * 0.5);
      final totalDays = filteredRecords.length;
      final attendancePercentage = totalDays > 0
          ? (workingDays / totalDays * 100)
          : 0;

      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 0,
                  rowIndex: summaryRow + 7,
                ),
              )
              .value =
          TextCellValue('Attendance %:');
      sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: 1,
                  rowIndex: summaryRow + 7,
                ),
              )
              .value =
          TextCellValue('${attendancePercentage.toStringAsFixed(1)}%');

      // Auto-fit columns
      for (int i = 0; i < headers.length; i++) {
        sheet.setColumnAutoFit(i);
      }

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${AppConfig.excelFileName}_${employee.employeeId}_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);

      debugPrint('Excel file exported to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error exporting to Excel: $e');
      return null;
    }
  }

  // Export attendance data to PDF
  Future<String?> exportAttendanceToPDF({
    required List<AttendanceRecord> records,
    required Employee employee,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final pdf = pw.Document();

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

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 2, color: PdfColors.blue),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'ATTENDANCE REPORT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey,
                          ),
                        ),
                        if (startDate != null && endDate != null)
                          pw.Text(
                            'Period: ${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Employee Information
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Employee Information',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Name: ${employee.name}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                'Employee ID: ${employee.employeeId}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                'Department: ${employee.department}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Position: ${employee.position}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                'Email: ${employee.email}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                'Phone: ${employee.phone}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Attendance Table
              pw.Text(
                'Attendance Records',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue),
                    children:
                        ['Date', 'Check In', 'Check Out', 'Hours', 'Status']
                            .map(
                              (header) => pw.Container(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  header,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  // Data rows
                  ...filteredRecords
                      .map(
                        (record) => pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                DateFormat('MMM dd').format(record.date),
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                record.checkInTime != null
                                    ? DateFormat(
                                        'HH:mm',
                                      ).format(record.checkInTime!)
                                    : '-',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                record.checkOutTime != null
                                    ? DateFormat(
                                        'HH:mm',
                                      ).format(record.checkOutTime!)
                                    : '-',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                record.totalWorkTime != null
                                    ? _formatDuration(record.totalWorkTime!)
                                    : '-',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                _getStatusDisplayName(record.status),
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ],
              ),
              pw.SizedBox(height: 20),

              // Summary
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Summary',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Total Days: ${filteredRecords.length}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                'Present: ${filteredRecords.where((r) => r.status == AttendanceStatus.present).length}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                'Late: ${filteredRecords.where((r) => r.status == AttendanceStatus.late).length}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Absent: ${filteredRecords.where((r) => r.status == AttendanceStatus.absent).length}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                'Half Day: ${filteredRecords.where((r) => r.status == AttendanceStatus.halfDay).length}',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                'Attendance: ${_calculateAttendancePercentage(filteredRecords).toStringAsFixed(1)}%',
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${AppConfig.pdfFileName}_${employee.employeeId}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      debugPrint('PDF file exported to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error exporting to PDF: $e');
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
        subject: subject ?? 'Attendance Report - $fileName',
        text: 'Please find the attached attendance report.',
      );

      return true;
    } catch (e) {
      debugPrint('Error sharing file: $e');
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
      case AttendanceStatus.leave:
        return 'Leave';
      case AttendanceStatus.holiday:
        return 'Holiday';
    }
  }

  double _calculateAttendancePercentage(List<AttendanceRecord> records) {
    if (records.isEmpty) return 0.0;

    final presentDays = records
        .where((r) => r.status == AttendanceStatus.present)
        .length;
    final lateDays = records
        .where((r) => r.status == AttendanceStatus.late)
        .length;
    final halfDays = records
        .where((r) => r.status == AttendanceStatus.halfDay)
        .length;

    final workingDays = presentDays + lateDays + (halfDays * 0.5);
    return (workingDays / records.length) * 100;
  }
}
