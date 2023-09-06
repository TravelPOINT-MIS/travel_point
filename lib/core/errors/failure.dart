import 'package:equatable/equatable.dart';
import 'package:travel_point/core/errors/exception.dart';

abstract class Failure extends Equatable {
  const Failure({required this.errorMessage, required this.errorCode});

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

class ApiFailure extends Failure {
  const ApiFailure({
    required super.errorMessage,
    required super.errorCode,
  });

  ApiFailure.fromApiException(ApiException exception)
      : this(
            errorMessage: exception.errorMessage,
            errorCode: exception.errorCode);
}

class UserInputFailure extends Failure {
  const UserInputFailure({
    required super.errorMessage,
    required super.errorCode,
  });

  UserInputFailure.fromApiException(ApiException exception)
      : this(
            errorMessage: exception.errorMessage,
            errorCode: exception.errorCode);
}
