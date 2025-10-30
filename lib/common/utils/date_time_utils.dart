/// Comprehensive date and time utilities with proper documentation
import 'package:intl/intl.dart';

class DateTimeUtils {
  /// Format a DateTime object to a string using the specified format
  static String format(DateTime dateTime, {String format = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(format).format(dateTime);
    } catch (e) {
      throw FormatException('Invalid date format: $format', e);
    }
  }

  /// Parse a date string to DateTime object using the specified format
  static DateTime parse(String dateString, {String format = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date string: $dateString', e);
    }
  }

  /// Parse a date string to DateTime object with strict parsing
  static DateTime parseStrict(String dateString, {String format = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(format).parseStrict(dateString);
    } catch (e) {
      throw FormatException('Invalid date string: $dateString', e);
    }
  }

  /// Get the start of the day for a given DateTime
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Get the end of the day for a given DateTime
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999, 999);
  }

  /// Get the start of the month for a given DateTime
  static DateTime startOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  /// Get the end of the month for a given DateTime
  static DateTime endOfMonth(DateTime dateTime) {
    final nextMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    return DateTime(nextMonth.year, nextMonth.month, nextMonth.day, 23, 59, 999, 999);
  }

  /// Get the start of the year for a given DateTime
  static DateTime startOfYear(DateTime dateTime) {
    return DateTime(dateTime.year, 1, 1);
  }

  /// Get the end of the year for a given DateTime
  static DateTime endOfYear(DateTime dateTime) {
    return DateTime(dateTime.year, 12, 31, 23, 59, 999, 999);
  }

  /// Check if a given date is today
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// Check if a given date is yesterday
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  /// Check if a given date is tomorrow
  static bool isTomorrow(DateTime dateTime) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day;
  }

  /// Check if two dates are in the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if a given date is in the same week as another date
  static bool isSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek1 = getStartOfWeek(date1);
    final startOfWeek2 = getStartOfWeek(date2);
    return isSameDay(startOfWeek1, startOfWeek2);
  }

  /// Check if a given date is in the same month as another date
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Check if a given date is in the same year as another date
  static bool isSameYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year;
  }

  /// Get the start of the week for a given DateTime (Monday is the first day of the week)
  static DateTime getStartOfWeek(DateTime dateTime) {
    final daysFromMonday = dateTime.weekday - 1;
    return DateTime(dateTime.year, dateTime.month, dateTime.day - daysFromMonday);
  }

  /// Get the end of the week for a given DateTime (Sunday is the last day of the week)
  static DateTime getEndOfWeek(DateTime dateTime) {
    final daysToSunday = 7 - dateTime.weekday;
    return DateTime(dateTime.year, dateTime.month, dateTime.day + daysToSunday, 23, 59, 999, 999);
  }

  /// Calculate the difference in days between two dates
  static int differenceInDays(DateTime date1, DateTime date2) {
    final difference = date1.difference(date2);
    return difference.inDays.abs();
  }

  /// Calculate the difference in weeks between two dates
  static int differenceInWeeks(DateTime date1, DateTime date2) {
    return (differenceInDays(date1, date2) / 7).floor();
  }

  /// Calculate the difference in months between two dates
  static int differenceInMonths(DateTime date1, DateTime date2) {
    int months = (date1.year - date2.year) * 12;
    months += date1.month - date2.month;
    return months.abs();
  }

  /// Calculate the difference in years between two dates
  static int differenceInYears(DateTime date1, DateTime date2) {
    return (date1.year - date2.year).abs();
  }

  /// Add days to a given date
  static DateTime addDays(DateTime dateTime, int days) {
    return dateTime.add(Duration(days: days));
  }

  /// Add weeks to a given date
  static DateTime addWeeks(DateTime dateTime, int weeks) {
    return dateTime.add(Duration(days: weeks * 7));
  }

  /// Add months to a given date
  static DateTime addMonths(DateTime dateTime, int months) {
    return DateTime(dateTime.year, dateTime.month + months, dateTime.day);
  }

  /// Add years to a given date
  static DateTime addYears(DateTime dateTime, int years) {
    return DateTime(dateTime.year + years, dateTime.month, dateTime.day);
  }

  /// Check if a given year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }

  /// Get the number of days in a given month
  static int getDaysInMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    
    const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 30, 31, 30, 31];
    int days = daysInMonth[month - 1];
    
    if (month == 2 && isLeapYear(year)) {
      days = 29;
    }
    
    return days;
  }

  /// Format duration in human-readable format
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Convert time of day (hours and minutes) to DateTime
  static DateTime timeOfDayToDateTime(int hour, int minute, {DateTime? baseDate}) {
    final date = baseDate ?? DateTime.now();
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  /// Get current timestamp as milliseconds since epoch
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Convert milliseconds since epoch to DateTime
  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Check if a given date is within a range (inclusive)
  static bool isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }

  /// Get the age in years from a birth date
  static int getAgeFromBirthDate(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
}