import 'package:app_cre/ui/box_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget itemOption(String title, String icon, Function() function) {
  return GestureDetector(
    onTap: function,
    child: Container(
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 1.5, right: 1.5),
        decoration: customBoxDecoration(10),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 12),
              child: ImageIcon(
                AssetImage("assets/icons/$icon"),
                color: Color(0xFF3A3D5F),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFF3A3D5F),
                  fontSize: 14,
                  fontFamily: "Mulish",
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 12),
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        )),
  );
}
