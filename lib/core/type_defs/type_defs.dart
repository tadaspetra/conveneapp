import 'package:conveneapp/core/errors/errors.dart';
import 'package:dartz/dartz.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

/// - `Unit` used infavor of `void`
typedef FutureEitherVoid = FutureEither<void>;
