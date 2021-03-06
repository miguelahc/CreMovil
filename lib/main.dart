import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/blocs/gps/gps_bloc.dart';
import 'package:app_cre/src/blocs/location/location_bloc.dart';
import 'package:app_cre/src/blocs/notification/notification_bloc.dart';
import 'package:app_cre/src/blocs/payment/payment_bloc.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/providers/conection_status.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:app_cre/src/ui/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        BlocProvider(create: (context) => NotificationBloc()),
        BlocProvider(create: (context) => AccountBloc()),
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(
            create: (context) =>
                MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
        BlocProvider(
            create: (context) => SearchBloc(trafficService: TrafficService())),
        BlocProvider(create: (context) => PaymentBloc())
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

    //Contexto para env??o de push notification
    PushNotificationService.messagesStream.listen((message) {
      //redirecciona a una pantalla de la app
      navigatorKey.currentState?.pushNamed('messange', arguments: message);
      //Env??a un mensaje tipo snackBar en la app
      print('Men?? princial app: ' + message);
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reto Api',
      initialRoute: 'splash',
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
              user: User("", "", "", ""),
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
