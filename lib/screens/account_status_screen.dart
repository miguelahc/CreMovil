import 'dart:convert';

import 'package:app_cre/models/account_detail.dart';
import 'package:app_cre/screens/account_history_screen.dart';
import 'package:app_cre/screens/edit_reference_screen.dart';
import 'package:app_cre/services/auth_service.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/widgets/app_bar.dart';
import 'package:app_cre/widgets/circular_progress.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountStatusScreen extends StatefulWidget {
  final String accountNumber;
  final String companyNumber;

  AccountStatusScreen(
      {Key? key, required this.accountNumber, required this.companyNumber})
      : super(key: key);

  @override
  State<AccountStatusScreen> createState() => _AccountStatusScreenState();
}

class _AccountStatusScreenState extends State<AccountStatusScreen> {
  AccountDetail accountDetail = AccountDetail();
  bool onLoad = true;

  @override
  void initState() {
    TokenService().readToken().then((token) {
      UserService().readUserData().then((data) {
        var userData = jsonDecode(data);
        AccountService()
            .getStatement(
                token, userData, widget.accountNumber, widget.companyNumber)
            .then((data) {
          loadData(accountDetail, data);
        });
      });
    });
    super.initState();
  }

  loadData(AccountDetail accountDetail, data) {
    var message = jsonDecode(jsonDecode(data)["Message"]);
    setState(() {
      accountDetail.aliasName = message["AliasName"];
      accountDetail.accountNumber = message["AccountNumber"];
      accountDetail.titularName = message["TitularName"];
      accountDetail.address = message["Address"];
      accountDetail.state = message["StateAccount"];
      accountDetail.dist = message["DistrictCode"];
      accountDetail.secc = message["SectionCode"];
      accountDetail.totalDebt = message["TotalDebt"];
      accountDetail.accountHistory = message["estadocuenta"];
      this.onLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0XFFF7F7F7),
      endDrawer: SafeArea(child: endDrawer(authService, context)),
      appBar: appBar(context, true),
      body: onLoad
          ? circularProgress()
          : SafeArea(
              child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Column(children: [
                Container(
                    padding: EdgeInsets.only(left: 16),
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
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
                                    color: const Color(0XFF3A3D5F),
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
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditReferenceScreen(
                                          reference: accountDetail.aliasName,
                                        )));
                          },
                          icon: const ImageIcon(
                            AssetImage('assets/icons/vuesax-linear-edit.png'),
                            color: Color(0XFF84BD00),
                          ),
                        )
                      ],
                    )),
                rowData("Tipo de Cuenta: ", accountDetail.accountType),
                rowData("Titular: ", accountDetail.titularName),
                rowData("Categoría: ", accountDetail.category),
                rowData("Dirección: ", accountDetail.address),
                doubleRowData(
                    "Usuario: ", "Asociado", "Estado: ", accountDetail.state),
                doubleRowData("Distrito: ", accountDetail.dist, "Sección: ",
                    accountDetail.secc),
                const Divider(
                  height: 20,
                  color: Colors.black,
                ),
                accountDetail.totalDebt > 0.0
                    ? Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        height: 110,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0XFF3A3D5F),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(children: [
                          Container(
                            height: 65,
                            child: Row(
                              children: [
                                const ImageIcon(
                                  AssetImage(
                                      'assets/icons/vuesax-linear-dollar-circle.png'),
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Deuda",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Total facturado: ",
                                      style: TextStyle(
                                          color: Color(0XFF82BA00),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text("Monto Bs.",
                                        style: TextStyle(color: Colors.white)),
                                    Text(
                                      accountDetail.totalDebt.toString(),
                                      style: const TextStyle(
                                          color: Color(0XFF82BA00),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.white,
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(left: 40),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Facturas impagas: ",
                                    style: TextStyle(color: Colors.white)),
                                Text(accountDetail.invoiceIp,
                                    style: const TextStyle(
                                        color: Color(0XFF82BA00),
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ))
                        ]),
                      )
                    : SizedBox(),
                Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: const Text("Opciones",
                      style: TextStyle(
                          color: Color(0XFF82BA00),
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      (accountDetail.totalDebt > 0.0)
                          ? option("Pagar Deuda", "money-send-pay.png", () {})
                          : SizedBox(),
                      (accountDetail.accountType == "Prepago" &&
                              accountDetail.totalDebt == 0.0)
                          ? option("Comprar Energia",
                              "vuesax-linear-trend-up.png", () {})
                          : SizedBox(),
                      (accountDetail.accountType == "Pospago PD")
                          ? option("Simular Factura",
                              "vuesax-linear-document-cloud.png", () {})
                          : SizedBox(),
                      (accountDetail.accountType != "Pago Extraordinario")
                          ? option(
                              "Historico de Cuenta", "vuesax-linear-note.png",
                              () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccountHistoryScreen(
                                            accountDetail: accountDetail,
                                          )));
                            })
                          : SizedBox(),
                      (accountDetail.accountType == "Pospago PD")
                          ? option("Registrar Lectura del Medidor",
                              "vuesax-linear-watch-status.png", () {})
                          : SizedBox()
                    ],
                  ),
                )
              ]),
            )),
    );
  }

  Widget option(String title, String icon, Function() function) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListTile(
          onTap: function,
          leading: ImageIcon(
            AssetImage("assets/icons/$icon"),
            color: Color(0xFF3A3D5F),
          ),
          title: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Color(0xFF3A3D5F),
                    fontSize: 14,
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Icon(Icons.keyboard_arrow_right)
            ],
          )),
    );
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

  Widget doubleRowData(String key, String value, String key2, String value2) {
    return Column(
      children: [
        const Divider(
          height: 22,
          color: Colors.black,
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
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
              Expanded(
                  child: Row(
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
              ))
            ],
          ),
        )
      ],
    );
  }
}
