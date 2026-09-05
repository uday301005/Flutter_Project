import '../../../core/network/result.dart';
import '../domain/home_summary.dart';
import 'home_repository.dart';

class DemoHomeRepository implements HomeRepository {
  const DemoHomeRepository();

  @override
  Future<Result<HomeSummary>> getSummary() async {
    return const Success(
      HomeSummary(
        activeRequests: [
          HomeRequest(
            kind: RequestKind.report,
            id: '#WS-1024',
            status: RequestStatus.inProgress,
            createdLabel: 'Today, 9:42 AM',
            location: 'Sector 14 community lane',
          ),
          HomeRequest(
            kind: RequestKind.pickup,
            id: '#PK-2041',
            status: RequestStatus.assigned,
            createdLabel: 'Yesterday, 4:10 PM',
            location: 'Green Park apartment road',
          ),
        ],
        nearbyFacilities: [
          NearbyFacility(
            name: 'Dry Waste Collection Center',
            distance: '350 m away',
            type: 'Dry waste',
          ),
          NearbyFacility(
            name: 'Community Waste Bin',
            distance: '500 m away',
            type: 'Mixed waste',
          ),
          NearbyFacility(
            name: 'Recycling Center',
            distance: '1.2 km away',
            type: 'Recyclables',
          ),
        ],
        awareness: AwarenessContent(
          title: 'Small actions make a big difference.',
          message: 'Separate wet and dry waste before disposal.',
        ),
      ),
    );
  }
}
