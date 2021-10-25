// - BaseClass for all custom exceptions
/// HACK: Print the line number from the stack trace, if logging is implemented
///
/// {@template base_exception}
/// - Implements BaseException
/// {@endtemplate}
abstract class BaseException implements Exception {
  final String message;
  final Type classType;

  BaseException({required this.message, required this.classType});
  @override
  String toString() {
    return '${(classType).toString()} Error | $message';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseException && other.message == message && other.classType == classType;
  }

  @override
  int get hashCode => message.hashCode ^ classType.hashCode;
}

/// **AuthException**
///
/// Contains Exception Related to `AuthApi`
/// {@macro base_exception}
class AuthException extends BaseException {
  AuthException(String message) : super(classType: AuthException, message: message);
}
