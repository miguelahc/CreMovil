import 'dart:convert';

import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/screens/home_screen.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserData();
}

class _UserData extends State<UserData> {
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
    return perfilUsuario(context);
  }

  Container perfilUsuario(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 105,
      decoration: customBoxDecoration(10),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DottedBorder(
              padding: const EdgeInsets.all(2),
              borderType: BorderType.Circle,
              dashPattern: const [6, 3, 6, 3, 6, 3],
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 13,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 10,
                  backgroundImage: const AssetImage('assets/foto.png'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                children: [
                                  Text("Hola, $name",
                                      style: const TextStyle(
                                          color: Color(0XFF3A3D5F),
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
                                          AssetImage(
                                              'assets/icons/vuesax-linear-edit.png'),
                                          color: Color(0XFF84BD00),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(
                                                          currentPage: 2)));
                                        },
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(email,
                      style: const TextStyle(
                          color: Color(0XFFA39F9F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display'))
                ],
              ),
            ),
            const BtnDidYouKnow()
          ],
        ),
      ),
    );
  }
}