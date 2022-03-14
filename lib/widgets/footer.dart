import 'package:app_cre/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {

  bool dark;
  Footer({Key? key, required this.dark}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ImageIcon(
              AssetImage('assets/icons/vuesax-linear-message-question.png'),
              color: SecondaryColor,
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  '¿No puedes ingresar?',
                  style: TextStyle( fontFamily: 'Mulish', 
                      fontSize: 12,
                      color: dark? Colors.white: DarkColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Comunícate con Soporte',
                  style: TextStyle( fontFamily: 'Mulish', 
                      fontSize: 12,
                      color: dark? Colors.white: DarkColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}