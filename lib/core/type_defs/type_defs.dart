import 'package:conveneapp/core/errors/errors.dart';
import 'package:dartz/dartz.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;
typedef StreamList<T> = Stream<List<T>>;
