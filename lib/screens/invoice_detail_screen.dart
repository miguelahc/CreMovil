import 'dart:convert';

import 'package:app_cre/models/models.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final InvoiceDetail invoiceDetail;
  const InvoiceDetailScreen({Key? key, required this.invoiceDetail})
      : super(key: key);

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  bool onLoad = true;
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
        backgroundColor: const Color(0XFFF7F7F7),
        body: onLoad
            ? circularProgress()
            : SafeArea(
                child: Container(
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 70,
                        alignment: Alignment.center,
                        decoration: customBoxDecoration(10),
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
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              disabledColor: Colors.black87,
                              elevation: 0,
                              child: Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 110, maxHeight: 25),
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
                              onPressed: () {
                                _showDialogDownload(context);
                              })
                        ]),
                      ),
                      rowData("Titular: ", invoiceDetail.titularName),
                      rowData("Facturar a: ", invoiceDetail.invoiceName),
                      rowData("Ubicación: ", invoiceDetail.location),
                      doubleRowDataImage(
                          "Categoria: ",
                          invoiceDetail.categoryName,
                          "Lectura",
                          "camera-small.png"),
                      doubleRowData("Periodo: ", "02 nov. 2021 / 01 dic. 2021",
                          "Días: ", "31"),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                          child: ListView(
                        children: [
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
                          ),
                          MaterialButton(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              disabledColor: Colors.black87,
                              elevation: 0,
                              child: Container(
                                constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75,
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75,
                                    maxHeight: 50),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(colors: [
                                      Color(0XFF618A02),
                                      Color(0XFF84BD00)
                                    ])),
                                child: const Text(
                                  'Pagar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              onPressed: () {})
                        ],
                      ))
                    ])),
              ));
  }

  _showDialogDownload(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          child: Column(
            children: [
              const Text(
                'Opciones de descarga:',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Column(
                    children: const [
                      ImageIcon(
                        AssetImage('assets/icons/document-download.png'),
                        color: Color(0XFF3A3D5F),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Aviso cobranza",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Column(
                    children: const [
                      ImageIcon(
                        AssetImage('assets/icons/document-download.png'),
                        color: Color(0XFF3A3D5F),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Factura", style: TextStyle(fontSize: 12))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: MaterialButton(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                disabledColor: Colors.black87,
                elevation: 0,
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                      maxHeight: 50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                          colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
                  child: const Text(
                    'Regresar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }

  _showDialogImage(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Image.asset('assets/medidor.jpg'),
        ),
      ),
    );
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
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF3A3D5F),
                    fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(color: Color(0XFF999999), fontSize: 14),
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
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 40,
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Text(
                    key,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value,
                    style:
                        const TextStyle(color: Color(0XFF999999), fontSize: 14),
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
                        color: Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value2,
                    style:
                        const TextStyle(color: Color(0XFF999999), fontSize: 14),
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

  Widget doubleRowDataImage(
      String key, String value, String text, String imagePath) {
    return Column(
      children: [
        const CustomDivider(),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 40,
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Text(
                    key,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value,
                    style:
                        const TextStyle(color: Color(0XFF999999), fontSize: 14),
                  )
                ],
              )),
              MaterialButton(
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  disabledColor: Colors.black87,
                  elevation: 0,
                  child: Container(
                      constraints: const BoxConstraints(minWidth: 110, maxHeight: 25),
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
                  onPressed: () {
                    _showDialogImage(context);
                  })
            ],
          ),
        ),
        const CustomDivider()
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
          padding: const EdgeInsets.only(left: 16, right: 16),
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
