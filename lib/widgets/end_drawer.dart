import 'package:app_cre/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget endDrawer(AuthService authService, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.85,
    child: Drawer(
      backgroundColor: const Color(0xFFF7F7F7),
      child: ListView(
        padding: EdgeInsets.zero,
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
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListTile(
                leading: const ImageIcon(
                  AssetImage('assets/icons/vuesax-linear-location.png'),
                  color: Color(0XFF3A3D5F),
                ),
                title: Row(
                  children: const [
                    Text(
                      'Puntos de atención y pago',
                      style: TextStyle(
                          color: Color(0xFF3A3D5F),
                          fontSize: 14,
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                )),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListTile(
                leading: const ImageIcon(
                  AssetImage('assets/icons/vuesax-linear-verify.png'),
                  color: Color(0XFF3A3D5F),
                ),
                title: Row(
                  children: const [
                    Text(
                      'Requisitos de servicio',
                      style: TextStyle(
                          color: Color(0xFF3A3D5F),
                          fontSize: 14,
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                )),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListTile(
                leading: const ImageIcon(
                  AssetImage('assets/icons/vuesax-linear-info-circle.png'),
                  color: Color(0XFF3A3D5F),
                ),
                title: Row(
                  children: const [
                    Text(
                      'Información de ayuda y soporte',
                      style: TextStyle(
                          color: Color(0xFF3A3D5F),
                          fontSize: 14,
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                )),
          ),
          Container(
              margin:
                  const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                  leading: const ImageIcon(
                    AssetImage('assets/icons/vuesax-linear-logout.png'),
                    color: Color(0XFF3A3D5F),
                  ),
                  onTap: () {
                    authService.logout();
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  title: Row(
                    children: const [
                      Text(
                        'Salir',
                        style: TextStyle(
                            color: Color(0xFF3A3D5F),
                            fontSize: 14,
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ))),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
    ),
  );
}
