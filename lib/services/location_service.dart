import 'package:geolocator/geolocator.dart';

class LocationService {
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
    timeLimit: Duration(seconds: 30),
  );

  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Future<double> distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<bool> isWithinRadius({
    required double currentLat,
    required double currentLng,
    required double targetLat,
    required double targetLng,
    required double radiusInMeters,
  }) async {
    final distance = await distanceBetween(
      currentLat,
      currentLng,
      targetLat,
      targetLng,
    );
    return distance <= radiusInMeters;
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(locationSettings: _locationSettings);
  }

  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // You might want to use geocoding package for this
      return '$latitude, $longitude';
    } catch (e) {
      print('Error getting address: $e');
      return '$latitude, $longitude';
    }
  }
}
