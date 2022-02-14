import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments ?? 'No Data';
    return Scaffold(
      body: Center(
        child: Text(
          '$args',
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
