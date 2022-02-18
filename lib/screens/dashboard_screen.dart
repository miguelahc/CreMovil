import 'dart:convert';

import 'package:app_cre/models/models.dart';
import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/FactoryData.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(
          children: [
            _CajaSuperiorDatos(),
            Row(
              children: [
                const SizedBox(width: 270),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    disabledColor: Colors.black87,
                    elevation: 0,
                    color: const Color(0xFF618A02),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: const Text(
                        "Registrar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {}),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: const Text("Códigos Fijos",
                  style: TextStyle(
                      color: Color(0XFF3A3D5F), fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: FactoryData.servicios.length,
                itemBuilder: (BuildContext context, int index) =>
                    item(FactoryData.servicios[index]),
              ),
            )
          ],
        ));
  }
}

Widget item(Servicios servicio) {
  return Slidable(
    key: const ValueKey(0),
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () {}),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          onPressed: (ex) {
            print(ex);
          },
          backgroundColor: Color.fromARGB(255, 216, 216, 3),
          foregroundColor: Colors.white,
          icon: Icons.payments_outlined,
          label: 'Pagar',
        ),
        SlidableAction(
          // An action can be bigger than the others.
          onPressed: (ex) {
            FactoryData.servicios
                .removeWhere((element) => element.id == servicio.id);
          },
          backgroundColor: const Color(0xFF618A02),
          foregroundColor: Colors.white,
          icon: Icons.edit_note,
          label: 'Editar',
        ),
        SlidableAction(
          onPressed: (ex) {
            FactoryData.servicios
                .removeWhere((element) => element.id == servicio.id);
          },
          backgroundColor: Color.fromARGB(255, 138, 43, 2),
          foregroundColor: Colors.white,
          icon: Icons.restore_from_trash_outlined,
          label: 'Eliminar',
        ),
      ],
    ),
    child: ListTile(
      leading: CachedNetworkImage(
        imageUrl: servicio.photo,
        imageBuilder: (context, imageProvider) => Container(
          width: 20,
          height: 25,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: new AlwaysStoppedAnimation<Color>(
            Color(0xFF3A3D5F),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      title: Text(servicio.name),
      subtitle: Text(servicio.email),
      onTap: () {},
    ),
  );
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
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
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
                            icon: const Icon(Icons.edit_note_outlined),
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
