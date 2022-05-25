import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/screens/did_you_know/did_you_know_screen.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BtnDidYouKnow extends StatelessWidget {
  const BtnDidYouKnow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        alignment: Alignment.center,
        width: 86,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 10)),
            color: const Color(0XFFF7F7F7),
            boxShadow: customBoxShadow()),
        child: Column(
          children: [
            IconButton(
              color: const Color(0xFF84BD00),
              icon: Badge(
                position: BadgePosition.topEnd(end: -2, top: -2),
                child: const ImageIcon(
                  AssetImage('assets/icons/vuesax-linear-lamp-charge.png'),
                  color: Color(0XFF84BD00),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DidYouKnowScreen()));
              },
            ),
            const Text(
              " ¿Sabías que?",
              style: TextStyle(
                  fontFamily: 'Mulish', color: Color(0XFF3A3D5F), fontSize: 12),
            )
          ],
        ));
  }
}