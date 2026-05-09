import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class NoFailure {
  const NoFailure();
}
