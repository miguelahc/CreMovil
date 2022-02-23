import 'dart:convert';

import 'package:app_cre/models/models.dart';
import 'package:app_cre/models/reading.dart';
import 'package:app_cre/providers/reading_form_provider.dart';
import 'package:app_cre/screens/simulated_invoice_screen.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/input_decorations.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SimulateInvoiceScreen extends StatefulWidget {
  final AccountDetail accountDetail;
  SimulateInvoiceScreen({Key? key, required this.accountDetail})
      : super(key: key);

  @override
  State<SimulateInvoiceScreen> createState() => _SimulateInvoiceScreenState();
}

class _SimulateInvoiceScreenState extends State<SimulateInvoiceScreen> {
  late AccountDetail accountDetail;
  String lastDate = "";
  int lastReading = 15102;

  @override
  void initState() {
    accountDetail = widget.accountDetail;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    lastDate = formatter.format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text("Simular Factura",
                        style: TextStyle(
                            color: Color(0XFF82BA00),
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 16),
                      height: 80,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ImageIcon(
                            AssetImage(
                                'assets/icons/vuesax-linear-keyboard-open-blue.png'),
                            color: Color(0XFF3A3D5F),
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  accountDetail.aliasName,
                                  style: const TextStyle(
                                      color: Color(0XFF3A3D5F),
                                      fontSize: 16,
                                      fontFamily: "Mulish"),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Código fijo: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0XFF3A3D5F),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      accountDetail.accountNumber,
                                      style: const TextStyle(
                                          color: const Color(0XFF999999),
                                          fontSize: 14),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                        ],
                      )),
                  rowData("Titular: ", accountDetail.titularName),
                  rowData("Fecha última lectura: ", lastDate),
                  const Divider(
                    height: 18,
                    color: Colors.black,
                  ),
                  Container(
                      height: 40,
                      margin: const EdgeInsets.only(
                          top: 32, bottom: 32, left: 64, right: 64),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Última lectura: ",
                            style: TextStyle(
                                fontSize: 16, color: Color(0XFF3A3D5F)),
                          ),
                          Text(
                            "$lastReading Kwh",
                            style: const TextStyle(
                                fontSize: 16, color: Color(0XFF666666)),
                          )
                        ],
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/ejemplo.png"),
                  ),
                  Expanded(
                      child: ChangeNotifierProvider(
                    create: (_) => ReadingFormProvider(),
                    child: FormCurrentReadingState(
                      lastReading: lastReading,
                      accountDetail: accountDetail,
                      lastDate: lastDate,
                    ),
                  ))
                ]))));
  }

  Widget rowData(String key, String value) {
    return Column(
      children: [
        const Divider(
          height: 20,
          color: Colors.black,
        ),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 16, right: 16),
            height: 30,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
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
                            style: const TextStyle(
                                color: const Color(0XFF999999), fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}

class FormCurrentReadingState extends StatelessWidget {
  final int lastReading;
  final String lastDate;
  final AccountDetail accountDetail;
  const FormCurrentReadingState(
      {Key? key,
      required this.lastReading,
      required this.accountDetail,
      required this.lastDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readingForm = Provider.of<ReadingFormProvider>(context);
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Form(
          key: readingForm.formKey,
          child: Column(children: [
            _CurrentReading(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      disabledColor: Colors.black87,
                      elevation: 0,
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.4,
                            maxWidth: MediaQuery.of(context).size.width * 0.4,
                            maxHeight: 50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0XFF618A02),
                              Color(0XFF84BD00)
                            ])),
                        child: readingForm.isLoading
                            ? circularProgress()
                            : const Text(
                                'Simular Factura',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                      onPressed: () {
                        if (readingForm.isValidForm() &&
                            !readingForm.isLoading) {
                          if (int.parse(readingForm.reading) <= lastReading) {
                            _showDialogError(context);
                          } else {
                            Reading reading = Reading(
                                accountDetail.accountNumber,
                                accountDetail.companyNumber,
                                int.parse(readingForm.reading));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SimulatedInvoiceScreen(
                                            reading: reading)));
                          }
                        }
                        FocusScope.of(context).unfocus();
                      }),
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      disabledColor: Colors.black87,
                      elevation: 0,
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.4,
                            maxWidth: MediaQuery.of(context).size.width * 0.4,
                            maxHeight: 50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Color(0XFF3A3D5F), width: 1.5),
                        ),
                        child: const Text(
                          'Cancelar',
                          style:
                              TextStyle(color: Color(0XFF3A3D5F), fontSize: 16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ))
          ]),
        ));
  }

  _showDialogError(context) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          'La Lectura Actual debe ser \nmayor a la Última Lectura',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Align(
              alignment: Alignment.center,
              child: MaterialButton(
                  padding: EdgeInsets.all(0),
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
        ],
      ),
    );
  }
}

class _CurrentReading extends StatelessWidget {
  const _CurrentReading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readingForm = Provider.of<ReadingFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Digite la lectura actual de su medidor',
          labelText: 'Lectura actual',
          prefixIcon: Icons.watch_later_outlined),
      style: const TextStyle(fontSize: 14),
      initialValue: '',
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        readingForm.reading = value;
      },
      validator: (value) {
        String pattern = r'^\d+$';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return "Solo se aceptan carateres numéricos";
        }
      },
    );
  }
}
