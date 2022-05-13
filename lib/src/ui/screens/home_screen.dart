import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_cre/src/services/services.dart';

class HomeScreen extends StatefulWidget {
  int currentPage;

  HomeScreen({Key? key, required this.currentPage}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _paginaActual;
  int countNotifications = 0;
  final List<Widget> _pages = [
    NotificationScreen(),
    DashboardScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    _paginaActual = widget.currentPage;
    super.initState();
    NotificationsService().countNotificationsToRead().then((value) {
      setState(() {
        countNotifications = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final notificationBloc = Provider.of<NotificationBloc>(context, listen: false);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0XFFF7F7F7),
            endDrawer: SafeArea(child: endDrawer(authService, context)),
            appBar: appBar(context, false),
            body: _pages[_paginaActual],
            bottomNavigationBar: ChangeNotifierProvider(
                create: (_) => NotificationBloc(),
                child: SafeArea(child: bottomAppBar(notificationBloc)))));
  }



  Widget bottomAppBar(provider) {
    final notificationBloc = Provider.of<NotificationBloc>(context, listen: false);
    return Container(
      color: const Color(0XFF3A3D5F),
      height: 120,
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
          height: 90,
          child: ConvexAppBar.badge(
              {0: notificationBloc.notificationsToRead > 0 ? notificationBloc.notificationsToRead.toString() : ""},
              badgeMargin: const EdgeInsets.only(left: 20, bottom: 20),
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
              ], onTap: (index) {
            setState(() {
              // accountBloc.reloadAccounts();
              _paginaActual = index;
            });
          }),
        )
      ]),
    );
  }
}
