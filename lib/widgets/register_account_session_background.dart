// import 'dart:html';

import 'package:app_cre/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class RegisterAccountSessionBackground extends StatelessWidget {
  const RegisterAccountSessionBackground({Key? key}) : super(key: key);

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
        //Caja Media
        _CajaMedia(),
        //Caja superior
        _CajaSuperior(),
        //Título
        _Title(),

        _Leading(),
        //Titulo del pie
        _FooterTitle(),
      ],
    );
  }
}

class _Leading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            }));
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
              Color(0xFFF7F7F7),
              Color(0xFFF7F7F7),
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
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Registro",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF84BD00)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Text(
                "Ingresa los datos solicitados",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              Text(
                "para registrar tu Código Fijo o Servicio",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }
}

class _FooterTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ImageIcon(
                AssetImage('assets/icons/vuesax-linear-message-question.png'),
                color: Color(0xFF84BD00),
              ),
              const SizedBox(width: 10),
              Column(
                children: const [
                  Text(
                    '¿No puedes registrarte?',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0XFF3A3D5F),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Consulta la información de Ayuda',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0XFF3A3D5F),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
