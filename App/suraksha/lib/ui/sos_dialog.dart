import 'package:flutter/material.dart';
import 'dart:async';

/// Shows the SOS confirmation dialog and returns `true` when the user
/// confirms (or countdown auto-sends), `false` when cancelled, or `null`
/// if the dialog was dismissed.
Future<bool?> showSOSDialog(BuildContext context) async {
  debugPrint('🔍 showSOSDialog() called');

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _SOSDialogContent(),
  );
}

class _SOSDialogContent extends StatefulWidget {
  const _SOSDialogContent();

  @override
  State<_SOSDialogContent> createState() => _SOSDialogContentState();
}

class _SOSDialogContentState extends State<_SOSDialogContent> {
  int countdown = 8;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    debugPrint('🔍 _SOSDialogContent.initState()');
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => countdown--);
      debugPrint('⏱️ Countdown: $countdown seconds');

      if (countdown <= 0) {
        debugPrint('🆕 Countdown finished, sending SOS automatically');
        t.cancel();
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    debugPrint('🔍 _SOSDialogContent.dispose() - cancelling timer');
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🚨 SOS Alert'),
      content: Text('Sending in $countdown sec'),
      actions: [
        TextButton(
          onPressed: () {
            debugPrint('🔄 User cancelled SOS');
            timer?.cancel();
            Navigator.of(context).pop(false);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            debugPrint('🔥 User confirmed SOS immediately');
            timer?.cancel();
            Navigator.of(context).pop(true);
          },
          child: const Text('SEND NOW'),
        ),
      ],
    );
  }
}
