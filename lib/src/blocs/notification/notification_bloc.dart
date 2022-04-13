import 'dart:async';
import 'dart:io';

import 'package:app_cre/src/services/notifications_service.dart';
import 'package:flutter/cupertino.dart';

class NotificationBloc extends ChangeNotifier{
  int _notificationsToRead = -1;

  NotificationBloc() {
    _checkInternetConnection();
  }

  int get notificationsToRead => _notificationsToRead;

  Future<void> _checkInternetConnection() async {
    try {
      var count = await NotificationsService().countNotificationsToRead();
      _notificationsToRead = count;
    } on SocketException catch (_) {
      _notificationsToRead = -1;
    }
    notifyListeners();
  }

  void increment(){
    _notificationsToRead++;
    notifyListeners();
  }

}
