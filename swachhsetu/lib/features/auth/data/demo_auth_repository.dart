import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/failures.dart';
import '../../../core/network/result.dart';
import '../domain/auth_repository.dart';
import '../domain/user_model.dart';

class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository(this._preferences);

  static const demoEmail = 'demo@swachhsetu.app';
  static const demoPassword = 'Demo@123';
  static const _sessionKey = 'demo_auth_session';
  static const _nameKey = 'demo_auth_name';
  static const _phoneKey = 'demo_auth_phone';
  static const _emailKey = 'demo_auth_email';
  static const _idKey = 'demo_auth_id';

  final SharedPreferences _preferences;

  @override
  Future<Result<UserModel?>> currentUser() async {
    if (_preferences.getBool(_sessionKey) != true) {
      return const Success(null);
    }
    return Success(_storedUser());
  }

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().toLowerCase() != demoEmail || password != demoPassword) {
      return const FailureResult(
        AuthFailure('Invalid demo credentials. Use the Demo Mode details.'),
      );
    }
    final user = _storedUser(
      fallbackEmail: demoEmail,
      fallbackName: 'Demo Citizen',
      fallbackPhone: '0000000000',
    );
    await _saveSession(user);
    return Success(user);
  }

  @override
  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final user = UserModel(
      id: const Uuid().v4(),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.trim(),
    );
    await _saveSession(user);
    return Success(user);
  }

  @override
  Future<Result<void>> requestPasswordReset(String email) async {
    return const Success(null);
  }

  @override
  Future<Result<void>> logout() async {
    await _preferences.remove(_sessionKey);
    return const Success(null);
  }

  UserModel _storedUser({
    String? fallbackEmail,
    String? fallbackName,
    String? fallbackPhone,
  }) {
    return UserModel(
      id: _preferences.getString(_idKey) ?? const Uuid().v4(),
      name: _preferences.getString(_nameKey) ?? fallbackName ?? 'Citizen',
      email: _preferences.getString(_emailKey) ?? fallbackEmail ?? demoEmail,
      phone: _preferences.getString(_phoneKey) ?? fallbackPhone ?? '',
    );
  }

  Future<void> _saveSession(UserModel user) async {
    await Future.wait([
      _preferences.setBool(_sessionKey, true),
      _preferences.setString(_idKey, user.id),
      _preferences.setString(_nameKey, user.name),
      _preferences.setString(_emailKey, user.email),
      _preferences.setString(_phoneKey, user.phone),
    ]);
  }
}
