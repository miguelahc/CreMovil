import 'package:app_cre/screens/service_requirement_screen.dart';
import 'package:app_cre/services/auth_service.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget endDrawer(AuthService authService, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.85,
    child: Drawer(
      backgroundColor: const Color(0xFFF7F7F7),
      child: ListView(
        padding: EdgeInsets.only(left: 16, right: 16),
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(color: Color(0xF003A3D5F)),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset("assets/logo_azul.png",
                      alignment: Alignment.center, width: 60),
                  const SizedBox(height: 20),
                  const Text(
                    'Menú de Opciones',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF84BD00), fontSize: 16),
                  )
                ],
              )),
          itemOption(
              "Puntos de atención y pago", "vuesax-linear-location.png", () {}),
          itemOption("Requisitos de servicio", "vuesax-linear-verify.png", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceRequirementScreen(),
                ));
          }),
          itemOption("Información de ayuda y soporte",
              "vuesax-linear-info-circle.png", () {}),
          itemOption(
              "Sabías que?", "vuesax-linear-lamp-charge-blue.png", () {}),
          itemOption("Salir", "vuesax-linear-logout.png", () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          }),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
    ),
  );
}
