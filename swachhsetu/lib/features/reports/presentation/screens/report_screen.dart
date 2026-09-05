import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/waste_report.dart';
import '../controllers/report_controller.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  XFile? _image;
  WasteReportCategory? _category;
  WasteReportSeverity? _severity;
  bool _picking = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    setState(() => _picking = true);
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );
      if (mounted) setState(() => _image = image);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final shouldSubmit = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => _ReportReviewSheet(
        image: _image,
        description: _description.text.trim(),
        category: _category!,
        severity: _severity!,
      ),
    );
    if (shouldSubmit != true || !mounted) return;
    final result = await ref
        .read(reportControllerProvider.notifier)
        .submit(
          description: _description.text,
          category: _category,
          severity: _severity,
          imagePath: _image?.path,
        );
    if (!mounted) return;
    if (result case Success(value: final report)) {
      context.push('/report-success/${report.id.substring(1)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(reportControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Report Waste')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                'Help improve your neighbourhood',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Share a sanitation issue and help the right team respond.',
              ),
              const SizedBox(height: AppSpacing.lg),
              _ImagePickerPanel(
                image: _image,
                picking: _picking,
                onCamera: () => _pick(ImageSource.camera),
                onGallery: () => _pick(ImageSource.gallery),
                onClear: () => setState(() => _image = null),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _description,
                maxLength: 500,
                maxLines: 5,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Describe the issue'
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What needs attention?',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<WasteReportCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: WasteReportCategory.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
                validator: (value) =>
                    value == null ? 'Choose a category' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<WasteReportSeverity>(
                initialValue: _severity,
                decoration: const InputDecoration(labelText: 'Severity'),
                items: WasteReportSeverity.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _severity = value),
                validator: (value) => value == null ? 'Choose severity' : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                color: AppColors.surfaceTint,
                child: const ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('Location unavailable'),
                  subtitle: Text(
                    'You can add location when permission is available.',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Review and Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportReviewSheet extends StatelessWidget {
  const _ReportReviewSheet({
    required this.image,
    required this.description,
    required this.category,
    required this.severity,
  });

  final XFile? image;
  final String description;
  final WasteReportCategory category;
  final WasteReportSeverity severity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Review your report',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(description, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppSpacing.sm),
            Text('${category.label}  •  ${severity.label}'),
            const SizedBox(height: AppSpacing.md),
            Text(image == null ? 'Photo unavailable' : 'Photo attached'),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Submit Report'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Edit Report'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePickerPanel extends StatelessWidget {
  const _ImagePickerPanel({
    required this.image,
    required this.picking,
    required this.onCamera,
    required this.onGallery,
    required this.onClear,
  });

  final XFile? image;
  final bool picking;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (picking) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (image != null) {
      return Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(image!.path),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.refresh),
              label: const Text('Change image'),
            ),
          ],
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.add_a_photo_outlined, size: 42),
            const SizedBox(height: AppSpacing.sm),
            const Text('Add a photo of the issue'),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onCamera,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Camera'),
                ),
                OutlinedButton.icon(
                  onPressed: onGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
