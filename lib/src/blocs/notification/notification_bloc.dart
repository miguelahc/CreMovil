import 'dart:async';
import 'dart:convert';

import 'package:app_cre/src/models/category.dart';
import 'package:app_cre/src/services/notifications_service.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<OnGetAllCategoryNotification>(
      (event, emit) => emit(state.copyWith(categories: event.categories)),
    );
    on<OnGetAllNotifications>(
      (event, emit) => emit(state.copyWith(notifications: event.notifications)),
    );
    on<OnUpdateNotificationsCounter>(
      (event, emit) =>
          emit(state.copyWith(notificationCounter: event.notificationCounter)),
    );
    on<OnResetAllCategoryNotification>(
          (event, emit) => emit(state.copyWith(categories: const {})),
    );
  }

  Future getNotifications() async {
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    _getCategories(token, userData);
  }

  Future reloadNotifications() async{
    add(const OnResetAllCategoryNotification());
    getNotifications();
  }

  Future _getCategories(token, userData) async {
    var categoriesData =
        await NotificationsService().getCategories(token, userData);
    var code = jsonDecode(categoriesData)["Code"];
    if (code == 0) {
      var msg = jsonDecode(categoriesData)["Message"];
      List<Category> categoriesList =
          NotificationsService().parseToListCategories(jsonDecode(msg)).toList();
      Map<Category, int> categories = {};
      categoriesList.forEach((category) {
        categories.addAll({category: 0});
      });

      _getNotifications(token, userData, categories);
      // add(OnGetAllCategoryNotification(categories));
    }
  }

  Future _getNotifications(token, userData, Map<Category, int> categories) async{
    var notificationData = await NotificationsService()
        .getNotifications(token, userData);
    var code = jsonDecode(notificationData)["Code"];
    if(code == 0){
      var msg = jsonDecode(notificationData)["Message"];
      List<dynamic> notificationsList = jsonDecode(msg);
      Map<int, List<dynamic>> notifications = {};
      notificationsList.forEach((notification) {
        int key = notification["nucate"];
        if (!notifications.containsKey(key)) {
          List<dynamic> listTemp = List.empty(growable: true);
          listTemp.add(notification);
          notifications.addAll({notification["nucate"] as int: listTemp});
        } else {
          List? listTemp = notifications[notification["nucate"]];
          if (listTemp != null) {
            listTemp.add(notification);
            notifications.addAll({notification["nucate"] as int: listTemp});
          }
        }
      });
      int counterNotifications = 0;
      add(OnGetAllNotifications(notifications));
      notifications.forEach((key, value) {
        categories.forEach((category, categoryValue) {
          if(category.numberCategory == key){
            int noRead = _countNotificationNoRead(value);
            categories.update(category, (value) => noRead);
            counterNotifications += noRead;
          }
        });
      });
      add(OnGetAllCategoryNotification(categories));
      add(OnUpdateNotificationsCounter(counterNotifications));
    }
  }

  int _countNotificationNoRead(List notifications){
    List result = notifications.where((element) => element["leido"]=="NO").toList();
    return result.length;
  }

}
