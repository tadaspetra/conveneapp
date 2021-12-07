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

  group('BookFailure', () {
    test('''
    should return [Seems like you don't have to correct permissions. Permission Denied]
    when exception code is [permission_denied]
    ''', () {
      final BookFailure failure = BookFailure.fromCode('permission_denied');

      expect(failure.message, equals("Seems like you don't have to correct permissions. Permission Denied"));
    });
  });
}
