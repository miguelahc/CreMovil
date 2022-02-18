import 'dart:convert';

import 'package:app_cre/screens/register_account_session_screen.dart';
import 'package:app_cre/screens/screens.dart';
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
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      disabledColor: Colors.black87,
                      elevation: 0,
                      child: Container(
                          constraints:
                              BoxConstraints(minWidth: 100, maxHeight: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0XFF618A02),
                                Color(0XFF84BD00)
                              ])),
                          child: Row(
                            children: const [
                              ImageIcon(
                                AssetImage(
                                    'assets/icons/vuesax-linear-add-square.png'),
                                color: Colors.white,
                              ),
                              Text(
                                'Registrar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          )),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegisterAccountSession()));
                      })
                ])
              ]),
            ),
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
    return Row(
      // alignment: Alignment.topCenter,
      children: [
        perfilUsuario(context),
      ],
    );
  }

  Container perfilUsuario(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.96,
      height: 100,
      margin: const EdgeInsets.only(left: 8, top: 8),
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
            CircleAvatar(
              radius: MediaQuery.of(context).size.width / 13,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 10,
                backgroundImage: AssetImage('assets/foto.png'),
              ),
            ),
            const SizedBox(width: 16),
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
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            color: const Color(0xFF84BD00),
                            iconSize: 24,
                            icon: const ImageIcon(
                              AssetImage('assets/icons/vuesax-linear-edit.png'),
                              color: Color(0XFF84BD00),
                            ),
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
              icon: const ImageIcon(
                AssetImage('assets/icons/vuesax-linear-lamp-charge.png'),
                color: Color(0XFF84BD00),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountStatusScreen(
                            accountNumber: "35963", companyNumber: "1")));
              },
            ),
            const Text(
              " ¿Sabías que?",
              style: TextStyle(color: Color(0xFF3A3D5F), fontSize: 12),
            )
          ],
        ));
  }
}
