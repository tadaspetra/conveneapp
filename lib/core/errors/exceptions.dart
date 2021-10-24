// - BaseClass for all custom exceptions
/// HACK: Print the line number from the stack trace, if logging is implemented
///
/// {@template base_exception}
/// - Implements BaseException
/// {@endtemplate}
abstract class BaseException implements Exception {
  final String message;
  final String className;

  BaseException({required this.message, required this.className});
  @override
  String toString() {
    return '$className Error | $message';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseException && other.message == message && other.className == className;
  }

  @override
  int get hashCode => message.hashCode ^ className.hashCode;
}

/// **AuthException**
///
/// Contains Exception Related to `AuthApi`
/// {@macro base_exception}
class AuthException extends BaseException {
  AuthException(String message) : super(className: 'AuthException', message: message);
}
