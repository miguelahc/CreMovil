import 'dart:convert';

import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SimulatedInvoiceScreen extends StatefulWidget {
  final Reading reading;

  const SimulatedInvoiceScreen({Key? key, required this.reading})
      : super(key: key);

  @override
  State<SimulatedInvoiceScreen> createState() => _SimulatedInvoiceScreenState();
}

class _SimulatedInvoiceScreenState extends State<SimulatedInvoiceScreen> {
  bool onLoad = true;
  late Reading reading;
  late InvoiceDetail invoiceDetail;

  @override
  void initState() {
    reading = widget.reading;
    invoiceDetail = InvoiceDetail(reading.accountNumber, reading.companyNumber);
    super.initState();
    TokenService().readToken().then((token) {
      UserService().readUserData().then((data) {
        var userData = jsonDecode(data);
        InvoiceService()
            .simulateInvoice(token, userData, reading.accountNumber,
                reading.companyNumber, reading.currentReading)
            .then((dataS) {
          setState(() {
            InvoiceService().parseData(invoiceDetail, dataS);
            onLoad = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        appBar: appBar(context, true),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        floatingActionButton: FloatingHomeButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: const Color(0XFFF7F7F7),
        body: onLoad
            ? circularProgress()
            : SafeArea(
                child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.only(
                              left: 16, bottom: 16, right: 16),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Factura Simulada",
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      color: Color(0XFF82BA00),
                                      fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Código Fijo: ",
                                      style: TextStyle(
                                          fontFamily: 'Mulish',
                                          color: Color(0XFF3A3D5F),
                                          fontWeight: FontWeight.bold)),
                                  Text(reading.accountNumber,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          color: Color(0XFF666666)))
                                ],
                              )
                            ],
                          )),
                      Expanded(
                          child: ListView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          rowData("Titular: ", invoiceDetail.titularName),
                          rowData("Categoria: ", invoiceDetail.categoryName),
                          Column(
                              children: invoiceDetail.others
                                  .map((e) => rowData(
                                      e["Description"] + ": ",
                                      e["Concept"] != ""
                                          ? e["Concept"]
                                          : e["Value"].toString()))
                                  .toList()),
                          const CustomDivider(),
                          const SizedBox(
                            height: 8,
                          ),
                          // Seccion energia y potencia
                          section(
                              "Energía y potencia", "Monto Bs.", Colors.white),
                          Column(
                              children: invoiceDetail.energyPower
                                  .map((e) => doubleSimpleRowData(
                                      e["Description"], e["Value"].toString()))
                                  .toList()),
                          // Seccion tasas municipales
                          section(
                              "Tasas municipales", "Monto Bs.", Colors.white),
                          Column(
                              children: invoiceDetail.municipalFees
                                  .map((e) => doubleSimpleRowData(
                                      e["Description"], e["Value"].toString()))
                                  .toList()),
                          // Seccion Cargos y abonos
                          section("Cargos / abonos", "Monto Bs.", Colors.white),
                          Column(
                              children: invoiceDetail.chargesPayments
                                  .map((e) => doubleSimpleRowData(
                                      e["Description"], e["Value"].toString()))
                                  .toList()),

                          doubleSimpleRowData("Base p/cred. fiscal Bs.",
                              invoiceDetail.baseTaxCredit.toString()),
                          section(
                              "Total facturado Bs.",
                              invoiceDetail.totalInvoice.toString(),
                              const Color(0XFF393E5E)),
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ))
                    ])),
              ));
  }

  Widget rowData(String key, String value) {
    return Column(
      children: [
        const CustomDivider(),
        Container(
          padding: const EdgeInsets.only(left: 16),
          height: 40,
          child: Row(
            children: [
              Text(
                key,
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF3A3D5F),
                    fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontFamily: 'Mulish',
                    color: Color(0XFF999999),
                    fontSize: 14),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget doubleSimpleRowData(String key, String key2) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  key,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF999999),
                      fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    key2,
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF999999),
                        fontSize: 14),
                  )
                ],
              )
            ],
          ),
        ),
        const CustomDivider()
      ],
    );
  }

  Widget section(String key, String key2, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
              ),
            ],
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 16, right: 16),
          margin:
              const EdgeInsets.only(left: 1.5, right: 1.5, top: 1, bottom: 1),
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(
                key,
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.bold,
                    color: (color == Colors.white)
                        ? const Color(0XFF3A3D5F)
                        : Colors.white,
                    fontSize: 14),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    key2,
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        color: (color == Colors.white)
                            ? const Color(0XFF3A3D5F)
                            : Colors.white,
                        fontSize: 14),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
