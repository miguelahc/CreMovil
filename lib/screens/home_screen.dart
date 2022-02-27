import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_cre/services/services.dart';

class HomeScreen extends StatefulWidget {
  int currentPage;
  HomeScreen({Key? key, required this.currentPage}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _paginaActual;
  final List<Widget> _paginas = [
    NotificationScreen(),
    DashboardScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    _paginaActual = widget.currentPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0XFFF7F7F7),
            endDrawer: SafeArea(child: endDrawer(authService, context)),
            appBar: appBar(context, false),
            body: _paginas[_paginaActual],
            bottomNavigationBar: SafeArea( child: bottomAppBar())),
    );
  }

  Widget bottomAppBar() {
    return Container(
      color: const Color(0XFF3A3D5F),
      height: 110,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          height: 80,
          child: ConvexAppBar(
            elevation: 0,
              height: 60,
              top: 0,
              activeColor: const Color(0XFF84BD00),
              backgroundColor: const Color(0XFF3A3D5F),
              color: Colors.white,
              initialActiveIndex: _paginaActual,
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
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
