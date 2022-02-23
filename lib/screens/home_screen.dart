import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/widgets/widgets.dart';
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
            endDrawer: SafeArea(child: endDrawer(authService, context)),
            appBar: appBar(context, false),
            body: _paginas[_paginaActual],
            bottomNavigationBar: bottomAppBar()));
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
                  icon: const ImageIcon(
                    AssetImage('assets/icons/vuesax-linear-notification.png'),
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
                            child: const ImageIcon(
                              AssetImage(
                                  'assets/icons/vuesax-linear-notification.png'),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                ),
                TabItem(
                  icon: const ImageIcon(
                    AssetImage('assets/icons/vuesax-linear-home-2.png'),
                    color: Colors.white,
                  ),
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
                            child: const ImageIcon(
                              AssetImage(
                                  'assets/icons/vuesax-linear-home-2.png'),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                ),
                TabItem(
                  icon: const ImageIcon(
                    AssetImage('assets/icons/vuesax-linear-profileMENU.png'),
                    color: Colors.white,
                  ),
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
                            child: const ImageIcon(
                              AssetImage(
                                  'assets/icons/vuesax-linear-profileMENU.png'),
                              color: Colors.white,
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
