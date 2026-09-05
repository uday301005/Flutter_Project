class AppwriteConfig {
  const AppwriteConfig({
    required this.endpoint,
    required this.projectId,
    required this.databaseId,
    required this.collectionIds,
    required this.bucketIds,
  });

  factory AppwriteConfig.fromEnvironment() {
    return AppwriteConfig(
      endpoint: const String.fromEnvironment('APPWRITE_ENDPOINT'),
      projectId: const String.fromEnvironment('APPWRITE_PROJECT_ID'),
      databaseId: const String.fromEnvironment('APPWRITE_DATABASE_ID'),
      collectionIds: {
        'users': const String.fromEnvironment('APPWRITE_USERS_COLLECTION_ID'),
        'wasteReports': const String.fromEnvironment(
          'APPWRITE_WASTE_REPORTS_COLLECTION_ID',
        ),
        'pickupRequests': const String.fromEnvironment(
          'APPWRITE_PICKUP_REQUESTS_COLLECTION_ID',
        ),
        'wasteClassifications': const String.fromEnvironment(
          'APPWRITE_WASTE_CLASSIFICATIONS_COLLECTION_ID',
        ),
        'wasteBins': const String.fromEnvironment(
          'APPWRITE_WASTE_BINS_COLLECTION_ID',
        ),
        'collectionCenters': const String.fromEnvironment(
          'APPWRITE_COLLECTION_CENTERS_COLLECTION_ID',
        ),
        'notifications': const String.fromEnvironment(
          'APPWRITE_NOTIFICATIONS_COLLECTION_ID',
        ),
        'trackingEvents': const String.fromEnvironment(
          'APPWRITE_TRACKING_EVENTS_COLLECTION_ID',
        ),
        'complaints': const String.fromEnvironment(
          'APPWRITE_COMPLAINTS_COLLECTION_ID',
        ),
      },
      bucketIds: {
        'reportImages': const String.fromEnvironment(
          'APPWRITE_REPORT_IMAGES_BUCKET_ID',
        ),
        'profileImages': const String.fromEnvironment(
          'APPWRITE_PROFILE_IMAGES_BUCKET_ID',
        ),
        'aiImages': const String.fromEnvironment(
          'APPWRITE_AI_IMAGES_BUCKET_ID',
        ),
      },
    );
  }

  final String endpoint;
  final String projectId;
  final String databaseId;
  final Map<String, String> collectionIds;
  final Map<String, String> bucketIds;

  bool get isConfigured =>
      endpoint.trim().isNotEmpty &&
      projectId.trim().isNotEmpty &&
      databaseId.trim().isNotEmpty;
}
