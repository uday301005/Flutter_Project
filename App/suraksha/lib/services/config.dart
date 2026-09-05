

class AppConfig {
  // Set to true when running on the Android emulator (uses 10.0.2.2).
  // Set to false when running on a real device (use your PC LAN IP).
  static bool useEmulator = false;

  // If false, the app will skip sending to the local HTTP backend.
  // This is useful when testing on a real device and the local server is not reachable.
  static const bool sendToServerBackend = false;

  // Update these URLs as needed for your development environment.
  static const String serverUrlDevice = 'http://192.168.1.5:8080/sos';
  static const String serverUrlEmulator = 'http://10.0.2.2:8080/sos';

  static String get serverUrl =>
      useEmulator ? serverUrlEmulator : serverUrlDevice;

  static bool get sendToConsoleOnly => !sendToServerBackend;
}
