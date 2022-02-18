import 'dart:convert';

import 'package:app_cre/models/invoice_detail.dart';
import 'package:app_cre/services/auth_service.dart';
import 'package:app_cre/services/invoice_service.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/widgets/app_bar.dart';
import 'package:app_cre/widgets/end_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final InvoiceDetail invoiceDetail;
  InvoiceDetailScreen({Key? key, required this.invoiceDetail})
      : super(key: key);

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late InvoiceDetail invoiceDetail;

  @override
  void initState() {
    invoiceDetail = widget.invoiceDetail;
    super.initState();
    TokenService().readToken().then((token) {
      UserService().readUserData().then((data) {
        var userData = jsonDecode(data);
        InvoiceService()
            .getInvoiceDetail(token, userData, invoiceDetail.documentNumber,
                invoiceDetail.companyNumber)
            .then((dataI) {
          var message = jsonDecode(jsonDecode(dataI)["Message"]);
          setState(() {
            invoiceDetail.titularName = message["TitularName"];
            invoiceDetail.invoiceName = message["InvoiceName"];
            invoiceDetail.location = message["Location"];
            invoiceDetail.categoryName = message["CategoryName"];
            invoiceDetail.totalInvoice = message["TotaInvoice"];
            invoiceDetail.baseTaxCredit = message["BaseTaxCredit"];
            Iterable<dynamic> categories = message["detalle"];
            invoiceDetail.energyPower = categories.where(
              (element) =>
                  element["Category"] != null &&
                  element["Category"] == "Energía y potencia",
            );
            invoiceDetail.municipalFees = categories.where(
              (element) =>
                  element["Category"] != null &&
                  element["Category"] == "Tasas Municipales",
            );
            invoiceDetail.chargesPayments = categories.where(
              (element) =>
                  element["Category"] != null &&
                  element["Category"] == "Cargos / Abonos",
            );
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
        backgroundColor: Color(0XFFF7F7F7),
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  height: 70,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Factura Nro: ",
                              style: TextStyle(
                                  color: Color(0XFF3A3D5F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              invoiceDetail.documentNumber.toString(),
                              style: const TextStyle(
                                  color: Color(0XFF999999),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              "Estado: ",
                              style: TextStyle(
                                  color: Color(0XFF999999),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Emitida",
                              style: TextStyle(
                                  color: Color(0XFF84BD00),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              "Fecha de emisión: ",
                              style: TextStyle(
                                  color: Color(0XFF999999),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "02 de ene. 2022",
                              style: TextStyle(
                                  color: Color(0XFF999999),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    )),
                    MaterialButton(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        disabledColor: Colors.black87,
                        elevation: 0,
                        child: Container(
                            constraints:
                                BoxConstraints(minWidth: 110, maxHeight: 25),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(colors: [
                                  Color(0XFF618A02),
                                  Color(0XFF84BD00)
                                ])),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Descargar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            )),
                        onPressed: () {})
                  ]),
                ),
                rowData("Titular: ", invoiceDetail.titularName),
                rowData("Facturar a: ", invoiceDetail.invoiceName),
                rowData("Ubicación: ", invoiceDetail.location),
                doubleRowDataImage("Categoria: ", invoiceDetail.categoryName,
                    "Lectura", "camera-small.png"),
                doubleRowData(
                    "Periodo: ", "02 nov. 2021 / 01 dic. 2021", "Días: ", "31"),
                // Seccion energia y potencia
                section("Energía y potencia", "Monto Bs.", Colors.white),
                Column(
                    children: invoiceDetail.energyPower
                        .map((e) => doubleSimpleRowData(
                            e["Description"], e["Value"].toString()))
                        .toList()),
                // Seccion tasas municipales
                section("Tasas municipales", "Monto Bs.", Colors.white),
                Column(
                    children: invoiceDetail.municipalFees
                        .map((e) => doubleSimpleRowData(
                            e["Description"], e["Value"].toString()))
                        .toList()),
                // Seccion Cargos y abonos
                section("Cargos / abonos", "Monto Bs.", Colors.white),
                doubleSimpleRowData(
                    "Beneficiarios por tarifa dignidad con", "3.00"),

                Column(
                    children: invoiceDetail.chargesPayments
                        .map((e) => doubleSimpleRowData(
                            e["Description"], e["Value"].toString()))
                        .toList()),

                doubleSimpleRowData("Base p/cred. fiscal Bs.",
                    invoiceDetail.baseTaxCredit.toString()),
                section("Total facturado Bs.",
                    invoiceDetail.totalInvoice.toString(), Color(0XFF393E5E)),
                const SizedBox(
                  height: 16,
                ),
                MaterialButton(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    disabledColor: Colors.black87,
                    elevation: 0,
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.75,
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                          maxHeight: 50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                              colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
                      child: const Text(
                        'Pagar',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    onPressed: () {})
              ])),
        ));
  }

  Widget rowData(String key, String value) {
    return Column(
      children: [
        const Divider(
          height: 20,
          color: Colors.black,
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          height: 30,
          child: Row(
            children: [
              Text(
                key,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF3A3D5F),
                    fontSize: 14),
              ),
              Text(
                value,
                style: TextStyle(color: const Color(0XFF999999), fontSize: 14),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget doubleRowData(String key, String value, String key2, String value2) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          height: 30,
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Text(
                    key,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value,
                    style:
                        TextStyle(color: const Color(0XFF999999), fontSize: 14),
                  )
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    key2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value2,
                    style:
                        TextStyle(color: const Color(0XFF999999), fontSize: 14),
                  )
                ],
              )
            ],
          ),
        ),
        const Divider(
          height: 20,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget doubleRowDataImage(
      String key, String value, String text, String imagePath) {
    return Column(
      children: [
        const Divider(
          height: 22,
          color: Colors.black,
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          height: 30,
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Text(
                    key,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value,
                    style:
                        TextStyle(color: const Color(0XFF999999), fontSize: 14),
                  )
                ],
              )),
              MaterialButton(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  disabledColor: Colors.black87,
                  elevation: 0,
                  child: Container(
                      constraints: BoxConstraints(minWidth: 110, maxHeight: 25),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                              colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
                      child: Row(
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/$imagePath'),
                            color: Colors.white,
                          ),
                          Text(
                            text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )),
                  onPressed: () {})
            ],
          ),
        ),
        const Divider(
          height: 22,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget doubleSimpleRowData(String key, String key2) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          height: 35,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  key,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0XFF999999),
                      fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    key2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF999999),
                        fontSize: 14),
                  )
                ],
              )
            ],
          ),
        ),
        const Divider(
          height: 10,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget section(String key, String key2, Color color) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.only(left: 16, right: 16),
          height: 40,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                key,
                style: TextStyle(
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
