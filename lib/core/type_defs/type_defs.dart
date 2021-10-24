import 'package:conveneapp/core/errors/errors.dart';
import 'package:dartz/dartz.dart';

typedef CtfEither<T> = Future<Either<Failure, T>>;

/// - `Unit` used infavor of `void`
typedef CtfUnit = CtfEither<Unit>;
