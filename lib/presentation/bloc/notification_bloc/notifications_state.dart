part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class GetNotificationsLoadingState extends NotificationsState {}

class GetNotificationsSuccessState extends NotificationsState {}

class GetNotificationsErrorState extends NotificationsState {
  final String error;

  GetNotificationsErrorState(this.error);
}
