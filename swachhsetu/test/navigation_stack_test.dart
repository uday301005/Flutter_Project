import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:swachhsetu/core/network/result.dart';
import 'package:swachhsetu/core/theme/app_theme.dart';
import 'package:swachhsetu/features/auth/domain/auth_repository.dart';
import 'package:swachhsetu/features/auth/domain/user_model.dart';
import 'package:swachhsetu/features/auth/presentation/controllers/auth_controller.dart';
import 'package:swachhsetu/features/home/domain/home_summary.dart';
import 'package:swachhsetu/features/home/presentation/controllers/home_controller.dart';
import 'package:swachhsetu/features/home/presentation/screens/home_screen.dart';
import 'package:swachhsetu/features/reports/presentation/screens/report_screen.dart';

class _AuthenticatedRepository implements AuthRepository {
  @override
  Future<Result<UserModel?>> currentUser() async => const Success(
    UserModel(
      id: 'user-1',
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

HomeSummary _summary() => const HomeSummary(
  activeRequests: [],
  nearbyFacilities: [],
  awareness: AwarenessContent(
    title: 'Keep it clean',
    message: 'Separate waste before disposal.',
  ),
);

void main() {
  testWidgets('home report navigation preserves the route for system back', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/report',
          builder: (context, state) => const ReportScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWith(
            (ref) async => _AuthenticatedRepository(),
          ),
          homeSummaryProvider.overrideWith((ref) async => _summary()),
          homeLocationProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp.router(
          theme: SwachhSetuTheme.light,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Report Waste').first);
    await tester.pumpAndSettle();
    expect(find.text('Help improve your neighbourhood'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Good day, Asha Citizen'), findsOneWidget);
  });
}
