// - BaseClass for all Failures
/// {@template failure}
/// - Returns `meaningful` messages that can be showed in the `UI`
/// {@endtemplate}
///
abstract class Failure {
  final String message;

  Failure({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// **AuthFailure**
///
/// {@macro failure}
class AuthFailure extends Failure {
  AuthFailure(String message) : super(message: message);
}
