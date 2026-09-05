import '../../core/errors/failures.dart';

abstract final class AppwriteErrorMapper {
  static AppFailure map(Object error) {
    final message = error.toString();
    final normalized = message.toLowerCase();

    if (normalized.contains('401') || normalized.contains('unauthorized')) {
      return AuthFailure('Your session is no longer valid.', cause: error);
    }
    if (normalized.contains('network') || normalized.contains('socket')) {
      return NetworkFailure('Unable to reach the service.', cause: error);
    }
    if (normalized.contains('400') || normalized.contains('invalid')) {
      return ValidationFailure(
        'The request could not be validated.',
        cause: error,
      );
    }
    if (normalized.contains('500') || normalized.contains('server')) {
      return ServerFailure(
        'The service is temporarily unavailable.',
        cause: error,
      );
    }
    return UnknownFailure(
      'Something went wrong. Please try again.',
      cause: error,
    );
  }
}
