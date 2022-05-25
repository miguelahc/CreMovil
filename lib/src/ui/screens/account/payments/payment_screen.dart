import 'package:app_cre/src/blocs/payment/payment_bloc.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/ui/screens/account/payments/qr_screen.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late PageController _pageController;
  int _currentPage = 0;
  int methodSelected = 1;
  final int paymentId = 1;
  late Payment payment;
  bool loadPayments = true;
  List<PaymentDetail> listDetail = List.empty(growable: true);
  List<PaymentMethod> listPaymentMethods = List.empty(growable: true);

  @override
  void initState() {
    final paymentBloc = BlocProvider.of<PaymentBloc>(context);
    paymentBloc.add(const OnInitStatePaymentEvent());
    accountDetail = widget.accountDetail;
    _pageController = PageController();
    getPaymentTypes(int.parse(accountDetail.accountNumber));
    getPaymentMethods();
    super.initState();
  }

  getPaymentTypes(int accountNumber) async {
    payment = await PaymentService().getPaymentTypes(accountNumber) ??
        Payment(-1, -1, -1, -1);
    setState(() {
      loadPayments = false;
    });
    if (payment.monthlyBill != -1) {
      var list =
          await PaymentService().getPaymentDetail(payment.monthlyBill, 1) ?? [];
      setState(() {
        listDetail = list;
      });
    }
  }

  getPaymentMethods() async {
    List<PaymentMethod> list = await PaymentService().getPaymentMethods() ?? [];
    if (list.isNotEmpty) {
      setState(() {
        listPaymentMethods = list;
      });
    }
  }

  emitPayment() async {
    final paymentBloc = BlocProvider.of<PaymentBloc>(context);
    EmitPaymentDetail? emitPaymentDetail = await PaymentService().emitPayment(
        paymentId, methodSelected, accountDetail.accountNumber,
        accountDetail.companyNumber, paymentBloc.state.invoiceCount);
    if(emitPaymentDetail != null){
      print("Si se pudi burro");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0XFFF7F7F7),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(children: [
                  header(),
                  loadPayments
                      ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: circularProgress(),
                  )
                      : payment.monthlyBill != -1
                      ? Container(
                    padding:
                    const EdgeInsets.only(bottom: 4, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDot(page: 0, currentPage: _currentPage),
                        CustomDot(page: 1, currentPage: _currentPage),
                        CustomDot(page: 2, currentPage: _currentPage)
                      ],
                    ),
                  )
                      : SizedBox(),
                  pages(),
                  _currentPage == 2 && methodSelected == 1
                      ? SizedBox()
                      : actions()
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
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF3A3D5F),
                                    fontSize: 14),
                              ),
                              Text(
                                accountDetail.accountNumber,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    color: Color(0XFF999999),
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
        rowData("Direccion: ", accountDetail.address),
        const CustomDivider(),
      ],
    );
  }

  Widget pages() {
    return loadPayments
        ? const SizedBox()
        : payment.monthlyBill != -1
        ? Expanded(
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
                        padding:
                        const EdgeInsets.only(top: 8, bottom: 16),
                        child: const Text(
                          "Selecciona las Facturas a Pagar",
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              color: SecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      PaymentsTable(pay: true, data: listDetail),
                      paymentSummary(),
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
                        padding:
                        const EdgeInsets.only(top: 8, bottom: 16),
                        child: const Text(
                          "Selecciona el Método de Pago",
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              color: SecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      ...listPaymentMethods.map((method) =>
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
                                      child: Text(
                                        method.description,
                                        style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            color: Color(0XFF666666)),
                                      )),
                                  Radio<int>(
                                      visualDensity: VisualDensity.compact,
                                      activeColor: SecondaryColor,
                                      value: method.id,
                                      groupValue: methodSelected,
                                      onChanged: (int? value) =>
                                          setState(() {
                                            methodSelected = value!;
                                          })),
                                ],
                              ))),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16, top: 12, bottom: 8),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Facturas seleccionadas:",
                          style: TextStyle(
                              fontFamily: 'Mulish', color: DarkColor),
                        ),
                      ),
                      PaymentsTable(pay: false, data: listDetail),
                      paymentSummary(),
                    ],
                  ),
                )
              ],
            ),
            //page 3
            Column(
              children: [
                Expanded(
                    child: ListView(
                      children: [
                        paymentSummary(),
                        methodSelected == 1 ? QrScreen() : CreditScreen()
                      ],
                    ))
              ],
            )
          ],
        ))
        : const SizedBox();
  }

  Widget paymentSummary() {
    return BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
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
          SizedBox(
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
                          "Cantidad de facturas a pagar: ",
                          style:
                          TextStyle(fontFamily: 'Mulish', color: Colors.white),
                        ),
                        Text(
                          state.invoiceCount.toString(),
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              color: SecondaryColor,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ],
            ),
          ),
          Container(
            height: 1.5,
            color: Colors.white70,
          ),
          Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Monto Bs. ",
                        style:
                        TextStyle(fontFamily: 'Mulish', color: Colors.white)),
                    Text(state.totalAmount.toString(),
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            color: Color(0XFF82BA00),
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ))
        ]),
      );
    });
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
    return loadPayments
        ? const SizedBox()
        : payment.monthlyBill != -1
        ? Container(
        padding: const EdgeInsets.only(bottom: 16, top: 16),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: _currentPage != 0
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            _currentPage != 0
                ? MaterialButton(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                disabledColor: Colors.black87,
                elevation: 0,
                child: Container(
                  constraints: BoxConstraints(
                      minWidth:
                      MediaQuery
                          .of(context)
                          .size
                          .width * 0.4,
                      maxWidth:
                      MediaQuery
                          .of(context)
                          .size
                          .width * 0.4,
                      maxHeight: 50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: const Color(0XFF3A3D5F), width: 1.5),
                  ),
                  child: const Text(
                    'Anterior',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        color: DarkColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_currentPage != 0) {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                    setState(() {
                      _currentPage--;
                    });
                  }
                })
                : const SizedBox(),
            BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if (state.invoiceCount == 0) {
                    return const SizedBox();
                  }
                  return MaterialButton(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      disabledColor: Colors.black87,
                      elevation: 0,
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: _currentPage != 0
                                ? MediaQuery
                                .of(context)
                                .size
                                .width * 0.4
                                : MediaQuery
                                .of(context)
                                .size
                                .width * 0.75,
                            maxWidth: _currentPage != 0
                                ? MediaQuery
                                .of(context)
                                .size
                                .width * 0.4
                                : MediaQuery
                                .of(context)
                                .size
                                .width * 0.75,
                            maxHeight: 50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(colors: [
                              Color(0XFF618A02),
                              Color(0XFF84BD00)
                            ])),
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                        setState(() {
                          _currentPage++;
                        });
                        if (_currentPage == 2) {
                          emitPayment();
                        }
                      });
                })
          ],
        ))
        : const SizedBox();
  }
}
