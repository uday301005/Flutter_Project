abstract interface class LocationService {
  Future<String?> currentLocationLabel();
}

class DemoLocationService implements LocationService {
  const DemoLocationService();

  @override
  Future<String?> currentLocationLabel() async => null;
}
