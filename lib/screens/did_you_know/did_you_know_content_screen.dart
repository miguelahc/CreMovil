import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DidYouKnowContentScreen extends StatefulWidget {
  const DidYouKnowContentScreen({Key? key}) : super(key: key);

  @override
  State<DidYouKnowContentScreen> createState() =>
      _DidYouKnowContentScreenState();
}

class _DidYouKnowContentScreenState extends State<DidYouKnowContentScreen> {
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
                                child: Row(
                                  children: const [
                                    Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: ImageIcon(
                                          AssetImage(
                                              'assets/icons/vuesax-linear-lamp-on.png'),
                                          color: SecondaryColor,
                                          size: 40,
                                        )),
                                    Expanded(
                                        child: Text(
                                      "Ahora puedes pagar tus facturas en línea desde nuestra app CRE Móvil",
                                      style: TextStyle(
                                          color: DarkColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ))
                                  ],
                                )),
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
                                    "Para pagar tu factura en línea realiza estos 3 simples pasos::",
                                    style: TextStyle(color: Color(0XFF666666)),
                                  ),
                                  item(1,
                                      "En la pantalla principal elige el Servicio que tiene activo el botón PAGAR y presionalo"),
                                  item(2,
                                      "Presiona la opción Pagar con Tarjeta C/D"),
                                  item(3,
                                      "Ingresa los datos de tu Tarjeta de Crédito o Débito y luego presiona en Pagar"),
                                ],
                              ),
                            )
                          ],
                        ))
                      ])))
            ]))));
  }

  Widget item(int i, String data) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(
                color: DarkColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: Text(
              i.toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: Text(
            data,
            style: TextStyle(color: Color(0XFF666666)),
          ))
        ],
      ),
    );
  }
}
