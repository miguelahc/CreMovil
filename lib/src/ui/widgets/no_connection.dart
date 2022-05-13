import 'package:app_cre/src/ui/components/components.dart';
import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(top: 24),
        width: MediaQuery.of(context).size.width * 0.75,
        height: 150,
        decoration: customBoxDecoration(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 24),
              child: Text("¡Problemas de conexión!"),
            ),
            Padding(
              padding: EdgeInsets.only(left: 64, right: 64, bottom: 24),
              child: Text(
                "¡No hemos podido\nrecuperar tus datos!",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
  }

}