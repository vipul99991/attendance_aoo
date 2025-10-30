/// String manipulation utilities
class StringUtils {
  /// Check if a string is null or empty
  static bool isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  /// Check if a string is null, empty or contains only whitespace
  static bool isNullOrBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Truncate a string to a specified length with an optional suffix
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Capitalize the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalize the first letter of each word in a string
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Convert a string to title case
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Convert camelCase string to snake_case
  static String camelCaseToSnakeCase(String camelCase) {
    return camelCase.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst('_', '');
  }

  /// Convert snake_case string to camelCase
  static String snakeCaseToCamelCase(String snakeCase) {
    return snakeCase.split('_').asMap().entries.map((entry) {
      int index = entry.key;
      String value = entry.value;
      if (index == 0) {
        return value.toLowerCase();
      }
      return value[0].toUpperCase() + value.substring(1).toLowerCase();
    }).join('');
  }

  /// Convert camelCase string to Title Case with spaces
  static String camelCaseToTitle(String camelCase) {
    final result = camelCase.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)!}',
    );
    return capitalizeWords(result.trim());
  }

  /// Remove all non-alphanumeric characters from a string
  static String removeNonAlphanumeric(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Count the number of words in a string
  static int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  /// Count the number of characters in a string (excluding whitespace)
  static int countCharactersNoWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '').length;
  }

  /// Check if a string contains only digits
  static bool isNumeric(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }

  /// Check if a string contains only alphabetic characters
  static bool isAlpha(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(text);
  }

  /// Check if a string contains only alphanumeric characters
  static bool isAlphanumeric(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);
  }

  /// Reverse a string
  static String reverse(String text) {
    return text.split('').reversed.join('');
  }

  /// Pad a string to a specified length with a padding character
  static String padLeft(String text, int length, String paddingChar) {
    if (text.length >= length) return text;
    return paddingChar * (length - text.length) + text;
  }

  /// Pad a string to a specified length with a padding character
  static String padRight(String text, int length, String paddingChar) {
    if (text.length >= length) return text;
    return text + (paddingChar * (length - text.length));
  }

  /// Remove duplicate characters from a string
  static String removeDuplicates(String text) {
    return text.split('').toSet().join('');
  }

  /// Extract the first n characters from a string
  static String takeFirst(String text, int n) {
    if (n >= text.length) return text;
    return text.substring(0, n);
  }

  /// Extract the last n characters from a string
  static String takeLast(String text, int n) {
    if (n >= text.length) return text;
    return text.substring(text.length - n);
  }

  /// Remove the first n characters from a string
  static String skipFirst(String text, int n) {
    if (n >= text.length) return '';
    return text.substring(n);
  }

  /// Remove the last n characters from a string
  static String skipLast(String text, int n) {
    if (n >= text.length) return '';
    return text.substring(0, text.length - n);
  }

  /// Repeat a string n times
  static String repeat(String text, int n) {
    if (n <= 0) return '';
    return text * n;
  }

  /// Check if a string is a valid email
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  /// Check if a string is a valid phone number
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    return RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(phone);
  }

  /// Mask a string by showing only the first and last characters
  static String mask(String text, {int visibleCount = 2, String maskChar = '*'}) {
    if (text.length <= visibleCount * 2) {
      return maskChar * text.length;
    }
    
    String start = text.substring(0, visibleCount);
    String end = text.substring(text.length - visibleCount);
    String middle = maskChar * (text.length - visibleCount * 2);
    
    return '$start$middle$end';
  }

  /// Convert string to proper case (first letter of each sentence capitalized)
  static String toProperCase(String text) {
    if (text.isEmpty) return text;
    
    // Split by sentence endings and capitalize the first letter after each
    List<String> sentences = text.split(RegExp(r'([.!?])'));
    List<String> result = [];
    
    for (String sentence in sentences) {
      if (sentence.trim().isNotEmpty) {
        // Find the first letter in the sentence and capitalize it
        String processedSentence = sentence.replaceFirstMapped(
          RegExp(r'[a-zA-Z]'),
          (match) => match.group(0)!.toUpperCase(),
        );
        result.add(processedSentence);
      } else {
        result.add(sentence);
      }
    }
    
    // Rejoin with sentence endings
    String output = '';
    int sentenceIndex = 0;
    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'[.!?]').hasMatch(text[i])) {
        if (sentenceIndex < result.length) {
          output += result[sentenceIndex];
          sentenceIndex++;
        }
        output += text[i];
      }
    }
    
    // Add any remaining sentences
    for (int i = sentenceIndex; i < result.length; i++) {
      output += result[i];
    }
    
    return output;
  }

  /// Get the common prefix of two strings
  static String getCommonPrefix(String str1, String str2) {
    int minLength = str1.length < str2.length ? str1.length : str2.length;
    String prefix = '';
    
    for (int i = 0; i < minLength; i++) {
      if (str1[i] == str2[i]) {
        prefix += str1[i];
      } else {
        break;
      }
    }
    
    return prefix;
  }

  /// Get the common suffix of two strings
  static String getCommonSuffix(String str1, String str2) {
    int minLength = str1.length < str2.length ? str1.length : str2.length;
    String suffix = '';
    
    for (int i = 0; i < minLength; i++) {
      if (str1[str1.length - 1 - i] == str2[str2.length - 1 - i]) {
        suffix = str1[str1.length - 1 - i] + suffix;
      } else {
        break;
      }
    }
    
    return suffix;
  }

  /// Calculate the Levenshtein distance between two strings
  static int levenshteinDistance(String str1, String str2) {
    int m = str1.length;
    int n = str2.length;
    
    List<List<int>> dp = List.generate(
      m + 1,
      (i) => List.filled(n + 1, 0),
      growable: false,
    );
    
    for (int i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    
    for (int j = 0; j <= n; j++) {
      dp[0][j] = j;
    }
    
    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (str1[i - 1] == str2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + dp[i - 1][j - 1].compareTo(dp[i][j - 1]).compareTo(dp[i - 1][j]);
          dp[i][j] = 1 + [
            dp[i - 1][j - 1], // substitution
            dp[i][j - 1],     // insertion
            dp[i - 1][j]      // deletion
          ].reduce((a, b) => a < b ? a : b);
        }
      }
    }
    
    return dp[m][n];
 }

  /// Check if two strings are similar based on Levenshtein distance
  static bool isSimilar(String str1, String str2, {double threshold = 0.7}) {
    int distance = levenshteinDistance(str1, str2);
    int maxLength = str1.length > str2.length ? str1.length : str2.length;
    
    if (maxLength == 0) return true;
    
    double similarity = 1.0 - (distance / maxLength);
    return similarity >= threshold;
  }
}