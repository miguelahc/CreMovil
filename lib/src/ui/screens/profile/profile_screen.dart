import 'dart:convert';

import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationActive = false;
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    UserService().readUserData().then((data) {
      var userData = jsonDecode(data);
      setState(() {
        name = userData["Name"];
        email = userData["Email"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0XFFF7F7F7),
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.35,
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  decoration: customBoxDecoration(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mi Perfil",
                          style: TextStyle( fontFamily: 'Mulish', 
                              color: SecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: 130,
                          height: 130,
                          alignment: Alignment.center,
                          child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                    height: 124,
                                    width: 124,
                                    child: DottedBorder(
                                      padding: const EdgeInsets.all(4),
                                      borderType: BorderType.Circle,
                                      dashPattern: const [10, 5, 10, 5, 10, 5],
                                      child: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          radius:
                                              MediaQuery.of(context).size.width,
                                          backgroundImage:
                                              const AssetImage('assets/foto.png'),
                                        ),
                                      ),
                                    )),
                                Container(
                                    height: 35,
                                    width: 35,
                                    decoration: customBoxDecoration(18),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const ImageIcon(
                                        AssetImage(
                                            'assets/icons/vuesax-linear-edit.png'),
                                        color: SecondaryColor,
                                      ),
                                    ))
                              ]),
                        ),
                        Column(
                          children: [
                            Text(name,
                                style: const TextStyle( fontFamily: 'Mulish',
                                    color: DarkColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            Text(email,
                                style: const TextStyle( fontFamily: 'Mulish',
                                    color: Color(0XFF666666), fontSize: 12))
                          ],
                        )
                      ]),
                ),
                Container(
                  child: Column(children: [
                    itemOption("Editar Perfil", "vuesax-linear-edit-blue.png",
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  EditProfileScreen(name: name, email: email,)));
                    }, false),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 4, right: 1.5, left: 1.5),
                      padding: const EdgeInsets.only(left: 16, right: 4),
                      decoration: customBoxDecoration(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Notificaciones",
                              style: TextStyle( fontFamily: 'Mulish', 
                                  color: DarkColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Switch(
                                activeColor: SecondaryColor,
                                inactiveTrackColor: DarkColor,
                                value: _notificationActive,
                                onChanged: (value) {
                                  setState(() {
                                    _notificationActive = value;
                                  });
                                })
                          ]),
                    )
                  ]),
                )
              ],
            )));
  }
}
