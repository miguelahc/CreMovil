import 'package:app_cre/models/notification.dart';
import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationCategoryScreen extends StatefulWidget {
  Notifications notification;

  NotificationCategoryScreen({Key? key, required this.notification})
      : super(key: key);

  @override
  State<NotificationCategoryScreen> createState() =>
      _NotificationCategoryScreenState();
}

class _NotificationCategoryScreenState
    extends State<NotificationCategoryScreen> {
  late Notifications notification;

  @override
  void initState() {
    notification = widget.notification;
    super.initState();
  }

  openNotificationContent(Notifications notification, dynamic item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotificationContentScreen(notification: notification, item: item)));
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
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
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
                        style: TextStyle( fontFamily: 'Mulish', fontSize: 18, color: DarkColor),
                      ),
                      Text(notification.category,
                          style: const TextStyle( fontFamily: 'Mulish', 
                              fontSize: 12,
                              color: Color(0XFF666666),
                              fontWeight: FontWeight.bold))
                    ]),
              ),
              notification.notifications.isEmpty
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 8),
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          disabledColor: Colors.black87,
                          elevation: 0,
                          child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 200, maxWidth: 200, maxHeight: 30),
                              alignment: Alignment.center,
                              decoration: customButtonDecoration(30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  ImageIcon(
                                    AssetImage(
                                        'assets/icons/vuesax-linear-clipboard-tick.png'),
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Marcar todas como leida',
                                    style: TextStyle( fontFamily: 'Mulish', 
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              )),
                          onPressed: () {}),
                    ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                    children: notification.notifications.isEmpty
                        ? [
                            Center(
                                child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.only(
                                        top: 32,
                                        bottom: 32,
                                        left: 32,
                                        right: 32),
                                    alignment: Alignment.center,
                                    decoration: customBoxDecoration(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "No existen notificaciones para visualizar",
                                          style: TextStyle( fontFamily: 'Mulish',
                                              color: Color(0XFF3A3D5F)),
                                        )
                                      ],
                                    )))
                          ]
                        : notification.notifications
                            .map((e) => item(e, e["leido"] == "SI"? false: true))
                            .toList()),
              ))
            ],
          ),
        ));
  }

  Widget item(dynamic notificationItem, bool tick) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            openNotificationContent(notification, notificationItem);
          },
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16, right: 16),
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                          children: [
                            Text(
                              notificationItem["dstitu"],
                              style: TextStyle( fontFamily: 'Mulish', 
                                  fontWeight: FontWeight.bold,
                                  color: tick
                                      ? const Color(0XFF3A3D5F)
                                      : const Color(0XFF666666),
                                  fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right)
                ],
              )),
        ),
        const CustomDivider(),
      ],
    );
  }
}
