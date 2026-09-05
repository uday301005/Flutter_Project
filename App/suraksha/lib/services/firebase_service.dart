import 'package:flutter/foundation.dart';

import 'appwrite_services.dart';

class FirebaseService {
  final AppwriteService _appwriteService = AppwriteService();

  Future<void> sendSOS(double lat, double lon) async {
    debugPrint('🔍 sendSOS() called with lat=$lat, lon=$lon');
    try {
      final currentUser = await _appwriteService.getSession();
      await _appwriteService.sendSOS(
        senderId: currentUser.$id,
        latitude: lat,
        longitude: lon,
      );
      debugPrint('✅ SOS alert saved to Appwrite');
    } catch (e) {
      debugPrint('❌ sendSOS error: $e');
      rethrow;
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dx = lat1 - lat2;
    final dy = lon1 - lon2;
    return (dx * dx + dy * dy) * 111; // approx km
  }
}
