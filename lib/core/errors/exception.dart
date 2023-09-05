import 'package:equatable/equatable.dart';

abstract class GeneralException extends Equatable implements Exception {
  const GeneralException({required this.errorMessage, required this.errorCode});

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

class ApiException extends GeneralException {
  const ApiException({required super.errorMessage, required super.errorCode});
}
