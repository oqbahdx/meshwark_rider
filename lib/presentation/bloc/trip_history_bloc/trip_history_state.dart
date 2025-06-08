part of 'trip_history_cubit.dart';

@immutable
abstract class TripHistoryState {}

class TripHistoryInitial extends TripHistoryState {}
class TripHistoryLoadingState extends TripHistoryState {}
class TripHistorySuccessState extends TripHistoryState {}
class TripHistoryErrorState extends TripHistoryState {
  final String error;
  TripHistoryErrorState(this.error);
}
