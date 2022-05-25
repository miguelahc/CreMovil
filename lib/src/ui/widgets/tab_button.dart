import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String title;
  final int pageNumber;
  final int selectedPage;
  final Function() onPressed;

  const TabButton(
      {Key? key,
        required this.title,
        required this.pageNumber,
        required this.selectedPage,
        required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: selectedPage == pageNumber
                ? const Color(0XFF3A3D5F)
                : const Color(0XFFF7F7F7),
            border: Border.all(color: const Color(0XFF3A3D5F), width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.44,
        margin: const EdgeInsets.only(top: 20),
        child: Text(
          title,
          style: TextStyle( fontFamily: 'Mulish',
              color: selectedPage == pageNumber
                  ? Colors.white
                  : const Color(0XFF3A3D5F)),
        ),
      ),
    );
  }
}