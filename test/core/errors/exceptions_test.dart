import 'package:conveneapp/core/errors/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BaseException getException([String? message]) {
    return AuthException(message ?? 'error');
  }

  test('should return [exception.message.hashocde ^ exception.classType.hashcode] when [exception.hashcode] is called',
      () {
    BaseException exception = getException();
    expect(exception.hashCode, equals(exception.message.hashCode ^ exception.classType.hashCode));
  });

  test('should return [true] when two instances of [exception] are equal', () {
    final exceptionMain = getException();
    final exceptionSecondary = getException();

    expect(exceptionMain == exceptionSecondary, equals(true));
  });

  test('should return [false] when two instances of [exception] are not equal', () {
    final exceptionMain = getException();
    final exceptionSecondary = getException('unknown');

    expect(exceptionMain == exceptionSecondary, equals(false));
  });

  test('should return [AuthException Error | error] when [toString] is called', () {
    const expectedValue = 'AuthException Error | error';
    final exception = getException();
    expect(exception.toString(), equals(expectedValue));
  });
}
