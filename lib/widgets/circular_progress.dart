import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget circularProgress() {
  return const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF84BD00)),
    ),
  );
}
