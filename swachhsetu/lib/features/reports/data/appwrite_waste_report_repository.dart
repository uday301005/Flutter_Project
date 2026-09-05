// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../../../core/errors/failures.dart';
import '../../../core/network/result.dart';
import '../../../services/appwrite/appwrite_error_mapper.dart';
import '../../../services/appwrite/appwrite_service.dart';
import '../domain/waste_report.dart';
import '../domain/waste_report_repository.dart';

class AppwriteWasteReportRepository implements WasteReportRepository {
  AppwriteWasteReportRepository(this._service);
  final AppwriteService _service;

  @override
  Future<Result<WasteReport>> submit(WasteReport report) async {
    try {
      final databases = _service.databases;
      final collectionId = _service.config.collectionIds['wasteReports'];
      if (databases == null || collectionId == null || collectionId.isEmpty)
        return const FailureResult(
          UnknownFailure('Report collection is not configured.'),
        );
      var imageFileId = report.imagePath;
      final bucketId = _service.config.bucketIds['reportImages'];
      if (_service.storage != null &&
          bucketId != null &&
          bucketId.isNotEmpty &&
          report.imagePath != null) {
        final file = await _service.storage!.createFile(
          fileId: ID.unique(),
          bucketId: bucketId,
          file: InputFile.fromPath(path: report.imagePath!),
        );
        imageFileId = file.$id;
      }
      final document = await databases.createDocument(
        databaseId: _service.config.databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: _data(report, imageFileId),
      );
      return Success(_fromDocument(document));
    } catch (error) {
      return FailureResult(AppwriteErrorMapper.map(error));
    }
  }

  @override
  Future<Result<List<WasteReport>>> getMyReports(String userId) async {
    try {
      final databases = _service.databases;
      final collectionId = _service.config.collectionIds['wasteReports'];
      if (databases == null || collectionId == null || collectionId.isEmpty)
        return const FailureResult(
          UnknownFailure('Report collection is not configured.'),
        );
      final result = await databases.listDocuments(
        databaseId: _service.config.databaseId,
        collectionId: collectionId,
        queries: [Query.equal('userId', userId), Query.orderDesc('createdAt')],
      );
      return Success(result.documents.map(_fromDocument).toList());
    } catch (error) {
      return FailureResult(AppwriteErrorMapper.map(error));
    }
  }

  Map<String, Object?> _data(WasteReport report, String? imageFileId) => {
    'reportId': report.id,
    'userId': report.userId,
    'imageFileId': imageFileId,
    'description': report.description,
    'category': report.category.name,
    'severity': report.severity.name,
    'latitude': report.latitude,
    'longitude': report.longitude,
    'address': report.address,
    'status': report.status.name,
    'createdAt': report.createdAt.toIso8601String(),
    'updatedAt': report.updatedAt.toIso8601String(),
  };
  WasteReport _fromDocument(models.Document document) {
    final data = document.data;
    return WasteReport(
      id: data['reportId'] as String? ?? document.$id,
      userId: data['userId'] as String? ?? '',
      imagePath: data['imageFileId'] as String?,
      description: data['description'] as String? ?? '',
      category: WasteReportCategory.values.byName(
        data['category'] as String? ?? 'other',
      ),
      severity: WasteReportSeverity.values.byName(
        data['severity'] as String? ?? 'medium',
      ),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      address: data['address'] as String?,
      status: WasteReportStatus.values.byName(
        data['status'] as String? ?? 'submitted',
      ),
      createdAt:
          DateTime.tryParse(data['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(data['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
