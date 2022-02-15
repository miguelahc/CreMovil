import 'package:app_cre/screens/screens.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_cre/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaActual = 1;
  final List<Widget> _paginas = [
    NotificationScreen(),
    DashboardScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            endDrawer: SafeArea(child: menuLateral(authService, context)),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.green),
              elevation: 0,
              backgroundColor: const Color(0xFFF7F7F7),
            ),
            body: _paginas[_paginaActual],
            bottomNavigationBar: bottomAppBar()));
  }

  Widget menuLateral(AuthService authService, BuildContext context) {
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
                  leading: Icon(Icons.room_outlined, color: Color(0xFF3A3D5F)),
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
                  leading: Icon(Icons.task_alt, color: Color(0xFF3A3D5F)),
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
                  leading: Icon(Icons.info_outline, color: Color(0xFF3A3D5F)),
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
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                    leading: const Icon(Icons.logout, color: Color(0xFF3A3D5F)),
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

  Widget bottomAppBar() {
    return Container(
      color: Color(0XFF3A3D5F),
      height: 120,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0XFFF7F7F7),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 90,
          child: ConvexAppBar(
              height: 70,
              top: 0,
              activeColor: Color(0xFF84BD00),
              backgroundColor: Color(0XFF3A3D5F),
              color: Colors.white,
              initialActiveIndex: 1,
              items: [
                TabItem(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                  title: "Notificaciones",
                  activeIcon: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                color: Color.fromARGB(80, 132, 189, 0)),
                            child: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      )),
                ),
                TabItem(
                  icon: Icon(Icons.home_rounded, color: Colors.white),
                  title: "Inicio",
                  activeIcon: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                color: Color.fromARGB(80, 132, 189, 0)),
                            child: const Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      )),
                ),
                TabItem(
                  icon: Icon(Icons.person_outline, color: Colors.white),
                  title: "Mi Perfil",
                  activeIcon: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                color: Color.fromARGB(80, 132, 189, 0)),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      )),
                )
              ],
              onTap: (index) {
                setState(() {
                  _paginaActual = index;
                });
              }),
        )
      ]),
    );
  }
}
