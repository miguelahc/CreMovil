import 'package:app_cre/models/notification.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationContentScreen extends StatefulWidget {
  Notifications notification;
  NotificationContentScreen({Key? key, required this.notification})
      : super(key: key);

  @override
  State<NotificationContentScreen> createState() =>
      _NotificationContentScreenState();
}

class _NotificationContentScreenState extends State<NotificationContentScreen> {
  late Notifications notification;

  @override
  void initState() {
    notification = widget.notification;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0XFFF7F7F7),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                padding: const EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: customBoxDecoration(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Notificaciones",
                        style: TextStyle(fontSize: 18, color: DarkColor),
                      ),
                      Text(notification.category,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0XFF666666),
                              fontWeight: FontWeight.bold))
                    ]),
              ),
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        "Enviado 02 de ene. 2022",
                        style:
                            TextStyle(color: Color(0XFF666666), fontSize: 12),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Titulo de la notificacion",
                        style: TextStyle(
                            color: DarkColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Ya está disponibles su factura de consumo correspondiente al periodo 25 de dic. 2021 hasta el 01 de ene. 2022.",
                        style: TextStyle(
                          color: Color(0XFF666666),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.only(left: 16),
                        height: 50,
                        alignment: Alignment.center,
                        decoration: customBoxDecoration(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            ImageIcon(
                              AssetImage(
                                  'assets/icons/vuesax-linear-keyboard-open-blue.png'),
                              color:  Color(0XFF3A3D5F),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Alias Name",
                              style: TextStyle(
                                  color: Color(0XFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mulish"),
                            ),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.only(left: 16),
                        height: 50,
                        alignment: Alignment.center,
                        decoration: customBoxDecoration(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            ImageIcon(
                              AssetImage(
                                  'assets/icons/vuesax-linear-barcode.png'),
                              color: Color(0XFF3A3D5F),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Código Fijo: ",
                              style: TextStyle(
                                  color: DarkColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mulish"),
                            ),
                            Text(
                              "584695",
                              style: TextStyle(
                                  color: Color(0XFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mulish"),
                            ),
                          ],
                        )),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
