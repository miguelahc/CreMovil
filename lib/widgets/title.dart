import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {

  String title;
  List<String> subtitle;

  CustomTitle({Key? key, required this.title, required this.subtitle}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.24,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF84BD00)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Column(children: subtitle.map((e) => _SubTitle(e)).toList())
            ],
          ),
        ));
  }

  Widget _SubTitle(String subtitle){
    return Text(
      subtitle,
      style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.normal),
      textAlign: TextAlign.center,
    );
  }
}
