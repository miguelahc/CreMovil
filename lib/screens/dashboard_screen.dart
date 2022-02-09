import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              // width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/cara-feliz.png'),
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      "Hola Alvaro Polo",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF84BD00)),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            )
          ],
        ));
  }
}
