import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget itemOption(String title, String icon, Function() function) {
  return Container(
    margin: const EdgeInsets.only(top: 5, bottom: 5),
    decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: ListTile(
        onTap: function,
        leading: ImageIcon(
          AssetImage("assets/icons/$icon"),
          color: Color(0xFF3A3D5F),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFF3A3D5F),
                  fontSize: 14,
                  fontFamily: "Mulish",
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_right)
          ],
        )),
  );
}
