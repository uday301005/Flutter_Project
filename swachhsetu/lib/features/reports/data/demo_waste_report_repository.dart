import 'package:uuid/uuid.dart';

import '../../../core/errors/failures.dart';
import '../../../core/network/result.dart';
import '../domain/waste_report.dart';
import '../domain/waste_report_repository.dart';

class DemoWasteReportRepository implements WasteReportRepository {
  final List<WasteReport> _reports = [];

  @override
  Future<Result<WasteReport>> submit(WasteReport report) async {
    if (report.description.trim().isEmpty) {
      return const FailureResult(ValidationFailure('Description is required.'));
    }
    if (report.imagePath == null || report.imagePath!.trim().isEmpty) {
      return const FailureResult(
        ValidationFailure('A report photo is required.'),
      );
    }
    final saved = WasteReport(
      id: report.id.isEmpty
          ? '#WS-${const Uuid().v4().substring(0, 8).toUpperCase()}'
          : report.id,
      userId: report.userId,
      imagePath: report.imagePath,
      description: report.description.trim(),
      category: report.category,
      severity: report.severity,
      latitude: report.latitude,
      longitude: report.longitude,
      address: report.address,
      status: WasteReportStatus.submitted,
      createdAt: report.createdAt,
      updatedAt: DateTime.now(),
    );
    _reports.add(saved);
    return Success(saved);
  }

  @override
  Future<Result<List<WasteReport>>> getMyReports(String userId) async =>
      Success(
        List.unmodifiable(_reports.where((report) => report.userId == userId)),
      );
}
