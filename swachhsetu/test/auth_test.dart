import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:swachhsetu/core/network/result.dart';
import 'package:swachhsetu/features/auth/data/demo_auth_repository.dart';
import 'package:swachhsetu/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  late DemoAuthRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = DemoAuthRepository(await SharedPreferences.getInstance());
  });

  test('demo login accepts documented demo credentials', () async {
    final result = await repository.login(
      email: DemoAuthRepository.demoEmail,
      password: DemoAuthRepository.demoPassword,
    );

    expect(result, isA<Success>());
    expect((result as Success).value.email, DemoAuthRepository.demoEmail);
  });

  test('invalid demo login returns an auth failure', () async {
    final result = await repository.login(
      email: 'wrong@example.com',
      password: 'wrong',
    );

    expect(result, isA<FailureResult>());
    expect(
      (result as FailureResult).failure.message,
      contains('Invalid demo credentials'),
    );
  });

  test(
    'registration authenticates a local demo user without storing password',
    () async {
      final result = await repository.register(
        name: 'Asha Citizen',
        email: 'asha@example.com',
        phone: '9876543210',
        password: 'Secret123',
      );
      final preferences = await SharedPreferences.getInstance();

      expect(result, isA<Success>());
      expect((result as Success).value.name, 'Asha Citizen');
      expect(
        preferences.getKeys().any(
          (key) => key.toLowerCase().contains('password'),
        ),
        isFalse,
      );
      expect((await repository.currentUser() as Success).value, isNotNull);
    },
  );

  test('forgot password succeeds in demo mode without sending email', () async {
    final result = await repository.requestPasswordReset('citizen@example.com');

    expect(result, isA<Success>());
  });

  test('logout clears the persisted demo session', () async {
    await repository.login(
      email: DemoAuthRepository.demoEmail,
      password: DemoAuthRepository.demoPassword,
    );
    await repository.logout();

    expect((await repository.currentUser() as Success).value, isNull);
  });

  test(
    'auth controller exposes authenticated and unauthenticated states',
    () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) async => repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authControllerProvider.future);
      expect(
        container.read(authControllerProvider).value?.status,
        AuthStatus.unauthenticated,
      );

      await container
          .read(authControllerProvider.notifier)
          .login(
            email: DemoAuthRepository.demoEmail,
            password: DemoAuthRepository.demoPassword,
          );
      expect(
        container.read(authControllerProvider).value?.status,
        AuthStatus.authenticated,
      );
    },
  );
}
