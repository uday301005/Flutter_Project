import '../../../core/network/result.dart';
import 'user_model.dart';

abstract interface class AuthRepository {
  Future<Result<UserModel?>> currentUser();

  Future<Result<UserModel>> login({
    required String email,
    required String password,
  });

  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<Result<void>> requestPasswordReset(String email);

  Future<Result<void>> logout();
}
