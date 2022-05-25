import 'package:flutter/material.dart';

AppBar appBar(context, bool withLeading) {
  if (withLeading) {
    return AppBar(
      leading: IconButton(
        color: const Color(0xFF84BD00),
        icon: const Icon(Icons.keyboard_arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      iconTheme: const IconThemeData(color: Colors.green),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.green),
    elevation: 0,
    backgroundColor: Colors.transparent,
  );
}
