import 'package:equatable/equatable.dart';

enum WasteReportCategory {
  garbageDump,
  overflowingDustbin,
  uncollectedWaste,
  plasticWaste,
  openWaste,
  sewageProblem,
  dirtyPublicArea,
  illegalDumping,
  other,
}

enum WasteReportSeverity { low, medium, high, critical }

enum WasteReportStatus {
  submitted,
  underReview,
  assigned,
  inProgress,
  resolved,
  rejected,
  closed,
}

extension WasteReportCategoryLabel on WasteReportCategory {
  String get label => switch (this) {
    WasteReportCategory.garbageDump => 'Garbage Dump',
    WasteReportCategory.overflowingDustbin => 'Overflowing Dustbin',
    WasteReportCategory.uncollectedWaste => 'Uncollected Waste',
    WasteReportCategory.plasticWaste => 'Plastic Waste',
    WasteReportCategory.openWaste => 'Open Waste',
    WasteReportCategory.sewageProblem => 'Sewage Problem',
    WasteReportCategory.dirtyPublicArea => 'Dirty Public Area',
    WasteReportCategory.illegalDumping => 'Illegal Dumping',
    WasteReportCategory.other => 'Other',
  };
}

extension WasteReportSeverityLabel on WasteReportSeverity {
  String get label => switch (this) {
    WasteReportSeverity.low => 'Low',
    WasteReportSeverity.medium => 'Medium',
    WasteReportSeverity.high => 'High',
    WasteReportSeverity.critical => 'Critical',
  };
}

extension WasteReportStatusLabel on WasteReportStatus {
  String get label => switch (this) {
    WasteReportStatus.submitted => 'Submitted',
    WasteReportStatus.underReview => 'Under Review',
    WasteReportStatus.assigned => 'Assigned',
    WasteReportStatus.inProgress => 'In Progress',
    WasteReportStatus.resolved => 'Resolved',
    WasteReportStatus.rejected => 'Rejected',
    WasteReportStatus.closed => 'Closed',
  };
}

class WasteReport extends Equatable {
  const WasteReport({
    required this.id,
    required this.userId,
    this.imagePath,
    required this.description,
    required this.category,
    required this.severity,
    this.latitude,
    this.longitude,
    this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String userId;
  final String? imagePath;
  final String description;
  final WasteReportCategory category;
  final WasteReportSeverity severity;
  final double? latitude;
  final double? longitude;
  final String? address;
  final WasteReportStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  @override
  List<Object?> get props => [
    id,
    userId,
    imagePath,
    description,
    category,
    severity,
    latitude,
    longitude,
    address,
    status,
    createdAt,
    updatedAt,
  ];
}
