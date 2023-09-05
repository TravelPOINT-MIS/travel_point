import 'package:dartz/dartz.dart';
import 'package:travel_point/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultFutureVoid = Future<Either<Failure, void>>;

typedef DataMap = Map<String, dynamic>;
