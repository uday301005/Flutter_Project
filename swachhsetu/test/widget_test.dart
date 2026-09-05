// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:swachhsetu/core/network/result.dart';
import 'package:swachhsetu/core/errors/failures.dart';
import 'package:swachhsetu/features/auth/domain/auth_repository.dart';
import 'package:swachhsetu/features/auth/domain/user_model.dart';
import 'package:swachhsetu/features/auth/presentation/controllers/auth_controller.dart';
import 'package:swachhsetu/features/onboarding/data/onboarding_storage.dart';
import 'package:swachhsetu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:swachhsetu/main.dart';

class FakeOnboardingStorage implements OnboardingStorage {
  FakeOnboardingStorage({this.completed = false});

  final bool completed;

  @override
  Future<bool> hasCompletedOnboarding() async => completed;

  @override
  Future<void> markCompleted() async {}
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<UserModel?>> currentUser() async => const Success(null);

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    return const FailureResult(AuthFailure('not used in routing tests'));
  }

  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return const FailureResult(AuthFailure('not used in routing tests'));
  }

  @override
  Future<Result<void>> requestPasswordReset(String email) async =>
      const Success(null);

  @override
  Future<Result<void>> logout() async => const Success(null);
}

Widget testApp([OnboardingStorage? storage]) {
  return ProviderScope(
    overrides: [
      onboardingStorageProvider.overrideWith(
        (ref) async => storage ?? FakeOnboardingStorage(),
      ),
      authRepositoryProvider.overrideWith((ref) async => FakeAuthRepository()),
    ],
    child: const MyApp(),
  );
}

void main() {
  testWidgets('splash renders while startup state resolves', (tester) async {
    await tester.pumpWidget(testApp());

    expect(find.text('SwachhSetu'), findsOneWidget);
    expect(find.text('Smarter Waste. Cleaner Communities.'), findsOneWidget);
  });

  testWidgets('onboarding displays its first page', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pump();

    expect(find.text('Sort Waste Smarter'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('skip completes onboarding and opens auth placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    await tester.pump();

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('get started on the final page opens auth placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    await tester.pump();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Build a Cleaner Community'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('completed onboarding routes returning users to auth', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(FakeOnboardingStorage(completed: true)));
    await tester.pump();
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sort Waste Smarter'), findsNothing);
  });
}
