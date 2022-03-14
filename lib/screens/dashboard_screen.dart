import 'dart:convert';

import 'package:app_cre/models/models.dart';
import 'package:app_cre/providers/conection_status.dart';
import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectionStatus()),
      ],
      child: Consumer<ConnectionStatus>(
          builder: (_, model, __) => Content(status: model)),
      // child: const LoginScreen(),
    );
  }
}

class Content extends StatefulWidget {
  ConnectionStatus status;

  Content({Key? key, required this.status}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Content();
}

class _Content extends State<Content> {
  var accounts = [];
  var services = [];
  bool onLoad = true;
  bool onLoadDialog = false;

  @override
  void initState() {
    super.initState();
    print(widget.status.isOnline);
    TokenService().readToken().then((token) {
      UserService().readUserData().then((data) {
        var userData = jsonDecode(data);
        AccountService()
            .getAccounts(token, userData["Pin"], userData["PhoneNumber"],
                userData["PhoneImei"])
            .then((value) {
          var data = jsonDecode(value)["Message"];
          Iterable<dynamic> all = jsonDecode(data);
          setState(() {
            accounts = all
                .where((element) => element["AccountTypeRegister"] == "Cuenta")
                .toList();
            services = all
                .where(
                    (element) => element["AccountTypeRegister"] == "Servicio")
                .toList();
            onLoad = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(children: [
          const _CajaSuperiorDatos(),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                MaterialButton(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    disabledColor: Colors.black87,
                    elevation: 0,
                    child: Container(
                        constraints:
                            const BoxConstraints(minWidth: 100, maxHeight: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0XFF618A02),
                              Color(0XFF84BD00)
                            ])),
                        child: Row(
                          children: const [
                            ImageIcon(
                              AssetImage(
                                  'assets/icons/vuesax-linear-add-square.png'),
                              color: Colors.white,
                            ),
                            Text(
                              'Registrar',
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                          ],
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterAccountSession()));
                    })
              ])
            ]),
          ),
          widget.status.isOnline
              ? onLoad
                  ? circularProgress()
                  : Expanded(
                      child: ListView(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Codigos Fijos",
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      color: Color(0XFF3A3D5F)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                // i
                                Column(
                                  children: accounts
                                      .map((e) => item(context, e))
                                      .toList(),
                                ),
                                services.isEmpty
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          const Text(
                                            "Servicios",
                                            style: TextStyle(
                                                fontFamily: 'Mulish',
                                                color: Color(0XFF3A3D5F)),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          // i
                                          Column(
                                            children: services
                                                .map((e) => item(context, e))
                                                .toList(),
                                          ),
                                        ],
                                      )
                              ],
                            ))
                      ],
                    ))
              : Container(
            margin: const EdgeInsets.only(top: 24),
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 100,
                  decoration: customBoxDecoration(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 64, right: 64, bottom: 24, top: 32),
                        child: Text(
                          "¡No hemos podido\nrecuperar tus datos!",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
        ]));
  }

  Widget item(context, data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 52,
      decoration: BoxDecoration(
          boxShadow: customBoxShadow(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: PrimaryGradient),
      child: Row(children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      AccountDetail account = AccountDetail();
                      account.accountNumber = data["AccountNumber"];
                      account.companyNumber = data["CompanyNumber"];
                      account.numberInvoicesDue = data["NumberInvoicesDue"];
                      account.dateLastReading = data["DateLastReading"];
                      account.lastReading = data["LastReading"];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AccountStatusScreen(account: account)));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width - 32,
                      child: Row(children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, right: 16),
                          child: ImageIcon(
                            AssetImage(
                                'assets/icons/vuesax-linear-keyboard-open-blue.png'),
                            color: Color(0XFF3A3D5F),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Nro.",
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Color(0XFF393D5E),
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(data["AccountNumber"],
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0XFF999999)))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Referencia",
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0XFF393D5E),
                                      fontWeight: FontWeight.w500)),
                              Text(data["AliasName"],
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0XFF999999)))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Deuda",
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0XFF393D5E),
                                      fontWeight: FontWeight.w500)),
                              Text("Bs. " + data["AmountDebt"].toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0XFF999999)))
                            ],
                          ),
                        ),
                        data["AmountDebt"] == 0.0
                            ? const SizedBox(width: 70)
                            : MaterialButton(
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                disabledColor: Colors.black87,
                                elevation: 0,
                                child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 60, maxHeight: 30),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const LinearGradient(colors: [
                                          Color(0XFF618A02),
                                          Color(0XFF84BD00)
                                        ])),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Pagar',
                                          style: TextStyle(
                                              fontFamily: 'Mulish',
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )),
                                onPressed: () {}),
                        const ImageIcon(
                          AssetImage('assets/icons/vuesax-linear-more.png'),
                          color: Colors.black,
                        ),
                      ]),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        AccountDetail accountDetail = AccountDetail();
                        accountDetail.accountNumber = data["AccountNumber"];
                        accountDetail.companyNumber = data["CompanyNumber"];
                        accountDetail.aliasName = data["AliasName"];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditReferenceScreen(
                                      account: accountDetail,
                                    )));
                      },
                      icon: const ImageIcon(
                        AssetImage('assets/icons/vuesax-linear-edit-white.png'),
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {
                        AccountDetail accountDetail = AccountDetail();
                        accountDetail.accountNumber = data["AccountNumber"];
                        accountDetail.companyNumber = data["CompanyNumber"];
                        accountDetail.aliasName = data["AliasName"];
                        _showDialogConfirm(context, accountDetail);
                      },
                      icon: const ImageIcon(
                        AssetImage('assets/icons/vuesax-linear-trash.png'),
                        color: Colors.black,
                      )),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

  _showDialogExit(context, AccountDetail accountDetail) {
    var aliasName = accountDetail.aliasName;
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Text(
          'El registro $aliasName\nse ha eliminado',
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
          textAlign: TextAlign.center,
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
                      'Aceptar',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "home");
                  })),
        ],
      ),
    );
  }

  _showDialogConfirm(context, AccountDetail accountDetail) {
    var aliasName = accountDetail.aliasName;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Text(
          '¿Está seguro que desea\neliminar $aliasName \nde la Aplicación Móvil?',
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                            minWidth: MediaQuery.of(context).size.width * 0.25,
                            maxWidth: MediaQuery.of(context).size.width * 0.25,
                            maxHeight: 50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0XFF618A02),
                              Color(0XFF84BD00)
                            ])),
                        child: onLoadDialog
                            ? circularProgress()
                            : const Text(
                                'Eliminar',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                      ),
                      onPressed: () {
                        setState(() {
                          onLoadDialog = true;
                        });
                        TokenService().readToken().then((token) {
                          UserService().readUserData().then((data) {
                            var userData = jsonDecode(data);
                            AccountService()
                                .disableAccount(
                                    token,
                                    userData,
                                    accountDetail.accountNumber,
                                    accountDetail.companyNumber)
                                .then((value) {
                              print(jsonDecode(value));
                              setState(() {
                                onLoadDialog = false;
                              });
                              Navigator.pop(context);
                              _showDialogExit(context, accountDetail);
                            });
                          });
                        });
                      })),
              const SizedBox(
                width: 15,
              ),
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
                            minWidth: MediaQuery.of(context).size.width * 0.25,
                            maxWidth: MediaQuery.of(context).size.width * 0.25,
                            maxHeight: 50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color(0XFF3A3D5F), width: 1.5),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              color: Color(0XFF3A3D5F),
                              fontSize: 16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
            ],
          )
        ],
      ),
    );
  }
}

