import 'package:conveneapp/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AuthFailure getFailure() {
    return AuthFailure('error');
  }

  test('should return (authFailure.message.hashcode) when [authFailure.hashcode] is called ', () {
    final Failure failure = getFailure();
    expect(failure.hashCode, equals(failure.message.hashCode));
  });
}
