import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiService {
  // When true, don't POST to the server; print the payload to console instead.
  // Toggle this during development when you want the request logged locally.
  static bool get sendToConsoleOnly => AppConfig.sendToConsoleOnly;

  static String get serverUrl => AppConfig.serverUrl;

  static Future<void> sendSOS(double lat, double lon) async {
    final payload = {"user_id": "user123", "latitude": lat, "longitude": lon};

    if (sendToConsoleOnly) {
      debugPrint('📤 [ApiService] (console-only) SOS payload: $payload');
      return;
    }
    final uri = Uri.parse(serverUrl);
    debugPrint('📤 [ApiService] sending POST to $serverUrl');
    debugPrint('📤 [ApiService] payload: $payload');

    // Quick TCP check to see if the device can reach the host:port.
    try {
      debugPrint('🔎 [ApiService] testing TCP to ${uri.host}:${uri.port}');
      final socket = await Socket.connect(
        uri.host,
        uri.port,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      debugPrint('🔌 [ApiService] TCP connection OK');
    } catch (e, st) {
      debugPrint('❌ [ApiService] TCP connect failed: $e');
      debugPrint('$st');
      throw Exception('Cannot connect to server ${uri.host}:${uri.port} — $e');
    }

    try {
      final response = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'SOS server responded with ${response.statusCode}: ${response.body}',
        );
      }
      debugPrint("✅ [ApiService] Server response: ${response.body}");
    } catch (e, st) {
      debugPrint('❌ [ApiService] HTTP request failed: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
