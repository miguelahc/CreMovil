import 'dart:convert';

import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DidYouKnowContentScreen extends StatefulWidget {
  final DidYouKnow didYouKnow;

  const DidYouKnowContentScreen({Key? key, required this.didYouKnow})
      : super(key: key);

  @override
  State<DidYouKnowContentScreen> createState() =>
      _DidYouKnowContentScreenState();
}

class _DidYouKnowContentScreenState extends State<DidYouKnowContentScreen> {
  List<DidYouKnow> images = List.empty(growable: true);
  bool loadData = true;

  @override
  void initState() {
    TokenService().readToken().then((token) {
      DidYouKnowService()
          .getDidYouKnowDetail(token, widget.didYouKnow.id)
          .then((value) {
        var code = jsonDecode(value)["Code"];
        if (code == 0) {
          var message = jsonDecode(value)["Message"];
          List<dynamic> list = jsonDecode(message);
          setState(() {
            images = DidYouKnowService().parseData(list);
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
                            margin: const EdgeInsets.only(bottom: 16),
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                  child: Image.memory(
                                      base64Decode(widget.didYouKnow.coverImage
                                          .toString()),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter),
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
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 12),
                                decoration: customBoxDecoration(15),
                                child: Row(
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: ImageIcon(
                                          AssetImage(
                                              'assets/icons/vuesax-linear-lamp-on.png'),
                                          color: SecondaryColor,
                                          size: 40,
                                        )),
                                    Expanded(
                                        child: Text(
                                      widget.didYouKnow.title,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          color: DarkColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ))
                                  ],
                                )),
                            loadData
                                ? circularProgress()
                                : Container(
                                    decoration: customBoxDecoration(15),
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    // padding: const EdgeInsets.all(16),
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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

  Widget item(int i, String data) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(
                color: DarkColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: Text(
              i.toString(),
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: Text(
            data,
            style: TextStyle(fontFamily: 'Mulish', color: Color(0XFF666666)),
          ))
        ],
      ),
    );
  }
}
