import 'dart:convert';
import 'dart:typed_data';

import 'package:app_cre/src/models/did_you_know.dart';
import 'package:app_cre/src/ui/screens/did_you_know/did_you_know_content_screen.dart';
import 'package:app_cre/src/ui/screens/service_requirement/service_requirement_content_screen.dart';
import 'package:app_cre/src/services/auth_service.dart';
import 'package:app_cre/src/services/did_you_know_service.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:app_cre/src/ui/widgets/app_bar.dart';
import 'package:app_cre/src/ui/widgets/custom_card.dart';
import 'package:app_cre/src/ui/widgets/end_drawer.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DidYouKnowScreen extends StatefulWidget {
  const DidYouKnowScreen({Key? key}) : super(key: key);

  @override
  State<DidYouKnowScreen> createState() => _DidYouKnowScreenState();
}

class _DidYouKnowScreenState extends State<DidYouKnowScreen> {
  List<DidYouKnow> items = List.empty(growable: true);
  bool loadData = true;

  navigateServiceContent() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const DidYouKnowContentScreen(),
    ));
  }

  @override
  void initState() {
    TokenService().readToken().then((token) {
      DidYouKnowService().getDidYouKnow(token).then((value) {
        var code = jsonDecode(value)["Code"];
        if (code == 0) {
          var message = jsonDecode(value)["Message"];
          List<dynamic> list = jsonDecode(message);
          setState(() {
            items = DidYouKnowService().parseData(list);
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
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0XFFF7F7F7),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text("¿Sabías que?",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            color: Color(0XFF82BA00),
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      loadData
                          ? SizedBox(
                              child: circularProgress(),
                              height: MediaQuery.of(context).size.height * 0.9,
                            )
                          : Column(
                              children: items
                                  .map((e) => CustomCard(
                                      title: e.title,
                                      coverImage: e.coverImage,
                                      gradient: SecondaryGradient,
                                      onTap: navigateServiceContent))
                                  .toList())
                    ],
                  ))
                ]))));
  }
}
