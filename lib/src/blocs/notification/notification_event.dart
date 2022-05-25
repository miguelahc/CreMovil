part of 'notification_bloc.dart';


abstract class NotificationEvent extends Equatable{

  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class OnGetAllCategoryNotification extends NotificationEvent {
  final Map<Category, int> categories;
  const OnGetAllCategoryNotification(this.categories);
}

class OnResetAllCategoryNotification extends NotificationEvent {
  const OnResetAllCategoryNotification();
}

class OnGetAllNotifications extends NotificationEvent {
  final Map<int, List<dynamic>> notifications;
  const OnGetAllNotifications(this.notifications);
}

class OnUpdateNotificationsCounter extends NotificationEvent {
  final int notificationCounter;
  const OnUpdateNotificationsCounter(this.notificationCounter);
}