// sh1    9F:37:86:3C:BC:24:93:D8:93:90:0B:49:99:5B:17:F4:B7:D1:B5:09
import 'dart:async';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  // ignore: pre  fer_final_fields
  static StreamController<String> _messageStream = StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // _messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message.data['mensaje'] ?? 'No data');
    print(message.data);
    print('Back Ground Handler ${message.messageId}');
  }

  static Future _onMessangeHandler(RemoteMessage message) async {
    // _messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message.data['mensaje'] ?? 'No data');
    print(message.data);
    print('_onMessangeHandlerr ${message.messageId}');
  }

  static Future _onMessangeOpenApp(RemoteMessage message) async {
    // _messageStream.add(message.notification?.body ?? 'No title');
    _messageStream.add(message.data['mensaje'] ?? 'No data');
    print(message.data);
    print('_onMessangeOpenApp ${message.messageId}');
  }

  static Future inizializeApp() async {
    //Push Notification inicializó para recibir notificaicones
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);
    storage.write(key: "PhonePushId", value: token);
    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessangeHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessangeOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }

  Future<String> readPhonePushId() async {
    return await storage.read(key: "PhonePushId") ?? "";
  }
}
