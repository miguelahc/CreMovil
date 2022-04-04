import 'package:app_cre/src/ui/components/colors.dart';
import 'package:flutter/material.dart';

class CustomDot extends StatefulWidget {
  int currentPage;
  int page;
  CustomDot({Key? key, required this.page, required this.currentPage})
      : super(key: key);

  @override
  State<CustomDot> createState() => _CustomDotState();
}

class _CustomDotState extends State<CustomDot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2.5, right: 2.5),
      height: 5,
      width: widget.currentPage == widget.page ? 30 : 5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2.5)),
        color: widget.currentPage == widget.page ? SecondaryColor : const Color(0XFFA39F9F),
      ),
    );
  }
}
