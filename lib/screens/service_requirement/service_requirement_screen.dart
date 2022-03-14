import 'package:app_cre/screens/service_requirement/service_requirement_content_screen.dart';
import 'package:app_cre/services/auth_service.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/app_bar.dart';
import 'package:app_cre/widgets/custom_card.dart';
import 'package:app_cre/widgets/end_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceRequirementScreen extends StatefulWidget {
  const ServiceRequirementScreen({Key? key}) : super(key: key);

  @override
  State<ServiceRequirementScreen> createState() =>
      _ServiceRequirementScreenState();
}

class _ServiceRequirementScreenState extends State<ServiceRequirementScreen> {
  navigateServiceContent() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ServiceRequirementContentScreen(),
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
                    child: const Text("Requisitos de Servicio",
                        style: TextStyle( fontFamily: 'Mulish', 
                            color: Color(0XFF82BA00),
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      CustomCard(
                          title:
                              "Descuento a personas mayores a 60 años (Ley 1886)",
                          gradient: SecondaryGradient,
                          onTap: navigateServiceContent),
                      CustomCard(
                          title:
                              "CRE cerca de usted para facilitar el contacto",
                          gradient: DarkGradient,
                          onTap: navigateServiceContent),
                      CustomCard(
                          title:
                              "Transferencia del certificado de aportación por sucesión hereditaria",
                          gradient: DarkGradient,
                          onTap: navigateServiceContent),
                      CustomCard(
                          title:
                              "Controla tu consumo de energía con nuestra nueva aplicación CRE Móvil",
                          gradient: DarkGradient,
                          onTap: navigateServiceContent)
                    ],
                  ))
                ]))));
  }
}
