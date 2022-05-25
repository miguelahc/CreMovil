import 'package:app_cre/src/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_cre/src/ui/components/colors.dart';

class FloatingHomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: SecondaryColor,
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(currentPage: 1)));
      },
      child: const ImageIcon(
        AssetImage('assets/icons/vuesax-linear-home-2.png'),
        color: Colors.white,
      ),
    );
  }
}
