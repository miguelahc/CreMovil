import 'package:app_cre/screens/dashboard_screen.dart';
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
        drawer: menuLateral(authService, context),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.green),
          // title: Text("Prueba1"),
          backgroundColor: const Color(0xFFF1F1F1),
        ),
        body: _paginas[_paginaActual],
        bottomNavigationBar: ConvexAppBar(
            backgroundColor: Color(0XFF3A3D5F),
            color: Color(0xFF84BD00),
            initialActiveIndex: 1,
            items: const [
              TabItem(
                  icon:
                      Icon(Icons.notifications_none, color: Color(0xFF84BD00)),
                  title: "Notificaciones"),
              TabItem(
                  icon: Icon(Icons.home_rounded, color: Color(0xFF84BD00)),
                  title: "Inicio"),
              TabItem(
                  icon: Icon(Icons.person_outline, color: Color(0xFF84BD00)),
                  title: "Mi Perfil")
            ],
            onTap: (index) {
              setState(() {
                _paginaActual = index;
              });
            }),
      ),
    );
  }

  Drawer menuLateral(AuthService authService, BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xF003A3D5F)),
              child: Text(
                'Menú de Opciones',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF84BD00), fontSize: 16),
              )),
          const ListTile(
            leading: Icon(Icons.room_outlined, color: Color(0xFF3A3D5F)),
            title: Text(
              'Puntos de atención y pago',
              style: TextStyle(color: Color(0xFF3A3D5F), fontSize: 12),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.task_alt, color: Color(0xFF3A3D5F)),
            title: Text(
              'Requisitos de servicio',
              style: TextStyle(color: Color(0xFF3A3D5F), fontSize: 12),
            ),
          ),
          const ListTile(
            leading:
                Icon(Icons.perm_device_info_outlined, color: Color(0xFF3A3D5F)),
            title: Text(
              'Información de ayuda y soporte',
              style: TextStyle(color: Color(0xFF3A3D5F), fontSize: 12),
            ),
          ),
          ListTile(
            leading: IconButton(
              color: Color(0xFF3A3D5F),
              icon: const Icon(Icons.login_outlined),
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
            title: const Text(
              'Salir',
              style: TextStyle(color: Color(0xFF3A3D5F), fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
