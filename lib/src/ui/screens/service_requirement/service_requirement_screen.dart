import 'dart:convert';

import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceRequirementScreen extends StatefulWidget {
  const ServiceRequirementScreen({Key? key}) : super(key: key);

  @override
  State<ServiceRequirementScreen> createState() =>
      _ServiceRequirementScreenState();
}

class _ServiceRequirementScreenState extends State<ServiceRequirementScreen> {
  List<Requisite> items = List.empty(growable: true);
  bool loadData = true;

  navigateServiceContent(Requisite requisite) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ServiceRequirementContentScreen(
        requisite: requisite,
      ),
    ));
  }

  @override
  void initState() {
    TokenService().readToken().then((token) {
      RequisitesService().getRequisites(token).then((value) {
        var code = jsonDecode(value)["Code"];
        if (code == 0) {
          var message = jsonDecode(value)["Message"];
          List<dynamic> list = jsonDecode(message);
          setState(() {
            items = RequisitesService().parseData(list);
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
        backgroundColor: const Color(0XFFF7F7F7),
        appBar: appBar(context, true),
        body: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text("Requisitos de Servicio",
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
                                      onTap: () => navigateServiceContent(e)))
                                  .toList())
                    ],
                  ))
                ]))));
  }
}
