part of 'select_service_cubit.dart';

@immutable
abstract class SelectServiceState {}

class SelectServiceInitial extends SelectServiceState {}
class GetUserLoadingState extends SelectServiceState {}
class GetUserSuccessState extends SelectServiceState {}
class GetUserErrorState extends SelectServiceState {
  final String error;

  GetUserErrorState(this.error);
}
