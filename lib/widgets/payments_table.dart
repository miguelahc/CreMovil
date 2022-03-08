import 'package:app_cre/models/invoice_detail.dart';
import 'package:app_cre/screens/account/invoice_detail_screen.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentsTable extends StatefulWidget {
  bool pay;

  PaymentsTable({Key? key, required this.pay}) : super(key: key);

  @override
  State<PaymentsTable> createState() => _PaymentsTableState();
}

class _PaymentsTableState extends State<PaymentsTable> {
  bool _active = true;
  late bool _pay;

  @override
  void initState() {
    _pay = widget.pay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<dynamic> data = [{"item":"1","anho":"2022", "mount":"01", "cant":"18.30"}, {"item":"2","anho":"2021", "mount":"12", "cant":"8.30"}, {"item":"1","anho":"2022", "mount":"01", "cant":"18.30"}];
    return Container(
        child: Column(
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
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF3A3D5F)),
                            ),
                          ))
                        : const SizedBox()
                  ],
                )),
            Column(children: data.map((e) => row(e, context)).toList())
          ],
        ));
  }

  Widget row(data, context) {
    return Column(
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
                            data["item"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF999999)),
                          ),
                        )),
                    Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            data["anho"].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF999999)),
                          ),
                        )),
                    Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            data["mount"].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF999999)),
                          ),
                        )),
                    Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              data["cant"]+" Bs.",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF999999)),
                            ))),
                    _pay
                      ?Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Radio<bool>(
                            visualDensity: VisualDensity.compact,
                            activeColor: SecondaryColor,
                            value: _active,
                            groupValue: _active,
                            onChanged: (bool? value) {
                              setState(() {
                                print(value);
                                _active = value!;
                              });
                            },
                          ),
                        )
                      )
                      : const SizedBox()
                  ],
                ),
              ],
            )),
        const CustomDivider()
      ],
    );
  }
}
