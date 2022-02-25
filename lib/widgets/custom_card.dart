import 'package:app_cre/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  String title;
  LinearGradient gradient;
  Function() onTap;

  CustomCard(
      {Key? key,
      required this.title,
      required this.gradient,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: MediaQuery.of(context).size.width - 32,
          height: 170,
          decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.asset(
                'assets/image_service.png',
                width: MediaQuery.of(context).size.width - 32,
                height: 112,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(left: 24),
                          child: Text(
                            title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                        const Padding(
                          padding: EdgeInsets.only(left: 24, right: 16),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )))
          ]),
        ));
  }
}
