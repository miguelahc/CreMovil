import 'package:flutter/material.dart';

class ScreensBackground extends StatelessWidget {
  const ScreensBackground({Key? key}) : super(key: key);

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
        //Caja superior
        _CajaSuperior(),
        //Caja Media
        _CajaMedia(),
      ],
    );
  }
}

class _CajaSuperior extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            186,
        padding: const EdgeInsets.only(bottom: 80),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF3A3D5F),
          Color(0xFF3A3D5F),
        ])),
      ),
    );
  }
}

class _CajaMedia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 180 - 80,
        padding: const EdgeInsets.only(bottom: 80),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            gradient: LinearGradient(colors: [
              Color(0xFFF1F1F1),
              Color(0xFFF1F1F1),
            ])),
      ),
    );
  }
}
