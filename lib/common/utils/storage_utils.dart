/// Local storage utilities
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static SharedPreferences? _sharedPreferences;

  /// Initialize the storage utility
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

 /// Get the SharedPreferences instance, initializing if necessary
  static Future<SharedPreferences> _getInstance() async {
    if (_sharedPreferences == null) {
      await init();
    }
    return _sharedPreferences!;
  }

  /// Save a string value
  static Future<bool> saveString(String key, String value) async {
    final prefs = await _getInstance();
    return await prefs.setString(key, value);
  }

  /// Read a string value
  static Future<String?> readString(String key) async {
    final prefs = await _getInstance();
    return prefs.getString(key);
  }

  /// Save an integer value
 static Future<bool> saveInt(String key, int value) async {
    final prefs = await _getInstance();
    return await prefs.setInt(key, value);
  }

  /// Read an integer value
  static Future<int?> readInt(String key) async {
    final prefs = await _getInstance();
    return prefs.getInt(key);
  }

  /// Save a double value
 static Future<bool> saveDouble(String key, double value) async {
    final prefs = await _getInstance();
    return await prefs.setDouble(key, value);
  }

  /// Read a double value
  static Future<double?> readDouble(String key) async {
    final prefs = await _getInstance();
    return prefs.getDouble(key);
  }

  /// Save a boolean value
  static Future<bool> saveBool(String key, bool value) async {
    final prefs = await _getInstance();
    return await prefs.setBool(key, value);
  }

  /// Read a boolean value
  static Future<bool?> readBool(String key) async {
    final prefs = await _getInstance();
    return prefs.getBool(key);
  }

  /// Save a list of strings
  static Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await _getInstance();
    return await prefs.setStringList(key, value);
  }

  /// Read a list of strings
  static Future<List<String>?> readStringList(String key) async {
    final prefs = await _getInstance();
    return prefs.getStringList(key);
 }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await _getInstance();
    return prefs.containsKey(key);
  }

  /// Remove a key-value pair
  static Future<bool> remove(String key) async {
    final prefs = await _getInstance();
    return await prefs.remove(key);
  }

  /// Clear all stored values
  static Future<bool> clear() async {
    final prefs = await _getInstance();
    return await prefs.clear();
  }

  /// Get all keys
  static Future<Set<String>> getKeys() async {
    final prefs = await _getInstance();
    return prefs.getKeys();
  }

  /// Save an object that can be serialized to JSON
  static Future<bool> saveObject<T>(String key, T object) async {
    try {
      final prefs = await _getInstance();
      String jsonString = jsonEncode(object);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Read an object that was serialized to JSON
 static Future<T?> readObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final prefs = await _getInstance();
      String? jsonString = prefs.getString(key);
      if (jsonString == null) return null;
      
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

 /// Save a list of objects that can be serialized to JSON
  static Future<bool> saveObjectList<T>(String key, List<T> objects) async {
    try {
      final prefs = await _getInstance();
      List<String> jsonStrings = objects.map((obj) => jsonEncode(obj)).toList();
      return await prefs.setStringList(key, jsonStrings);
    } catch (e) {
      return false;
    }
  }

  /// Read a list of objects that were serialized to JSON
  static Future<List<T>?> readObjectList<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final prefs = await _getInstance();
      List<String>? jsonStrings = prefs.getStringList(key);
      if (jsonStrings == null) return null;
      
      List<T> objects = [];
      for (String jsonString in jsonStrings) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        objects.add(fromJson(jsonMap));
      }
      return objects;
    } catch (e) {
      return null;
    }
  }

  /// Get the size of stored data for a specific key
 static Future<int> getValueSize(String key) async {
    final prefs = await _getInstance();
    dynamic value = prefs.get(key);
    if (value == null) return 0;
    
    String valueString = value.toString();
    return utf8.encode(valueString).length;
  }

  /// Get the total size of all stored data
  static Future<int> getTotalSize() async {
    final prefs = await _getInstance();
    int totalSize = 0;
    
    for (String key in prefs.getKeys()) {
      totalSize += await getValueSize(key);
    }
    
    return totalSize;
  }

  /// Save data with an expiration time
  static Future<bool> saveWithExpiry(String key, String value, Duration expiryDuration) async {
    final prefs = await _getInstance();
    final expiryTime = DateTime.now().add(expiryDuration).millisecondsSinceEpoch;
    
    // Store the value with its expiry time
    Map<String, dynamic> data = {
      'value': value,
      'expiry': expiryTime,
    };
    
    String jsonString = jsonEncode(data);
    return await prefs.setString(key, jsonString);
  }

  /// Read data that has an expiration time
  static Future<String?> readWithExpiry(String key) async {
    final prefs = await _getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      Map<String, dynamic> data = jsonDecode(jsonString);
      String value = data['value'];
      int expiryTime = data['expiry'];
      
      // Check if the data has expired
      if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
        // Remove the expired data
        await prefs.remove(key);
        return null;
      }
      
      return value;
    } catch (e) {
      // If there's an error parsing the data, return null
      return null;
    }
  }

  /// Get the remaining time for an expirable value
  static Future<Duration?> getTimeToExpiry(String key) async {
    final prefs = await _getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      Map<String, dynamic> data = jsonDecode(jsonString);
      int expiryTime = data['expiry'];
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      
      int remainingTime = expiryTime - currentTime;
      if (remainingTime <= 0) {
        // Remove the expired data
        await prefs.remove(key);
        return Duration.zero;
      }
      
      return Duration(milliseconds: remainingTime);
    } catch (e) {
      return null;
    }
  }

  /// Update a counter value
  static Future<int> updateCounter(String key, int increment) async {
    final prefs = await _getInstance();
    int currentValue = prefs.getInt(key) ?? 0;
    int newValue = currentValue + increment;
    
    await prefs.setInt(key, newValue);
    return newValue;
 }

  /// Get a counter value
  static Future<int> getCounter(String key) async {
    final prefs = await _getInstance();
    return prefs.getInt(key) ?? 0;
  }

  /// Reset a counter to zero
  static Future<bool> resetCounter(String key) async {
    final prefs = await _getInstance();
    return await prefs.setInt(key, 0);
  }

  /// Check if storage is initialized
  static bool isInitialized() {
    return _sharedPreferences != null;
  }
}