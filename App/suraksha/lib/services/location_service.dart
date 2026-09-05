import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  Future<Position?> getLocation() async {
    debugPrint('🔍 getLocation() called');
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('📍 Permission status: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('⚠️ Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
        debugPrint('📍 After request: $permission');
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ Permission denied forever');
        return null;
      }

      final position = await Geolocator.getCurrentPosition();
      debugPrint(
        '✅ Location obtained: ${position.latitude}, ${position.longitude}',
      );
      return position;
    } catch (e) {
      debugPrint('❌ getLocation error: $e');
      return null;
    }
  }
  
  Stream<Position> startTracking() {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ),
  );
}
}
