import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/app_providers.dart';
import '../../../../core/network/result.dart';
import '../../data/appwrite_auth_repository.dart';
import '../../data/demo_auth_repository.dart';
import '../../domain/auth_repository.dart';
import '../../domain/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({required this.status, this.user, this.message});

  const AuthState.initial() : this(status: AuthStatus.initial);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final UserModel? user;
  final String? message;

  AuthState error(String message) =>
      AuthState(status: AuthStatus.error, user: user, message: message);
}

final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final preferences = await SharedPreferences.getInstance();
  final config = ref.watch(appConfigProvider);
  if (config.demoMode) return DemoAuthRepository(preferences);
  return AppwriteAuthRepository(ref.watch(appwriteServiceProvider));
});

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthState> {
  AuthRepository? _repository;

  @override
  Future<AuthState> build() async {
    _repository = await ref.watch(authRepositoryProvider.future);
    final result = await _repository!.currentUser();
    return switch (result) {
      Success(value: final user?) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ),
      Success() => const AuthState.unauthenticated(),
      FailureResult(failure: final failure) => AuthState(
        status: AuthStatus.error,
        message: failure.message,
      ),
    };
  }

  Future<void> login({required String email, required String password}) async {
    await _run(
      (repository) => repository.login(email: email, password: password),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _run(
      (repository) => repository.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      ),
    );
  }

  Future<String?> requestPasswordReset(String email) async {
    final result = await _repository!.requestPasswordReset(email);
    return switch (result) {
      Success() => null,
      FailureResult(failure: final failure) => failure.message,
    };
  }

  Future<void> logout() async {
    state = const AsyncData(AuthState.loading());
    final result = await _repository!.logout();
    state = switch (result) {
      Success() => const AsyncData(AuthState.unauthenticated()),
      FailureResult() => const AsyncData(AuthState.unauthenticated()),
    };
  }

  Future<void> _run(
    Future<Result<UserModel>> Function(AuthRepository repository) action,
  ) async {
    state = const AsyncData(AuthState.loading());
    final result = await action(_repository!);
    state = switch (result) {
      Success(value: final user) => AsyncData(
        AuthState(status: AuthStatus.authenticated, user: user),
      ),
      FailureResult(failure: final failure) => AsyncData(
        AuthState(status: AuthStatus.error, message: failure.message),
      ),
    };
  }
}
