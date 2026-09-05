sealed class AppFailure implements Exception {
  const AppFailure(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => message;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, {super.code, super.cause});
}

final class AuthFailure extends AppFailure {
  const AuthFailure(super.message, {super.code, super.cause});
}

final class SessionExpiredFailure extends AppFailure {
  const SessionExpiredFailure(super.message, {super.code, super.cause});
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, {super.code, super.cause});
}

final class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {super.code, super.cause});
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message, {super.code, super.cause});
}