class _CajaSuperiorDatos extends StatefulWidget {
  const _CajaSuperiorDatos({Key? key}) : super(key: key);

  @override
  State<_CajaSuperiorDatos> createState() => __CajaSuperiorDatosState();
}

class __CajaSuperiorDatosState extends State<_CajaSuperiorDatos> {
  String name = "";

  @override
  void initState() {
    super.initState();
    UserService().readUserData().then((data) {
      var userData = jsonDecode(data);
      setState(() {
        name = userData["Name"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // alignment: Alignment.topCenter,
      children: [
        perfilUsuario(context),
      ],
    );
  }

  Container perfilUsuario(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.96,
      height: 100,
      margin: const EdgeInsets.only(left: 8, top: 8),
      decoration: customBoxDecoration(10),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DottedBorder(
              padding: const EdgeInsets.all(2),
              borderType: BorderType.Circle,
              dashPattern: const [6, 3, 6, 3, 6, 3],
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 13,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 10,
                  backgroundImage: const AssetImage('assets/foto.png'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Hola, $name",
                          style: const TextStyle(
                              color: Color(0XFF3A3D5F),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Display')),
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            color: const Color(0xFF84BD00),
                            iconSize: 24,
                            icon: const ImageIcon(
                              AssetImage('assets/icons/vuesax-linear-edit.png'),
                              color: Color(0XFF84BD00),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(currentPage: 2)));
                            },
                          ))
                    ],
                  ),
                  const Text("miguel.cre@gmail.com",
                      style: TextStyle(
                          color: Color(0XFFA39F9F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display'))
                ],
              ),
            ),
            const DidYouKnow(),
          ],
        ),
      ),
    );
  }
}

class DidYouKnow extends StatelessWidget {
  const DidYouKnow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.22,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 10)),
            color: const Color(0XFFF7F7F7),
            boxShadow: customBoxShadow()),
        child: Column(
          children: [
            IconButton(
              color: const Color(0xFF84BD00),
              icon: const ImageIcon(
                AssetImage('assets/icons/vuesax-linear-lamp-charge.png'),
                color: Color(0XFF84BD00),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DidYouKnowScreen()));
              },
            ),
            const Text(
              " ¿Sabías que?",
              style: TextStyle(
                  fontFamily: 'Mulish', color: Color(0XFF3A3D5F), fontSize: 12),
            )
          ],
        ));
  }
}
