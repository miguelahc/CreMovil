import 'dart:convert';
import 'dart:typed_data';

import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget itemOption(String title, String icon, Function() function, bool badge) {
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
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Badge(
                  position: BadgePosition.topEnd(end: -2, top: -2),
                  showBadge: badge,
                  child: ImageIcon(
                    AssetImage("assets/icons/$icon"),
                    color: const Color(0XFF3A3D5F),
                  ),
                )),
            Expanded(child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Color(0XFF3A3D5F),
                        fontSize: 14,
                        fontFamily: "Mulish",
                        fontWeight: FontWeight.w600),
                  ),
                  alignment: Alignment.center,
                  height: 50,
                )
              ],
            )),
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 12),
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        )),
  );
}

Widget itemOptionWithImage(
    String title, String base64, Function() function, bool badge) {
  Uint8List bytes = const Base64Decoder().convert(base64);
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
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Badge(
                  position: BadgePosition.topEnd(end: -2, top: -2),
                  showBadge: badge,
                  child: Image.memory(
                    bytes,
                    width: 24,
                  ),
                )),
            Text(
              title,
              style: const TextStyle(
                  color: Color(0XFF3A3D5F),
                  fontSize: 14,
                  fontFamily: "Mulish",
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 12),
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        )),
  );
}
