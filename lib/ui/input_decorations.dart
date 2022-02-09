import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF84BD00)),
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF84BD00), width: 2)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF84BD00)),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFF84BD00))
            : null);
  }
}
