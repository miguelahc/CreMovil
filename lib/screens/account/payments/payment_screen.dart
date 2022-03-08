import 'dart:convert';

import 'package:app_cre/models/models.dart';
import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/CustomDot.dart';
import 'package:app_cre/widgets/payments_table.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final AccountDetail accountDetail;

  const PaymentScreen({Key? key, required this.accountDetail})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late AccountDetail accountDetail;
  bool onLoad = false;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    accountDetail = widget.accountDetail;
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0XFFF7F7F7),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: onLoad
            ? circularProgress()
            : SafeArea(
            child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(children: [
                  header(),
                  Container(
                    padding: const EdgeInsets.only(bottom: 4, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDot(page: 0, currentPage: _currentPage),
                        CustomDot(page: 1, currentPage: _currentPage),
                        CustomDot(page: 2, currentPage: _currentPage)
                      ],
                    ),
                  ),
                  pages(),
                  actions()
                ]))));
  }

  Widget header() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.only(left: 16),
            height: 70,
            alignment: Alignment.center,
            decoration: customBoxDecoration(10),
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
                      padding: const EdgeInsets.only(left: 16),
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
                                    color: Color(0XFF3A3D5F),
                                    fontSize: 14),
                              ),
                              Text(
                                accountDetail.accountNumber,
                                style: const TextStyle(
                                    color: Color(0XFF999999), fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            )),
        rowData("Titular: ", accountDetail.titularName),
        rowData("Direccion: ", accountDetail.address),
        const CustomDivider(),
      ],
    );
  }

  Widget pages() {
    return Expanded(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            //page 1
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: const Text("Selecciona las Facturas a Pagar",
                          style: TextStyle(color: SecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      PaymentsTable(pay: true),
                      paymentSummary(3, 18.88),
                    ],
                  ),
                ),
              ],
            ),
            //page 2
            Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: const Text("Selecciona el Método de Pago",
                          style: TextStyle(color: SecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              bottom: 8, left: 1.5, right: 1.5),
                          padding: const EdgeInsets.only(left: 16),
                          height: 35,
                          alignment: Alignment.center,
                          decoration: customBoxDecoration(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                    child: const Text(
                                      "Transferencia bancaria mediante código QR",
                                      style: TextStyle(
                                          color: Color(0XFF666666)),
                                    ),
                                  )
                              ),
                              Radio<bool>(
                                  visualDensity: VisualDensity.compact,
                                  activeColor: SecondaryColor,
                                  value: true,
                                  groupValue: true,
                                  onChanged: (bool? value) {}
                              ),
                            ],
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              bottom: 8, left: 1.5, right: 1.5),
                          padding: const EdgeInsets.only(left: 16),
                          height: 35,
                          alignment: Alignment.center,
                          decoration: customBoxDecoration(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                    child: const Text(
                                      "Tarjeta de Débito / Crédito",
                                      style: TextStyle(
                                          color: Color(0XFF666666)),
                                    ),
                                  )
                              ),
                              Radio<bool>(
                                  visualDensity: VisualDensity.compact,
                                  activeColor: SecondaryColor,
                                  value: false,
                                  groupValue: false,
                                  onChanged: (bool? value) {}
                              ),
                            ],
                          )
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16, top: 12, bottom: 8),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Facturas seleccionadas:",
                          style: TextStyle(color: DarkColor),
                        ),
                      ),
                      PaymentsTable(pay: false),
                      paymentSummary(3, 18.88),
                    ],
                  ),
                )
              ],
            )
            //page 3

          ],
        )
    );
  }


  Widget paymentSummary(int invoices, double mount) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 16),
      height: 83,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          boxShadow: customBoxShadow(),
          color: DarkColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
        Container(
          height: 43,
          child: Row(
            children: [
              const ImageIcon(
                AssetImage('assets/icons/vuesax-linear-dollar-circle.png'),
                color: Colors.white,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total de facturas a pagar: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        invoices.toString(),
                        style: const TextStyle(
                            color: SecondaryColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.white,
        ),
        Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      "Monto Bs. ", style: TextStyle(color: Colors.white)),
                  Text(mount.toString(),
                      style: const TextStyle(
                          color: Color(0XFF82BA00),
                          fontWeight: FontWeight.bold))
                ],
              ),
            ))
      ]),
    );
  }

  Widget rowData(String key, String value) {
    return Column(
      children: [
        const CustomDivider(),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 40,
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
                                color: Color(0XFF3A3D5F),
                                fontSize: 14),
                          ),
                          Text(
                            value,
                            style: const TextStyle(
                                color: Color(0XFF999999), fontSize: 14),
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

  Widget actions() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, top: 16),
      alignment: Alignment.bottomCenter,
      child: MaterialButton(
          padding: const EdgeInsets.all(0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          disabledColor: Colors.black87,
          elevation: 0,
          child: Container(
            constraints: BoxConstraints(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.75,
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.75,
                maxHeight: 50),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                    colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
            child: const Text(
              'Siguiente',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () {
            _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
            setState(() {
              _currentPage = 1;
            });
          }),
    );
  }
}