import 'package:flutter/material.dart';

class StatusView extends StatelessWidget {
  final bool isProcessing;
  final bool isSOSActive;
  final int cooldownLeftSeconds;

  const StatusView({
    super.key,
    required this.isProcessing,
    required this.isSOSActive,
    this.cooldownLeftSeconds = 0,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '🔍 StatusView.build() - isProcessing=$isProcessing, isSOSActive=$isSOSActive',
    );
    if (isProcessing) {
      debugPrint('📈 Showing loading indicator');
      return const Center(child: CircularProgressIndicator());
    }

    String statusText;
    if (!isSOSActive) {
      statusText = 'SOS is OFF';
    } else if (cooldownLeftSeconds > 0) {
      statusText = 'Waiting — ${_formatTime(cooldownLeftSeconds)}';
    } else {
      statusText = 'Ready — Shake to Send SOS';
    }

    debugPrint('✅ Showing status: $statusText');
    return Center(
      child: Text(statusText, style: const TextStyle(fontSize: 22)),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
