part of 'notifications_cubit.dart';

@immutable
sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

class LoadingNotificationsState extends NotificationsState {}

class SuccessNotificationsState extends NotificationsState {
  final List<NotificationModel> notifications;
  SuccessNotificationsState(this.notifications);
}

class ErrorNotificationsState extends NotificationsState {
  final String message;
  ErrorNotificationsState({this.message = 'Failed to load notifications'});
}
