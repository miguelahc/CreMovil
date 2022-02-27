import 'package:app_cre/models/invoice_detail.dart';
import 'package:app_cre/screens/invoice_detail_screen.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<dynamic> data;
  const CustomTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            margin: const EdgeInsets.only(bottom: 4),
            height: 50,
            alignment: Alignment.center,
            decoration: customBoxDecoration(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 0,
                    child: Container(
                      child: const Text(
                        "Periodo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF3A3D5F)),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Consumo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3A3D5F)),
                        ),
                        Text(
                          "KWh",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3A3D5F)),
                        ),
                      ],
                    ))),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Importe",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3A3D5F)),
                        ),
                        Text(
                          "Bs.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3A3D5F)),
                        ),
                      ],
                    ))),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Fecha",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3A3D5F)),
                        ),
                        Text(
                          "Pago",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3A3D5F)),
                        ),
                      ],
                    ))),
              ],
            )),
        Expanded(
            child:
                ListView(children: data.map((e) => row(e, context)).toList()))
      ],
    ));
  }

  Widget row(data, context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InvoiceDetailScreen(
                            invoiceDetail: InvoiceDetail(
                                data["DocumentNumber"], data["CompanyNumber"]),
                          )));
            },
            child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                height: 40,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 0,
                            child: Container(
                              child: Text(
                                data["DateGestion"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF999999)),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                data["Valuekwh"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF999999)),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                data["TotalInvoice"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF999999)),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Text(
                                      data["DateInvoice"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0XFF999999)),
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ))),
                      ],
                    ),
                  ],
                ))),
        const CustomDivider()
      ],
    );
  }
}
