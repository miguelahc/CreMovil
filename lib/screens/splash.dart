import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    TokenService().generateToken();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const CheckAuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: boxDecoration(),
          ),
          Container(
            alignment: const Alignment(0.03, 0.03),
            padding: const EdgeInsets.all(20),
            child: const Image(
              image: AssetImage('assets/splash.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
            // stops: [0.8, 0.4],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
          Color(0xFF2B5C5A),
          Color(0xFF3A3D5F),
        ]));
  }
}
