import '../../../core/network/result.dart';
import 'waste_report.dart';

abstract interface class WasteReportRepository {
  Future<Result<WasteReport>> submit(WasteReport report);
  Future<Result<List<WasteReport>>> getMyReports(String userId);
}
