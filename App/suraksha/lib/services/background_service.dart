import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class BackgroundService {

  static Future<void> initialize() async {

    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  static void onStart(ServiceInstance service) {

    StreamSubscription<Position>? subscription;

    subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    ).listen((position) {
      print(
        "📍 BG Location: "
            "${position.latitude}, ${position.longitude}",
      );

    });

    service.on("stop").listen((event) async {

      await subscription?.cancel();

      service.stopSelf();
    });
  }
}