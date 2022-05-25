import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_cre/src/blocs/blocs.dart';

class PaymentsTable extends StatefulWidget {
  bool pay;
  List<PaymentDetail> data;

  PaymentsTable({Key? key, required this.pay, required this.data})
      : super(key: key);

  @override
  State<PaymentsTable> createState() => _PaymentsTableState();
}

class _PaymentsTableState extends State<PaymentsTable> {
  late bool _pay;

  @override
  void initState() {
    _pay = widget.pay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 4, right: 1.5, left: 1.5),
            height: 50,
            alignment: Alignment.center,
            decoration: customBoxDecoration(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Item",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Año",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Mes",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Monto",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3A3D5F)),
                  ),
                )),
                _pay
                    ? Expanded(
                        child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Pagar",
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3A3D5F)),
                        ),
                      ))
                    : const SizedBox()
              ],
            )),
        Column(children: widget.data.map((e) => row(e, context)).toList())
      ],
    );
  }

  Widget row(PaymentDetail data, context) {
    return data.isSelected || _pay
        ? Column(
            children: [
              Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              data.number.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF999999)),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              data.year.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF999999)),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              data.mount.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF999999)),
                            ),
                          )),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    data.total.toString() + " Bs.",
                                    style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFF999999)),
                                  ))),
                          _pay
                              ? Expanded(
                                  child: Container(
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    child: SizedBox(
                                      width: Checkbox.width,
                                      height: Checkbox.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5,
                                              color: const Color(0XFF707070)),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor:
                                                Colors.transparent,
                                          ),
                                          child: Checkbox(
                                            value: data.isSelected,
                                            onChanged: (state) =>
                                                _changePayments(state, data),
                                            activeColor: Colors.transparent,
                                            checkColor: SecondaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                              : const SizedBox()
                        ],
                      ),
                    ],
                  )),
              const CustomDivider()
            ],
          )
        : const SizedBox();
  }

  _changePayments(bool? state, PaymentDetail data) {
    final paymentBloc = BlocProvider.of<PaymentBloc>(context);
    double lastTotalAmount = 0.0;
    int invoiceAccount = 0;
    if(state == null) return;
    setState(() {
      widget.data.forEach((paymentDetail) {
        if(state){
          if (paymentDetail.number <= data.number) {
            paymentDetail.isSelected = state;
          } else {
            paymentDetail.isSelected = false;
          }
          lastTotalAmount = data.accumulated;
          invoiceAccount = data.number;
        }
        else{
          if(paymentDetail.number >= data.number){
            paymentDetail.isSelected = state;
          }
          if(data.number - paymentDetail.number == 1){
            lastTotalAmount = paymentDetail.accumulated;
            invoiceAccount = paymentDetail.number;
          }
        }
      });
    });
    if (state) {
      paymentBloc.add(OnChangeTotalAmountEvent(data.accumulated));
      paymentBloc.add(OnChangeInvoiceCountEvent(data.number));
    } else {
      paymentBloc.add(OnChangeTotalAmountEvent(lastTotalAmount));
      paymentBloc.add(OnChangeInvoiceCountEvent(invoiceAccount));
    }
  }
}
