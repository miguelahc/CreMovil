// import 'dart:html';

import 'package:flutter/material.dart';

class ValidatecodBackground extends StatelessWidget {
  const ValidatecodBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration = const BoxDecoration(
        gradient: LinearGradient(
            stops: [0.8, 0.4],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2B5C5A),
              Color(0xFF3A3D5F),
            ]));
    return Stack(
      children: [
        Container(
          decoration: boxDecoration,
        ),
        //Caja Media
        _CajaMedia(),
        //Caja superior
        _CajaSuperior(),
        //Título
        _Title(),
        //Titulo del pie
        _FooterTitle(),
      ],
    );
  }
}

class _CajaSuperior extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          gradient: LinearGradient(colors: [
            Color(0xFF3A3D5F),
            Color(0xFF2B5C5A),
          ])),
    );
  }
}

class _CajaMedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            gradient: LinearGradient(colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
            ])),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              // width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Verificación",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF84BD00)),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Ingrese el pin enviado",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "vía SMS a su teléfono",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        ));
    //   margin: EdgeInsets.symmetric(
    //       horizontal: MediaQuery.of(context).size.height * 0.15),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       SizedBox(height: 40),
    //       Text(
    //         'Ingreso',
    //         style: TextStyle(
    //             fontSize: 24,
    //             fontWeight: FontWeight.bold,
    //             color: Color(0xFF84BD00)),
    //         textAlign: TextAlign.center,
    //       ),
    //       SizedBox(height: 20),
    //       Text(
    //         'Digite su nombre y número de teléfono para continuar',
    //         style: TextStyle(fontSize: 14, color: Colors.white),
    //         textAlign: TextAlign.center,
    //       ),
    //     ],
    //   ),
    // ),
  }
}

class _FooterTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.90),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.live_help_outlined, color: Color(0xFF84BD00)),
                Text('   '),
                Text(
                  '¿No puedes ingresar o registrarte?',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('   '),
                Text('   '),
                Text(
                  'Consulta la información de Ayuda',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ));
  }
}
