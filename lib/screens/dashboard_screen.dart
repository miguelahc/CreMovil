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
            Stack(
              children: [
                const ScreensBackground(),
                _CajaSuperiorDatos(),
                // ListaCodigofijo(),
              ],
            ),
          ],
        ));
  }
}

class _CajaSuperiorDatos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.96,
        height: 90,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(20, 10)),
            gradient: LinearGradient(colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
            ])),
        child: Container(
          child: Row(
            children: [
              const Text("  "),
              Positioned(
                  top: 5,
                  left: MediaQuery.of(context).size.width + 10,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 13,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 10,
                      backgroundImage: AssetImage('assets/foto.png'),
                    ),
                  )),
              Row(
                children: [
                  Column(
                    children: [
                      Text(""),
                      Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            const Text("Hola, Álvaro Polo",
                                style: TextStyle(
                                    color: Color(0xFF3A3D5F),
                                    fontSize: 20,
                                    fontFamily: 'SF Pro Display')),
                            IconButton(
                              color: const Color(0xFF84BD00),
                              icon: const Icon(Icons.edit_note_outlined),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                      Container(
                        // alignment: Alignment.bottomLeft,
                        child: Row(
                          children: const [
                            Text("miguel.cre@gmail.com",
                                style: TextStyle(
                                    color: Color(0xFF3A3D5F),
                                    fontSize: 12,
                                    fontFamily: 'SF Pro Display')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const sabiasQue(),
                ],
              ),
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
    return Column(
      children: [
        Text(""),
        Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.24,
                  height: 70,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.elliptical(20, 10)),
                      gradient: LinearGradient(colors: [
                        Color(0xFFF1F1F1),
                        Color(0xFFF1F1F1),
                      ])),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          color: const Color(0xFF84BD00),
                          icon: new Icon(Icons.batch_prediction_sharp,
                              size: 30.0),
                          onPressed: () {},
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          " ¿Sabías que?",
                          style: TextStyle(color: Color(0xFF84BD00)),
                        )
                      ],
                    )
                  ],
                )
              ],
            )),
      ],
    );
  }
}
