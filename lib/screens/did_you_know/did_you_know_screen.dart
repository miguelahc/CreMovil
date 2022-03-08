import 'package:app_cre/screens/did_you_know/did_you_know_content_screen.dart';
import 'package:app_cre/screens/service_requirement/service_requirement_content_screen.dart';
import 'package:app_cre/services/auth_service.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/app_bar.dart';
import 'package:app_cre/widgets/custom_card.dart';
import 'package:app_cre/widgets/end_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DidYouKnowScreen extends StatefulWidget {
  const DidYouKnowScreen({Key? key}) : super(key: key);

  @override
  State<DidYouKnowScreen> createState() =>
      _DidYouKnowScreenState();
}

class _DidYouKnowScreenState extends State<DidYouKnowScreen> {
  navigateServiceContent() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const DidYouKnowContentScreen(),
    ));
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
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text("¿Sabías que?",
                        style: TextStyle(
                            color: Color(0XFF82BA00),
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: ListView(
                        children: [
                          CustomCard(
                              title:
                              "Ahora puedes pagar tus facturas en línea desde nuestra app CRE Móvil",
                              gradient: SecondaryGradient,
                              onTap: navigateServiceContent),
                          CustomCard(
                              title:
                              "Puedes ahorrar dinero mes a mes en tus facturas de consumo con estos tips",
                              gradient: DarkGradient,
                              onTap: navigateServiceContent),
                          CustomCard(
                              title:
                              "Nuestro servicio técnico estará disponible en tu hogar, solicitándolo desde CRE Móvil",
                              gradient: DarkGradient,
                              onTap: navigateServiceContent),
                          CustomCard(
                              title:
                              "Puedes recibir notificaciones de nuevas facturas en tu celular con CRE Móvil",
                              gradient: DarkGradient,
                              onTap: navigateServiceContent)
                        ],
                      ))
                ]
              )
            )
        )
    );
  }
}
