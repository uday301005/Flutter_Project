import 'package:flutter_test/flutter_test.dart';
import 'package:swachhsetu/core/network/result.dart';
import 'package:swachhsetu/features/reports/data/demo_waste_report_repository.dart';
import 'package:swachhsetu/features/reports/domain/waste_report.dart';

void main() {
  late DemoWasteReportRepository repository;
  setUp(() => repository = DemoWasteReportRepository());

  WasteReport report({
    String description = 'Overflowing bin near the park',
    String? imagePath = 'local-image.jpg',
  }) => WasteReport(
    id: '',
    userId: 'citizen-1',
    description: description,
    category: WasteReportCategory.overflowingDustbin,
    imagePath: imagePath,
    severity: WasteReportSeverity.high,
    status: WasteReportStatus.submitted,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  test('report metadata exposes all supported categories and statuses', () {
    expect(
      WasteReportCategory.values.map((value) => value.label),
      contains('Illegal Dumping'),
    );
    expect(
      WasteReportSeverity.values.map((value) => value.label),
      contains('Critical'),
    );
    expect(WasteReportStatus.submitted.label, 'Submitted');
  });

  test(
    'demo submission creates an owned submitted report with unique id',
    () async {
      final result = await repository.submit(report());
      final saved = result as Success<WasteReport>;
      expect(saved.value.id, startsWith('#WS-'));
      expect(saved.value.userId, 'citizen-1');
      expect(saved.value.status, WasteReportStatus.submitted);
      expect(
        (await repository.getMyReports('citizen-1') as Success).value,
        hasLength(1),
      );
      expect(
        (await repository.getMyReports('other-user') as Success).value,
        isEmpty,
      );
    },
  );

  test('empty description is rejected', () async {
    final result = await repository.submit(report(description: ' '));
    expect(result, isA<FailureResult>());
  });

  test('missing image is rejected', () async {
    final result = await repository.submit(report(imagePath: null));
    expect(result, isA<FailureResult>());
  });
}
