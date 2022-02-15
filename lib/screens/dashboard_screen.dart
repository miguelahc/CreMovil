import 'dart:convert';

import 'package:app_cre/services/services.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/screens_background.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(
          children: [
            _CajaSuperiorDatos(),
          ],
        ));
  }
}

class _CajaSuperiorDatos extends StatefulWidget {
  _CajaSuperiorDatos({Key? key}) : super(key: key);

  @override
  State<_CajaSuperiorDatos> createState() => __CajaSuperiorDatosState();
}

class __CajaSuperiorDatosState extends State<_CajaSuperiorDatos> {
  String name = "";

  @override
  void initState() {
    super.initState();
    UserService().readUserData().then((data) {
      var userData = jsonDecode(data);
      setState(() {
        name = userData["Name"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.96,
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.elliptical(20, 10)),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 13,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 10,
                  backgroundImage: AssetImage('assets/foto.png'),
                ),
              )),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Hola, $name",
                            style: const TextStyle(
                                color: Color(0xFF3A3D5F),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF Pro Display')),
                        Container(
                            width: 24,
                            height: 24,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              color: const Color(0xFF84BD00),
                              iconSize: 24,
                              icon: const Icon(Icons.edit_note_outlined),
                              onPressed: () {},
                            ))
                      ],
                    ),
                    const Text("miguel.cre@gmail.com",
                        style: TextStyle(
                            color: Color(0xFFA39F9F),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro Display'))
                  ],
                ),
              ),
              const sabiasQue(),
            ],
          ),
        ),
      ),
    );
  }
}

class sabiasQue extends StatelessWidget {
  const sabiasQue({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.22,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(20, 10)),
          color: Color(0XFFF7F7F7),
        ),
        child: Column(
          children: [
            IconButton(
              color: const Color(0xFF84BD00),
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: () {},
            ),
            const Text(
              " ¿Sabías que?",
              style: TextStyle(color: Color(0xFF3A3D5F), fontSize: 12),
            )
          ],
        ));
  }
}
