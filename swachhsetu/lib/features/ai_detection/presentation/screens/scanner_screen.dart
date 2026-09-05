import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_state.dart';
import '../../domain/waste_classification.dart';
import '../controllers/scanner_controller.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  XFile? _image;

  Future<void> _pick(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (!mounted) return;
    setState(() => _image = image);
    ref.read(scannerControllerProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(scannerControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Waste')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _ScannerImage(
              image: _image,
              onCamera: () => _pick(ImageSource.camera),
              onGallery: () => _pick(ImageSource.gallery),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_image != null)
              FilledButton.icon(
                onPressed: result.isLoading
                    ? null
                    : () => ref
                          .read(scannerControllerProvider.notifier)
                          .analyze(_image!.path),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Analyze'),
              ),
            const SizedBox(height: AppSpacing.lg),
            result.when(
              data: (data) => data == null
                  ? const SizedBox.shrink()
                  : _ClassificationResult(result: data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  const ErrorState(message: 'We could not analyze this image.'),
            ),
            if (_image != null && result.hasValue)
              TextButton(
                onPressed: () {
                  setState(() => _image = null);
                  ref.read(scannerControllerProvider.notifier).reset();
                },
                child: const Text('Scan another image'),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScannerImage extends StatelessWidget {
  const _ScannerImage({
    required this.image,
    required this.onCamera,
    required this.onGallery,
  });

  final XFile? image;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(File(image!.path), height: 260, fit: BoxFit.cover),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Icon(
              Icons.document_scanner_outlined,
              size: 56,
              color: AppColors.secondary,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Choose an image to identify its waste type'),
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

class _ClassificationResult extends StatelessWidget {
  const _ClassificationResult({required this.result});
  final WasteClassificationResult result;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceTint,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.science_outlined, color: AppColors.primary),
                SizedBox(width: AppSpacing.sm),
                Text('Demo Prediction'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              result.category.label,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: result.confidence, minHeight: 8),
            const SizedBox(height: AppSpacing.sm),
            Text('${(result.confidence * 100).round()}% confidence'),
            const SizedBox(height: AppSpacing.md),
            Text(result.recommendation),
          ],
        ),
      ),
    );
  }
}
