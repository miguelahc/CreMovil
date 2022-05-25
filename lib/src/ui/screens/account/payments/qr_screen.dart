import 'package:app_cre/src/ui/components/components.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class QrScreen extends StatefulWidget {
  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  Path customPath = Path()
    ..moveTo(0, 50)
    ..lineTo(0, 0)
    ..moveTo(0, 0)
    ..lineTo(50, 0)
    ..moveTo(122, 0)
    ..lineTo(172, 0)
    ..moveTo(172, 0)
    ..lineTo(172, 50)
    ..moveTo(172, 122)
    ..lineTo(172, 172)
    ..moveTo(172, 172)
    ..lineTo(122, 172)
    ..moveTo(50, 172)
    ..lineTo(0, 172)
    ..moveTo(0, 172)
    ..lineTo(0, 122)
  ;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 12, left: 2, right: 2),
              height: 40,
              padding: const EdgeInsets.only(top: 8),
              child: const Text(
                "Descarga el Código QR y sigue las instrucciones:",
                style: TextStyle(fontWeight: FontWeight.bold, color: DarkColor),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width:35),
              Container(
                width: 172, height: 172,
                margin: const EdgeInsets.only(left: 8,right: 8, bottom: 16),
                color: Colors.white,
                alignment: Alignment.center,
                child: DottedBorder(
                  customPath: (size) => customPath,
                  borderType: BorderType.RRect,
                  color: SecondaryColor,
                  dashPattern: const [100],
                  child: Container(width: 170, height: 170,),
                ),
              ),
              Container(
                width: 35,
                height: 35,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: SecondaryColor
                ),
                child: IconButton(
                  onPressed: (){},
                  icon: const ImageIcon(
                    AssetImage('assets/icons/vuesax-linear-direct-inbox.png'),
                    color: Colors.white,
                    size: 24,
                  ),
                )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 150,
                padding: const EdgeInsets.only(bottom: 8),
                margin: const EdgeInsets.only(left: 2),
                decoration: customBoxDecoration(10),
                child: Column(
                  children: [
                    instruction(context, 1, "Abre la App de tu Banco"),
                    instruction(context, 2, "Selecciona Pago Simple QR"),
                    instruction(context, 3, "Elige la Opción Pagar"),
                    instruction(context, 4, "Escanea el Código QR"),
                    instruction(context, 5, "Confirma el Pago"),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 2),
                decoration: customBoxDecoration(10),
                width: MediaQuery.of(context).size.width * 0.33,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // circularProgress(),
                    const SizedBox(height: 12),
                    const SizedBox(
                      width: 85,
                      child: Text("Esperando confirmación del Pago...",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF666666))),
                    ),
                  ],
                )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget instruction(context, int number, String description) {
    return Container(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                boxShadow: customBoxShadow(),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: DarkColor),
            child: Text(
              number.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Expanded(
              child: Text(
            description,
            style: const TextStyle(color: Color(0xFF666666)),
          ))
        ],
      ),
    );
  }
}
