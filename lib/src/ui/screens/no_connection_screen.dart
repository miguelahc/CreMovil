import 'dart:io';

import 'package:app_cre/src/ui/screens/check_auth_screen.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:app_cre/src/ui/widgets/circular_progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatefulWidget{

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {

  bool reconnectIntent = false;

  reconnect() async{
    setState(() {
      reconnectIntent = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 3));
      final result = await InternetAddress.lookup('creapp.cre.com.bo');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _checkAuth();
      } else {
        setState(() {
          reconnectIntent = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        reconnectIntent = false;
      });
    }
  }

  _checkAuth(){
    TokenService().generateToken();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const CheckAuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DarkGradientAlpha
        ),
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 225,
          decoration: const BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 32, bottom: 24),
                child: Text("¡Problemas de conexión!"),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 64, right: 64, bottom: 24),
                child: Text("Por favor revisa tu\nServicio de Internet y\nvuelve a intentar", textAlign: TextAlign.center,),
              ),
              MaterialButton(
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  disabledColor: Colors.black87,
                  elevation: 0,
                  onPressed: reconnect,
                  child: Container(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                        maxHeight: 50),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: PrimaryGradient,
                    ),
                    child: reconnectIntent
                        ? circularProgress()
                        :const Text(
                            'Reintentar',
                            style: TextStyle( fontFamily: 'Mulish', color: Colors.white, fontSize: 16),
                          ),
                  ),
                  )

            ],
          ),
        ),
      ),
    );
  }
}