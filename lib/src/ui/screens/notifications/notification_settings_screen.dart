import 'dart:convert';
import 'dart:typed_data';

import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:app_cre/src/models/category.dart';

class NotificationSettingsScreen extends StatefulWidget {
  Iterable<Category> serviceCategories;

  NotificationSettingsScreen({Key? key, required this.serviceCategories})
      : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreen();
}

class _NotificationSettingsScreen extends State<NotificationSettingsScreen> {
  bool _notificationActive = false;
  late Iterable<Category> serviceCategories;

  @override
  void initState() {
    serviceCategories = widget.serviceCategories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, true),
        body: SafeArea(
          child: Container(
              color: const Color(0XFFF7F7F7),
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Notificaciones",
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 18,
                                color: DarkColor,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Selecciona las notificaciones que quieres recibir",
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w400, color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      children: [
                        Container(
                          height: 30,
                          margin: const EdgeInsets.only(left: 16, right: 15),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Text(
                                    "De Servicio",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: DarkColor,
                                        fontFamily: "Mulish"),
                                  )),
                              Switch(
                                  activeColor: SecondaryColor,
                                  inactiveTrackColor: DarkColor,
                                  value: _notificationActive,
                                  onChanged: (value) {
                                    setState(() {
                                      _notificationActive = value;
                                    });
                                  })
                            ],
                          ),
                        ),
                        Container(
                            padding:
                            const EdgeInsets.only(top: 8, left: 1, right: 1),
                            child: Column(
                              children: serviceCategories.map((e) => itemOptionSwitch(e.descriptionCategory, e.imageCategory)).toList(),
                            )),
                        Container(
                          height: 30,
                          margin: EdgeInsets.only(top: 16, left: 16, right: 15),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Text(
                                    "De Fundacion CRE",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: DarkColor,
                                        fontFamily: "Mulish"),
                                  )),
                              Switch(
                                  activeColor: SecondaryColor,
                                  inactiveTrackColor: DarkColor,
                                  value: _notificationActive,
                                  onChanged: (value) {
                                    setState(() {
                                      _notificationActive = value;
                                    });
                                  })
                            ],
                          ),
                        ),
                        Container(
                            padding:
                            const EdgeInsets.only(top: 8, left: 1, right: 1),
                            child: Column(
                              children: serviceCategories.map((e) => itemOptionSwitch(e.descriptionCategory, e.imageCategory)).toList(),
                            )),
                        const SizedBox(height: 16,)
                      ],
                    ))
                  ])),
        ));
  }

  Widget itemOptionSwitch(
      String title, String image) {
    Uint8List bytes = const Base64Decoder().convert(image);
    return Container(
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 1.5, right: 1.5),
        decoration: customBoxDecoration(10),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Image.memory(
                  bytes,
                  width: 24,
                ),),
            Expanded(
                child: ListView(
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
            Padding(
              padding: EdgeInsets.only(left: 4, right: 12),
              child:
              Switch(
                  activeColor: SecondaryColor,
                  inactiveTrackColor: DarkColor,
                  value: _notificationActive,
                  onChanged: (value) {
                    setState(() {
                      _notificationActive = value;
                    });
                  })
            )
          ],
        ));
  }
}
