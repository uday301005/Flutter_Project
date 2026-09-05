import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/result.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/pickup_request.dart';
import '../controllers/pickup_controller.dart';

class PickupScreen extends ConsumerStatefulWidget {
  const PickupScreen({super.key});
  @override
  ConsumerState<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends ConsumerState<PickupScreen> {
  final _form = GlobalKey<FormState>();
  final _address = TextEditingController();
  PickupWasteType? _type;
  PickupQuantity? _quantity;
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false) ||
        _date == null ||
        _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete all fields including date and time'),
        ),
      );
      return;
    }
    final result = await ref
        .read(pickupControllerProvider.notifier)
        .submit(
          wasteType: _type,
          quantity: _quantity,
          address: _address.text,
          date: _date,
          time: _time!.format(context),
        );
    if (mounted && result is Success<PickupRequest>) {
      context.push('/pickup-success/${result.value.id.substring(3)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(pickupControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Request Pickup')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Schedule a collection',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<PickupWasteType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Waste Type'),
              items: PickupWasteType.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                  .toList(),
              onChanged: (v) => setState(() => _type = v),
              validator: (v) => v == null ? 'Choose waste type' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<PickupQuantity>(
              initialValue: _quantity,
              decoration: const InputDecoration(labelText: 'Quantity'),
              items: PickupQuantity.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                  .toList(),
              onChanged: (v) => setState(() => _quantity = v),
              validator: (v) => v == null ? 'Choose quantity' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter pickup address' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Location unavailable'),
              subtitle: Text(
                'Location can be added when permission is available.',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final value = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        initialDate: DateTime.now(),
                      );
                      if (value != null) setState(() => _date = value);
                    },
                    child: Text(
                      _date == null
                          ? 'Choose date'
                          : '${_date!.day}/${_date!.month}',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final value = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (value != null) setState(() => _time = value);
                    },
                    child: Text(
                      _time == null ? 'Choose time' : _time!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: loading ? null : _submit,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Review and Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
