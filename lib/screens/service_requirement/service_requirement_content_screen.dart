import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceRequirementContentScreen extends StatefulWidget {
  const ServiceRequirementContentScreen({Key? key}) : super(key: key);

  @override
  State<ServiceRequirementContentScreen> createState() =>
      _ServiceRequirementContentScreenState();
}

class _ServiceRequirementContentScreenState
    extends State<ServiceRequirementContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color(0XFFF7F7F7),
            child: SafeArea(
                child: Column(children: [
              Expanded(
                  child: Container(
                      color: const Color(0XFFF7F7F7),
                      child: Column(children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                  child: Image.asset(
                                    'assets/image_service.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(context);
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_left,
                                          color: Colors.white)),
                                )
                              ],
                            )),
                        Expanded(
                            child: ListView(
                          children: [
                            Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width - 32,
                              padding:
                                  const EdgeInsets.only(left: 16, right: 32),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(16),
                              decoration: customBoxDecoration(15),
                              child: const Text(
                                "Descuento a personas mayores a 60 años (Ley 1886)",
                                style: TextStyle(
                                    color: DarkColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Container(
                              decoration: customBoxDecoration(15),
                              width: MediaQuery.of(context).size.width - 32,
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Requisitos:",
                                    style: TextStyle(
                                        color: SecondaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  item(
                                      "1. Lorem Ipsum is simply dummy text of the printing and typesetting industry"),
                                  item(
                                      "2. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."),
                                  item(
                                      "3. Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical."),
                                  item(
                                      "4. There are many variations of passages of Lorem Ipsum available, but the majority"),
                                  item(
                                      "5. Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
                                ],
                              ),
                            )
                          ],
                        ))
                      ])))
            ]))));
  }

  Widget item(String data) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: Text(
          data,
          style: const TextStyle(color: Color(0XFF666666)),
        ));
  }
}
