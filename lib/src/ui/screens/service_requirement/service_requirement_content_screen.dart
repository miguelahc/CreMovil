import 'dart:convert';

import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:flutter/material.dart';

class ServiceRequirementContentScreen extends StatefulWidget {
  final Requisite requisite;

  const ServiceRequirementContentScreen({Key? key, required this.requisite})
      : super(key: key);

  @override
  State<ServiceRequirementContentScreen> createState() =>
      _ServiceRequirementContentScreenState();
}

class _ServiceRequirementContentScreenState
    extends State<ServiceRequirementContentScreen> {
  List<Requisite> images = List.empty(growable: true);
  bool loadData = true;

  @override
  void initState() {
    TokenService().readToken().then((token) {
      RequisitesService()
          .getRequisiteDetail(token, widget.requisite.id)
          .then((value) {
        var code = jsonDecode(value)["Code"];
        if (code == 0) {
          var message = jsonDecode(value)["Message"];
          List<dynamic> list = jsonDecode(message);
          setState(() {
            images = RequisitesService().parseData(list);
            loadData = false;
          });
        } else {
          setState(() {
            loadData = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color(0XFFF7F7F7),
            child: SafeArea(
                child: Column(children: [
              Expanded(
                  child: Container(
                      color: const Color(0XFFF7F7F7),
                      child: Column(children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                  child: Image.memory(
                                    base64Decode(widget.requisite.coverImage),
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(context);
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_left,
                                          color: Colors.white)),
                                )
                              ],
                            )),
                        Expanded(
                            child: ListView(
                          children: [
                            Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width - 32,
                              padding:
                                  const EdgeInsets.only(left: 16, right: 32),
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              decoration: customBoxDecoration(15),
                              child: Text(
                                widget.requisite.title,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    color: DarkColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Container(
                              decoration: customBoxDecoration(15),
                              width: MediaQuery.of(context).size.width - 32,
                              // padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: images
                                    .map((e) => ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(25)),
                                        child: Image.memory(
                                          base64Decode(e.coverImage),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              32,
                                        )))
                                    .toList(),
                              ),
                            )
                          ],
                        ))
                      ])))
            ]))));
  }

  Widget item(String data) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: Text(
          data,
          style:
              const TextStyle(fontFamily: 'Mulish', color: Color(0XFF666666)),
        ));
  }
}
