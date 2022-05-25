part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final Map<Category, int> categories;
  final Map<int, List<dynamic>> notifications;
  final int notificationCounter;

  const NotificationState(
      {this.categories = const {},
      this.notifications = const {},
      this.notificationCounter = 0});

  NotificationState copyWith(
          {Map<Category, int>? categories,
          Map<int, List<dynamic>>? notifications,
          int? notificationCounter}) =>
      NotificationState(
          categories: categories ?? this.categories,
          notifications: notifications ?? this.notifications,
          notificationCounter: notificationCounter ?? this.notificationCounter);

  @override
  List<Object?> get props => [categories, notifications, notificationCounter];
}
