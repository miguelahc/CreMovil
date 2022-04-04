import 'dart:convert';
import 'dart:typed_data';

import 'package:app_cre/src/models/notification.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationContentScreen extends StatefulWidget {
  Notifications notification;
  dynamic item;

  NotificationContentScreen(
      {Key? key, required this.notification, required this.item})
      : super(key: key);

  @override
  State<NotificationContentScreen> createState() =>
      _NotificationContentScreenState();
}

class _NotificationContentScreenState extends State<NotificationContentScreen> {
  late Notifications notification;
  var formatter = DateFormat('dd MMM, yyyy');
  bool loadImage = true;
  late Uint8List bytes;

  @override
  void initState() {
    notification = widget.notification;
    notification.alias = widget.item["noalia"];
    notification.code = widget.item["nucuen"].toString();
    notification.title = widget.item["dstitu"];
    notification.message = widget.item["dsmens"];
    notification.date = DateTime.parse(widget.item["fcnoti"]);
    notification.imageId = widget.item["idimag"] ?? -1;
    if (notification.imageId != -1) {
      TokenService().readToken().then((token) {
        UserService().readUserData().then((data) {
          var userData = jsonDecode(data);
          NotificationsService().getImageOfNotifications(
              token, userData, notification.imageId).then((images) {
                var message = jsonDecode(images)["Message"];
            var image = jsonDecode(message)[0];
            setState(() {
              loadImage = false;
              bytes =  const Base64Decoder().convert(image["dsimag"]);
            });
          });
        });
      });
    }
    else{
      setState(() {
        loadImage = false;
      });
    }
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 70,
                decoration: customBoxDecoration(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Notificaciones",
                        style: TextStyle( fontFamily: 'Mulish', fontSize: 18, color: DarkColor),
                      ),
                      Text(notification.category,
                          style: const TextStyle( fontFamily: 'Mulish', 
                              fontSize: 12,
                              color: Color(0XFF666666),
                              fontWeight: FontWeight.bold))
                    ]),
              ),
              Expanded(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.75,
                    alignment: Alignment.center,
                    child: ListView(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Enviado " +
                                formatter.format(notification.date).toString(),
                            style: const TextStyle( fontFamily: 'Mulish', 
                                color: Color(0XFF666666), fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            notification.title,
                            style: const TextStyle( fontFamily: 'Mulish', 
                                color: DarkColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            notification.message,
                            style: const TextStyle( fontFamily: 'Mulish', 
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
                              children: [
                                const ImageIcon(
                                  AssetImage(
                                      'assets/icons/vuesax-linear-keyboard-open-blue.png'),
                                  color: Color(0XFF3A3D5F),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  notification.alias,
                                  style: const TextStyle(
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
                              children: [
                                const ImageIcon(
                                  AssetImage(
                                      'assets/icons/vuesax-linear-barcode.png'),
                                  color: Color(0XFF3A3D5F),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                const Text(
                                  "Código Fijo: ",
                                  style: TextStyle(
                                      color: DarkColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Mulish"),
                                ),
                                Text(
                                  notification.code.toString(),
                                  style: const TextStyle(
                                      color: Color(0XFF666666),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Mulish"),
                                ),
                              ],
                            )),
                        notification.imageId != -1
                            ? Container(
                                height: 50,
                                decoration:
                                const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Stack(
                                  children: [
                                    loadImage
                                        ? circularProgress()
                                        : Image.memory(bytes, fit: BoxFit.cover,)
                                  ],
                                )
                              )
                            : const SizedBox()
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
