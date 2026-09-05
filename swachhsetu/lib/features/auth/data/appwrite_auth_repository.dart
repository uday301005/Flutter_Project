import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

import '../../../core/errors/failures.dart';
import '../../../core/network/result.dart';
import '../../../services/appwrite/appwrite_error_mapper.dart';
import '../../../services/appwrite/appwrite_service.dart';
import '../domain/auth_repository.dart';
import '../domain/user_model.dart';

class AppwriteAuthRepository implements AuthRepository {
  AppwriteAuthRepository(this._service);

  final AppwriteService _service;

  Account get _account {
    final account = _service.account;
    if (account == null) {
      throw const UnknownFailure('Appwrite authentication is not configured.');
    }
    return account;
  }

  @override
  Future<Result<UserModel?>> currentUser() async {
    try {
      final user = await _account.get();
      return Success(_fromAppwriteUser(user));
    } on AppwriteException catch (error) {
      if (error.code == 401) return const Success(null);
      return FailureResult(AppwriteErrorMapper.map(error));
    } catch (error) {
      return FailureResult(AppwriteErrorMapper.map(error));
    }
  }

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final result = await currentUser();
      return switch (result) {
        Success(value: final user?) => Success(user),
        Success() => const FailureResult(
          AuthFailure('Unable to load your account.'),
        ),
        FailureResult(failure: final failure) => FailureResult(failure),
      };
    } catch (error) {
      return FailureResult(AppwriteErrorMapper.map(error));
    }
  }

  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return Success(
        UserModel(id: user.$id, name: name, email: email, phone: phone),
      );
    } catch (error) {
      return FailureResult(AppwriteErrorMapper.map(error));
    }
  }

  @override
  Future<Result<void>> requestPasswordReset(String email) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'https://swachhsetu.app/recovery',
      );
      return const Success(null);
    } catch (error) {
      return FailureResult(AppwriteErrorMapper.map(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return const Success(null);
    } catch (error) {
      return FailureResult(AppwriteErrorMapper.map(error));
    }
  }

  UserModel _fromAppwriteUser(models.User user) {
    return UserModel(
      id: user.$id,
      name: user.name,
      email: user.email,
      phone: user.phone,
    );
  }
}
