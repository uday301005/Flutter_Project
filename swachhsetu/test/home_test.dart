import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:swachhsetu/core/theme/app_theme.dart';
import 'package:swachhsetu/core/network/result.dart';
import 'package:swachhsetu/features/auth/domain/auth_repository.dart';
import 'package:swachhsetu/features/auth/domain/user_model.dart';
import 'package:swachhsetu/features/auth/presentation/controllers/auth_controller.dart';
import 'package:swachhsetu/features/home/data/home_repository.dart';
import 'package:swachhsetu/features/home/domain/home_summary.dart';
import 'package:swachhsetu/features/home/presentation/controllers/home_controller.dart';
import 'package:swachhsetu/features/home/presentation/screens/home_screen.dart';

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository(this.summary);

  final HomeSummary summary;

  @override
  Future<Result<HomeSummary>> getSummary() async => Success(summary);
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<UserModel?>> currentUser() async => const Success(
    UserModel(
      id: '1',
      name: 'Asha Citizen',
      email: 'asha@example.com',
      phone: '9876543210',
    ),
  );

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<Result<void>> requestPasswordReset(String email) async =>
      const Success(null);

  @override
  Future<Result<void>> logout() async => const Success(null);
}

HomeSummary summary({List<HomeRequest> requests = const []}) {
  return HomeSummary(
    activeRequests: requests,
    nearbyFacilities: const [
      NearbyFacility(
        name: 'Community Waste Bin',
        distance: '500 m away',
        type: 'Mixed waste',
      ),
    ],
    awareness: const AwarenessContent(
      title: 'Small actions make a big difference.',
      message: 'Separate wet and dry waste before disposal.',
    ),
  );
}

Widget dashboard(HomeSummary data) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWith((ref) async => FakeAuthRepository()),
      homeRepositoryProvider.overrideWithValue(FakeHomeRepository(data)),
      homeLocationProvider.overrideWith((ref) async => null),
    ],
    child: MaterialApp(theme: SwachhSetuTheme.light, home: const HomeScreen()),
  );
}

void main() {
  testWidgets('home renders authenticated user and dashboard sections', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      dashboard(
        summary(
          requests: const [
            HomeRequest(
              kind: RequestKind.report,
              id: '#WS-1024',
              status: RequestStatus.inProgress,
              createdLabel: 'Today',
              location: 'Sector 14',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Good day, Asha Citizen'), findsOneWidget);
    expect(find.text('Report Waste'), findsOneWidget);
    expect(find.text('Scan Waste'), findsOneWidget);
    expect(find.text('Request Pickup'), findsOneWidget);
    expect(find.text('Nearby Bins'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pump();
    expect(find.textContaining('#WS-1024'), findsOneWidget);
    expect(find.text('Community Waste Bin'), findsOneWidget);
  });

  testWidgets('home shows useful empty state when no requests exist', (
    tester,
  ) async {
    await tester.pumpWidget(dashboard(summary()));
    await tester.pumpAndSettle();

    expect(find.text('No active requests'), findsOneWidget);
    expect(find.text('Report a Problem'), findsOneWidget);
  });
}
