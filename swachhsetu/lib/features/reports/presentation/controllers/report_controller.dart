import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_providers.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/result.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/demo_waste_report_repository.dart';
import '../../data/appwrite_waste_report_repository.dart';
import '../../domain/waste_report.dart';
import '../../domain/waste_report_repository.dart';

final wasteReportRepositoryProvider = Provider<WasteReportRepository>(
  (ref) => ref.watch(appConfigProvider).demoMode
      ? DemoWasteReportRepository()
      : AppwriteWasteReportRepository(ref.watch(appwriteServiceProvider)),
);
final reportControllerProvider =
    AsyncNotifierProvider<ReportController, WasteReport?>(ReportController.new);

class ReportController extends AsyncNotifier<WasteReport?> {
  @override
  Future<WasteReport?> build() async => null;

  Future<Result<WasteReport>> submit({
    required String description,
    required WasteReportCategory? category,
    required WasteReportSeverity? severity,
    String? imagePath,
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    final userId =
        ref.read(authControllerProvider).value?.user?.id ?? 'demo-user';
    if (imagePath == null || imagePath.trim().isEmpty) {
      return const FailureResult(
        ValidationFailure('Please add a photo of the issue.'),
      );
    }
    if (description.trim().isEmpty) {
      return const FailureResult(
        ValidationFailure('Please describe the problem.'),
      );
    }
    if (category == null) {
      return const FailureResult(
        ValidationFailure('Please choose a waste category.'),
      );
    }
    if (severity == null) {
      return const FailureResult(
        ValidationFailure('Please choose a severity.'),
      );
    }
    state = const AsyncLoading();
    final now = DateTime.now();
    final result = await ref
        .read(wasteReportRepositoryProvider)
        .submit(
          WasteReport(
            id: '',
            userId: userId,
            imagePath: imagePath,
            description: description,
            category: category,
            severity: severity,
            latitude: latitude,
            longitude: longitude,
            address: address,
            status: WasteReportStatus.submitted,
            createdAt: now,
            updatedAt: now,
          ),
        );
    state = switch (result) {
      Success(value: final report) => AsyncData(report),
      FailureResult(failure: final failure) => AsyncError(
        failure,
        StackTrace.current,
      ),
    };
    return result;
  }
}
