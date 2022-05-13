import 'dart:convert';

import 'package:app_cre/src/blocs/account/account_bloc.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/providers/conection_status.dart';
import 'package:app_cre/src/ui/screens/dashboard/user_data.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          builder: (_, model, __) => DashboardContent(status: model)),
    );
  }
}

class DashboardContent extends StatefulWidget {
  ConnectionStatus status;

  DashboardContent({Key? key, required this.status}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardContent();
}

class _DashboardContent extends State<DashboardContent> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const UserData(),
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
                        gradient: const LinearGradient(
                            colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
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
          ? BlocBuilder<AccountBloc, AccountState>(builder: (context, accountState) {
            final accountBloc = BlocProvider.of<AccountBloc>(context);
            if(accountState.all.isEmpty){
              accountBloc.getAccounts();
              return circularProgress();
            }
            return AccountsDisplay(context);
      })
          : NoConnection()
    ]);
  }

  Widget AccountsDisplay(context) {
    final accountBloc = BlocProvider.of<AccountBloc>(context);
    var accounts = accountBloc.state.accounts;
    var services = accountBloc.state.services;
    return Expanded(
        child: ListView(
      physics:
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                accounts.isEmpty && services.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 24),
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 150,
                          decoration: customBoxDecoration(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 32, bottom: 24),
                                child: Text(
                                    "¡No tienes ninguna cuenta registrada!"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 64, right: 64, bottom: 24),
                                child: Text(
                                  "Por favor realiza el registro\nde nuevos codigos fijos o servicios",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : accounts.isEmpty
                        ? SizedBox()
                        : Column(
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
                            ],
                          ),
                services.isEmpty
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Servicios",
                            style: TextStyle(
                                fontFamily: 'Mulish', color: Color(0XFF3A3D5F)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // i
                          Column(
                            children:
                                services.map((e) => item(context, e)).toList(),
                          ),
                        ],
                      )
              ],
            ))
      ],
    ));
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
                      account.accountType = data["AccountType"];
                      account.category = data["Category"];
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
                            ? const SizedBox(width: 90)
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
                                      children: [
                                        Badge(
                                          position: BadgePosition.topEnd(
                                              end: -15, top: -15),
                                          badgeContent: Text(
                                              data["NumberInvoicesDue"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                          child: const Text(
                                            'Pagar',
                                            style: TextStyle(
                                                fontFamily: 'Mulish',
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        )
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

  _showDialogConfirm(context, AccountDetail accountDetail) {
    var aliasName = accountDetail.aliasName;
    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            ConfirmDialog(aliasName: aliasName, accountDetail: accountDetail));
  }
}

class ConfirmDialog extends StatefulWidget {
  String aliasName;
  AccountDetail accountDetail;

  ConfirmDialog(
      {Key? key, required this.aliasName, required this.accountDetail})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfirmDialog();
}

class _ConfirmDialog extends State<ConfirmDialog> {
  bool onLoadDialog = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
      actionsPadding: const EdgeInsets.only(bottom: 30),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Text(
        "¿Está seguro que desea\neliminar " +
            widget.aliasName +
            " \nde la Aplicación Móvil?",
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
                          gradient: const LinearGradient(
                              colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
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
                    onPressed: () async {
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
                                  widget.accountDetail.accountNumber,
                                  widget.accountDetail.companyNumber)
                              .then((value) {
                            setState(() {
                              onLoadDialog = false;
                            });
                            Navigator.pop(context);
                            _showDialogExit(context, widget.accountDetail);
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
                    final accountBloc = BlocProvider.of<AccountBloc>(context);
                    accountBloc.reloadAccounts();
                    Navigator.pop(context);
                  })),
        ],
      ),
    );
  }
}




