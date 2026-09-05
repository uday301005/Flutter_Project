import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const ToggleSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 ToggleSwitch.build() - value=$value');
    return SwitchListTile(
      title: const Text("SOS Active"),
      subtitle: Text(value ? "ON" : "OFF"),
      value: value,
      onChanged: (newValue) {
        debugPrint('🔄 Toggle changed to: $newValue');
        onChanged(newValue);
      },
    );
  }
}
