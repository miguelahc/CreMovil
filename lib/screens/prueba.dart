import 'package:flutter/material.dart';

import '../widgets/login_background.dart';

class nameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            const LoginBackground(),
            Row(
              
            )
          ],
        ),
      ),
    );
  }
}
