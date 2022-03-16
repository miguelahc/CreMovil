import 'package:app_cre/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration customBoxDecoration(double radius) {
  return BoxDecoration(
      boxShadow: customBoxShadow(),
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

BoxDecoration customButtonDecoration(double radius) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(radius), gradient: PrimaryGradient);
}

List<BoxShadow> customBoxShadow() {
  return [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      blurRadius: 6,
    ),
  ];
}
