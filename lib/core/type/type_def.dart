import 'package:dartz/dartz.dart';
import 'package:travel_point/core/errors/failure.dart';

typedef Result<T> = Either<Failure, T>;

typedef ResultFuture<T> = Future<Result<T>>;

typedef ResultFutureVoid = Future<Either<Failure, void>>;

typedef DataMap = Map<String, dynamic>;
