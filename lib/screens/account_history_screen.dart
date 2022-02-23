import 'package:app_cre/models/models.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountHistoryScreen extends StatefulWidget {
  final AccountDetail accountDetail;
  AccountHistoryScreen({Key? key, required this.accountDetail})
      : super(key: key);

  @override
  State<AccountHistoryScreen> createState() => _AccountHistoryScreenState();
}

class _AccountHistoryScreenState extends State<AccountHistoryScreen> {
  late AccountDetail accountDetail;

  @override
  void initState() {
    accountDetail = widget.accountDetail;
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
            child: const Text("Histórico de Cuenta",
                style: TextStyle(
                    color: Color(0XFF82BA00), fontWeight: FontWeight.bold)),
          ),
          Container(
              padding: EdgeInsets.only(left: 16),
              height: 60,
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
                                  color: const Color(0XFF999999), fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              )),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
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
                borderRadius: BorderRadius.all(Radius.circular(10))),
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
                height: 0,
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
          ),
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Text("Facturas:",
                style: TextStyle(
                    color: Color(0XFF3A3D5F), fontWeight: FontWeight.normal)),
          ),
          Expanded(child: CustomTable(data: accountDetail.accountHistory))
        ]),
      )),
    );
  }
}
