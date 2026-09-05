import '../../../core/network/result.dart';
import '../domain/home_summary.dart';

abstract interface class HomeRepository {
  Future<Result<HomeSummary>> getSummary();
}
