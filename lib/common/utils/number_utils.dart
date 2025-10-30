/// Number formatting and calculation utilities
import 'dart:math' as math;

class NumberUtils {
  /// Format a number with commas as thousand separators
  static String formatWithCommas(num number, {int? decimalPlaces}) {
    String formattedNumber;
    
    if (decimalPlaces != null) {
      formattedNumber = number.toStringAsFixed(decimalPlaces);
    } else {
      formattedNumber = number.toString();
    }
    
    // Split into integer and decimal parts
    List<String> parts = formattedNumber.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
    
    // Add commas to the integer part
    String reversedInteger = integerPart.split('').reversed.join('');
    List<String> groups = [];
    for (int i = 0; i < reversedInteger.length; i += 3) {
      groups.add(reversedInteger.substring(
        i, 
        i + 3 > reversedInteger.length ? reversedInteger.length : i + 3
      ));
    }
    
    String formattedInteger = groups.join(',').split('').reversed.join('');
    
    return formattedInteger + decimalPart;
  }

  /// Format currency with the specified currency symbol
  static String formatCurrency(num amount, {String currencySymbol = '\$', int decimalPlaces = 2}) {
    String formattedAmount = formatWithCommas(amount, decimalPlaces: decimalPlaces);
    return '$currencySymbol$formattedAmount';
  }

  /// Format a percentage value
  static String formatPercentage(double value, {int decimalPlaces = 2}) {
    return '${value.toStringAsFixed(decimalPlaces)}%';
  }

  /// Round a number to the specified number of decimal places
  static double roundToDecimalPlaces(double value, int decimalPlaces) {
    double factor = math.pow(10, decimalPlaces).toDouble();
    return (value * factor).roundToDouble() / factor;
  }

  /// Convert a number to ordinal (1st, 2nd, 3rd, etc.)
  static String toOrdinal(int number) {
    if (number <= 0) return number.toString();
    
    String suffix;
    int lastDigit = number % 10;
    int lastTwoDigits = number % 100;
    
    if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
      suffix = 'th';
    } else {
      switch (lastDigit) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
          break;
      }
    }
    
    return '${number}${suffix}';
  }

  /// Calculate the percentage of one number relative to another
  static double calculatePercentage(num part, num whole) {
    if (whole == 0) return 0.0;
    return (part / whole) * 100.0;
  }

  /// Clamp a value between a minimum and maximum
  static num clamp(num value, num min, num max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Check if a number is within a range (inclusive)
  static bool isInRange(num value, num min, num max) {
    return value >= min && value <= max;
  }

  /// Calculate the difference between two numbers
  static num difference(num a, num b) {
    return (a - b).abs();
  }

  /// Calculate the sum of a list of numbers
  static num sum(List<num> numbers) {
    num total = 0;
    for (num number in numbers) {
      total += number;
    }
    return total;
  }

  /// Calculate the average of a list of numbers
  static double average(List<num> numbers) {
    if (numbers.isEmpty) return 0.0;
    return sum(numbers).toDouble() / numbers.length;
  }

  /// Find the minimum value in a list of numbers
  static num min(List<num> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    num minValue = numbers[0];
    for (num number in numbers) {
      if (number < minValue) {
        minValue = number;
      }
    }
    return minValue;
  }

  /// Find the maximum value in a list of numbers
  static num max(List<num> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    num maxValue = numbers[0];
    for (num number in numbers) {
      if (number > maxValue) {
        maxValue = number;
      }
    }
    return maxValue;
  }

  /// Calculate the median of a list of numbers
  static double median(List<num> numbers) {
    if (numbers.isEmpty) return 0.0;
    
    List<num> sortedNumbers = List.from(numbers)..sort((a, b) => a.compareTo(b));
    int length = sortedNumbers.length;
    
    if (length % 2 == 0) {
      // Even number of elements - average the two middle values
      int midIndex1 = length ~/ 2 - 1;
      int midIndex2 = length ~/ 2;
      return (sortedNumbers[midIndex1].toDouble() + sortedNumbers[midIndex2].toDouble()) / 2.0;
    } else {
      // Odd number of elements - return the middle value
      int midIndex = length ~/ 2;
      return sortedNumbers[midIndex].toDouble();
    }
  }

  /// Calculate the factorial of a number
  static BigInt factorial(int n) {
    if (n < 0) throw ArgumentError('Factorial is not defined for negative numbers');
    if (n == 0 || n == 1) return BigInt.one;
    
    BigInt result = BigInt.one;
    for (int i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  /// Calculate the greatest common divisor (GCD) of two numbers
  static int gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Calculate the least common multiple (LCM) of two numbers
  static int lcm(int a, int b) {
    if (a == 0 || b == 0) return 0;
    return (a * b).abs() ~/ gcd(a, b);
  }

  /// Check if a number is prime
  static bool isPrime(int number) {
    if (number <= 1) return false;
    if (number <= 3) return true;
    if (number % 2 == 0 || number % 3 == 0) return false;
    
    for (int i = 5; i * i <= number; i += 6) {
      if (number % i == 0 || number % (i + 2) == 0) {
        return false;
      }
    }
    
    return true;
  }

  /// Generate a random integer between min and max (inclusive)
  static int randomInt(int min, int max) {
    if (min > max) throw ArgumentError('Min cannot be greater than max');
    return min + (math.Random().nextInt(max - min + 1));
  }

  /// Generate a random double between min and max
  static double randomDouble(double min, double max) {
    if (min > max) throw ArgumentError('Min cannot be greater than max');
    return min + (math.Random().nextDouble() * (max - min));
  }

  /// Convert radians to degrees
  static double radiansToDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }

  /// Convert degrees to radians
  static double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  /// Calculate the distance between two points
  static double distanceBetween(double x1, double y1, double x2, double y2) {
    double dx = x2 - x1;
    double dy = y2 - y1;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Check if a number is even
  static bool isEven(int number) {
    return number % 2 == 0;
  }

  /// Check if a number is odd
  static bool isOdd(int number) {
    return number % 2 != 0;
  }

  /// Convert a number to Roman numerals
  static String toRomanNumeral(int number) {
    if (number <= 0 || number > 3999) {
      throw ArgumentError('Number must be between 1 and 3999');
    }

    const List<int> values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    const List<String> numerals = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];

    String result = '';
    int remaining = number;

    for (int i = 0; i < values.length; i++) {
      while (remaining >= values[i]) {
        result += numerals[i];
        remaining -= values[i];
      }
    }

    return result;
  }

  /// Parse a string to an integer, returning null if parsing fails
  static int? parseIntSafe(String? value) {
    if (value == null) return null;
    try {
      return int.parse(value);
    } catch (e) {
      return null;
    }
  }

  /// Parse a string to a double, returning null if parsing fails
  static double? parseDoubleSafe(String? value) {
    if (value == null) return null;
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

  /// Check if a double value is a whole number
  static bool isWholeNumber(double value) {
    return value == value.roundToDouble();
  }

  /// Scale a value from one range to another
  static double scaleValue(
    double value, 
    double fromMin, 
    double fromMax, 
    double toMin, 
    double toMax
  ) {
    if (fromMin == fromMax) return toMin;
    return toMin + (value - fromMin) * (toMax - toMin) / (fromMax - fromMin);
  }
}

// Import statement for math operations
import 'dart:math' as math;