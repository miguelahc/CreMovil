import 'package:app_cre/services/services.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationCategoryScreen extends StatefulWidget {
  NotificationCategoryScreen({Key? key}) : super(key: key);

  @override
  State<NotificationCategoryScreen> createState() =>
      _NotificationCategoryScreenState();
}

class _NotificationCategoryScreenState
    extends State<NotificationCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: Text("Notification"));
  }
}
