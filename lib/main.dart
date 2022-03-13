import 'package:app_cre/models/models.dart';
import 'package:app_cre/providers/conection_status.dart';
import 'package:app_cre/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:app_cre/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:app_cre/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.inizializeApp();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ConnectionStatus()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    //Contexto para envío de push notification
    PushNotificationService.messagesStream.listen((message) {
      //redirecciona a una pantalla de la app
      navigatorKey.currentState?.pushNamed('messange', arguments: message);
      //Envía un mensaje tipo snackBar en la app
      print('Menú princial app: ' + message);
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reto Api',
      initialRoute: 'home',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      routes: {
        'splash': (_) => Splash(),
        'checking': (_) => const CheckAuthScreen(),
        'bienvenida': (_) => IntroSliderPage(
              slides: const [],
            ),
        'login': (_) => const LoginScreen(),
        'validar': (_) => ValidateCodScreen(
              user: User("", "", ""),
            ),
        'register': (_) => const RegisterAccountScreen(),
        'home': (_) => HomeScreen(
              currentPage: 1,
            ),
        'messange': (_) => HomeScreen(currentPage: 0),
      },
      // scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
