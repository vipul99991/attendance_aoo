import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/attendance.dart';
import '../models/leave_request.dart';
import '../models/user.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'attendance_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _usersTable = 'users';
  static const String _attendanceTable = 'attendance';
  static const String _leaveRequestsTable = 'leave_requests';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE $_usersTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        profileImage TEXT,
        department TEXT NOT NULL,
        designation TEXT NOT NULL,
        joinDate TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        role TEXT NOT NULL DEFAULT 'employee'
      )
    ''');

    // Create attendance table
    await db.execute('''
      CREATE TABLE $_attendanceTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        date TEXT NOT NULL,
        checkInTime TEXT,
        checkOutTime TEXT,
        checkInLocation TEXT,
        checkOutLocation TEXT,
        status TEXT NOT NULL DEFAULT 'absent',
        notes TEXT,
        totalHours INTEGER,
        isLateCheckIn INTEGER NOT NULL DEFAULT 0,
        isEarlyCheckOut INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES $_usersTable (id)
      )
    ''');

    // Create leave requests table
    await db.execute('''
      CREATE TABLE $_leaveRequestsTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        type TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        reason TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        requestDate TEXT NOT NULL,
        approvedBy TEXT,
        approvedDate TEXT,
        remarks TEXT,
        totalDays INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_usersTable (id)
      )
    ''');

    // Create indexes for better performance
    await db.execute(
      'CREATE INDEX idx_attendance_user_date ON $_attendanceTable (userId, date)',
    );
    await db.execute(
      'CREATE INDEX idx_leave_requests_user ON $_leaveRequestsTable (userId)',
    );
  }

  Future<void> initializeDatabase() async {
    await database;
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(_usersTable, user.toJson());
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      _usersTable,
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Attendance operations
  Future<int> insertAttendance(Attendance attendance) async {
    final db = await database;
    return await db.insert(_attendanceTable, attendance.toJson());
  }

  Future<List<Attendance>> getAttendanceRecords(
    String userId, {
    int? limit,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _attendanceTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return Attendance.fromJson(maps[i]);
    });
  }

  Future<Attendance?> getAttendanceForDate(String userId, DateTime date) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      _attendanceTable,
      where: 'userId = ? AND date LIKE ?',
      whereArgs: [userId, '$dateString%'],
    );

    if (maps.isNotEmpty) {
      return Attendance.fromJson(maps.first);
    }
    return null;
  }

  Future<int> updateAttendance(Attendance attendance) async {
    final db = await database;
    return await db.update(
      _attendanceTable,
      attendance.toJson(),
      where: 'id = ?',
      whereArgs: [attendance.id],
    );
  }

  Future<List<Attendance>> getAttendanceForMonth(
    String userId,
    DateTime month,
  ) async {
    final db = await database;
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);

    final List<Map<String, dynamic>> maps = await db.query(
      _attendanceTable,
      where: 'userId = ? AND date >= ? AND date <= ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Attendance.fromJson(maps[i]);
    });
  }

  // Leave request operations
  Future<int> insertLeaveRequest(LeaveRequest leaveRequest) async {
    final db = await database;
    return await db.insert(_leaveRequestsTable, leaveRequest.toJson());
  }

  Future<List<LeaveRequest>> getLeaveRequests(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _leaveRequestsTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'requestDate DESC',
    );

    return List.generate(maps.length, (i) {
      return LeaveRequest.fromJson(maps[i]);
    });
  }

  Future<int> updateLeaveRequest(LeaveRequest leaveRequest) async {
    final db = await database;
    return await db.update(
      _leaveRequestsTable,
      leaveRequest.toJson(),
      where: 'id = ?',
      whereArgs: [leaveRequest.id],
    );
  }

  // Statistics
  Future<Map<String, int>> getAttendanceStats(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _attendanceTable,
      where: 'userId = ? AND date >= ? AND date <= ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );

    int present = 0, absent = 0, onLeave = 0, halfDay = 0;

    for (var map in maps) {
      switch (map['status']) {
        case 'present':
          present++;
          break;
        case 'absent':
          absent++;
          break;
        case 'onLeave':
          onLeave++;
          break;
        case 'halfDay':
          halfDay++;
          break;
      }
    }

    return {
      'present': present,
      'absent': absent,
      'onLeave': onLeave,
      'halfDay': halfDay,
      'total': maps.length,
    };
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
