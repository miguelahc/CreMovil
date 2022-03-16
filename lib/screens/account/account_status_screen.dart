import 'dart:convert';

import 'package:app_cre/models/models.dart';
import 'package:app_cre/screens/account/payments/payment_screen.dart';
import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountStatusScreen extends StatefulWidget {
  final AccountDetail account;

  const AccountStatusScreen(
      {Key? key,
      required this.account})
      : super(key: key);

  @override
  State<AccountStatusScreen> createState() => _AccountStatusScreenState();
}

class _AccountStatusScreenState extends State<AccountStatusScreen> {
  late AccountDetail accountDetail;
  bool onLoad = true;

  @override
  void initState() {
    accountDetail = widget.account;
    TokenService().readToken().then((token) {
      UserService().readUserData().then((data) {
        var userData = jsonDecode(data);
        AccountService()
            .getStatement(
                token, userData, accountDetail.accountNumber, accountDetail.companyNumber)
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
      accountDetail.titularName = message["TitularName"];
      accountDetail.address = message["Address"];
      accountDetail.state = message["StateAccount"];
      accountDetail.dist = message["DistrictCode"];
      accountDetail.secc = message["SectionCode"];
      accountDetail.totalDebt = message["TotalDebt"];
      accountDetail.accountHistory = message["estadocuenta"];
      onLoad = false;
    });
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
                Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.only(left: 16),
                    height: 60,
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
                                    style: TextStyle( fontFamily: 'Mulish', 
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFF3A3D5F),
                                        fontSize: 14),
                                  ),
                                  Text(
                                    accountDetail.accountNumber,
                                    style: const TextStyle( fontFamily: 'Mulish', 
                                        color: Color(0XFF999999), fontSize: 14),
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
                                          account: accountDetail,
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
                const CustomDivider(),
                accountDetail.totalDebt > 0.0
                    ? Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 110,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                              ),
                            ],
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
                                      style: TextStyle( fontFamily: 'Mulish', color: Colors.white),
                                    ),
                                    Text(
                                      "Total facturado: ",
                                      style: TextStyle( fontFamily: 'Mulish', 
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
                                        style: TextStyle( fontFamily: 'Mulish', color: Colors.white)),
                                    Text(
                                      accountDetail.totalDebt.toString(),
                                      style: const TextStyle( fontFamily: 'Mulish', 
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
                            padding: const EdgeInsets.only(left: 40),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Facturas impagas: ",
                                    style: TextStyle( fontFamily: 'Mulish', color: Colors.white)),
                                Text(accountDetail.numberInvoicesDue.toString(),
                                    style: const TextStyle( fontFamily: 'Mulish', 
                                        color: Color(0XFF82BA00),
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ))
                        ]),
                      )
                    : const SizedBox(
                        height: 8,
                      ),
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: const Text("Opciones",
                      style: TextStyle( fontFamily: 'Mulish', 
                          color: Color(0XFF82BA00),
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      (accountDetail.totalDebt > 0.0)
                          ? itemOption("Pagar Deuda", "money-send-pay.png", () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentScreen(
                                            accountDetail: accountDetail,
                                          )));
                            }, false)
                          : const SizedBox(),
                      (accountDetail.accountType == "Prepago" &&
                              accountDetail.totalDebt == 0.0)
                          ? itemOption("Comprar Energia",
                              "vuesax-linear-trend-up.png", () {}, false)
                          : const SizedBox(),
                      (permitAccount(AccountType.PD))
                          ? itemOption("Simular Factura",
                              "vuesax-linear-document-cloud.png", () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SimulateInvoiceScreen(
                                            accountDetail: accountDetail,
                                          )));
                            }, false)
                          : const SizedBox(),
                      (accountDetail.accountType != "Pago Extraordinario")
                          ? itemOption(
                              "Historico de Cuenta", "vuesax-linear-note.png",
                              () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccountHistoryScreen(
                                            accountDetail: accountDetail,
                                          )));
                            }, false)
                          : const SizedBox(),
                      (permitAccount(AccountType.PD))
                          ? itemOption("Registrar Lectura del Medidor",
                              "vuesax-linear-watch-status.png", () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterReadingScreen(
                                            accountDetail: accountDetail,
                                          )));
                            }, false)
                          : const SizedBox()
                    ],
                  ),
                )
              ]),
            )),
    );
  }

  bool permitAccount(AccountType accountType) {
    return accountDetail.accountType == accountType.toShortString();
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
                            style: const TextStyle( fontFamily: 'Mulish', 
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF3A3D5F),
                                fontSize: 14),
                          ),
                          Text(
                            value,
                            style: const TextStyle( fontFamily: 'Mulish', 
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

  Widget doubleRowData(String key, String value, String key2, String value2) {
    return Column(
      children: [
        const CustomDivider(),
        Container(
          padding: const EdgeInsets.only(left: 16),
          height: 40,
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Text(
                    key,
                    style: const TextStyle( fontFamily: 'Mulish', 
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value,
                    style:
                        const TextStyle( fontFamily: 'Mulish', color: Color(0XFF999999), fontSize: 14),
                  )
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Text(
                    key2,
                    style: const TextStyle( fontFamily: 'Mulish', 
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F),
                        fontSize: 14),
                  ),
                  Text(
                    value2,
                    style:
                        const TextStyle( fontFamily: 'Mulish', color: Color(0XFF999999), fontSize: 14),
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
