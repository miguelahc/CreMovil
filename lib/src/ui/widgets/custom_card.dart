import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  String title;
  String coverImage;
  LinearGradient gradient;
  Function() onTap;

  CustomCard(
      {Key? key,
      required this.title,
      required this.coverImage,
      required this.gradient,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = const Base64Decoder().convert(coverImage);
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: MediaQuery.of(context).size.width - 32,
          height: 170,
          decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Column(children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              // child: Image.asset(
              //   'assets/image_service.png',
              //   width: MediaQuery.of(context).size.width - 32,
              //   height: 112,
              //   fit: BoxFit.cover,
              //   alignment: Alignment.topCenter,
              // ),
              child: Image.memory(base64Decode(coverImage.toString()),
                  width: MediaQuery.of(context).size.width - 32,
                  height: 12,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter),
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                        const Padding(
                          padding: EdgeInsets.only(left: 24, right: 16),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )))
          ]),
        ));
  }
}
