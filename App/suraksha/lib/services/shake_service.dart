import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/foundation.dart';

class ShakeService {
  StreamSubscription? sensorSub;

  double gx = 0, gy = 0, gz = 0;
  double alpha = 0.8;

  List<DateTime> shakeTimes = [];

  Future<void> Function()? onShakeDetected;

  void start() {
    debugPrint('🔍 ShakeService.start() called');
    if (sensorSub != null) {
      debugPrint('⚠️ Sensor already subscribed');
      return;
    }

    DateTime lastShake = DateTime.now();

    sensorSub = accelerometerEventStream().listen((event) async {
      // debugPrint('📊 Accelerometer: x=${event.x}, y=${event.y}, z=${event.z}');

      double lx = event.x - gx;
      double ly = event.y - gy;
      double lz = event.z - gz;

      double accel = sqrt(lx * lx + ly * ly + lz * lz);
      DateTime now = DateTime.now();
      // debugPrint('📈 Acceleration value: $accel');

      if (accel < 18) {
        // debugPrint('⚠️ Acceleration below threshold');
        return;
      }

      if (now.difference(lastShake).inMilliseconds < 500) {
        debugPrint('⏱️ Too soon, ignoring');
        return;
      }
      lastShake = now;

      shakeTimes.add(now);
      debugPrint('✅ Shake detected, total shakes: ${shakeTimes.length}');

      shakeTimes = shakeTimes.where((t) {
        return now.difference(t).inSeconds <= 4;
      }).toList();

      if (shakeTimes.length >= 3) {
        debugPrint('🚨 SHAKE PATTERN DETECTED! Triggering SOS');
        try {
          await onShakeDetected?.call();
        } catch (e, st) {
          debugPrint('❌ onShakeDetected error: $e');
          debugPrint('$st');
        }
        shakeTimes.clear();
      }
    });
    debugPrint('✅ Sensor subscription started');
  }

  void stop() {
    debugPrint('🔍 ShakeService.stop() called');
    sensorSub?.cancel();
    sensorSub = null;
    shakeTimes.clear();
    debugPrint('✅ Sensor subscription stopped');
  }
}
