import 'package:flutter/material.dart';
import 'package:app_cre/screens/login_screen1.dart';
import 'package:provider/provider.dart';

import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reto Api',
      initialRoute: 'bienvenida',
      routes: {
        'checking': (_) => const CheckAuthScreen(),
        'validar': (_) => ValidatecodScreen(),
        'home': (_) => const HomeScreen(),
        'login': (_) => const LoginScreen1(),
        'bienvenida': (_) => IntroSliderPage(
              slides: const [],
            ),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
