import 'dart:collection';
import 'dart:convert';

import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Map<int, List<dynamic>> hashNotification = HashMap();

  @override
  void initState() {
    notification = widget.notification;
    final notificationBloc = BlocProvider.of<NotificationBloc>(context);
    notification.notifications = notificationBloc
            .state.notifications[notification.category.numberCategory] ??
        [];
    notification.noRead = notificationBloc.state.categories[notification.category] ?? 0;
    setState(() {
      notification.notifications.forEach((notification) {
        int key = notification["nucuen"];
        if (!hashNotification.containsKey(key)) {
          List<dynamic> listTemp = List.empty(growable: true);
          listTemp.add(notification);
          hashNotification.addAll({notification["nucuen"] as int: listTemp});
        } else {
          List? listTemp = hashNotification[notification["nucuen"]];
          if (listTemp != null) {
            listTemp.add(notification);
            hashNotification.addAll({notification["nucuen"] as int: listTemp});
          }
        }
      });
    });
    super.initState();
  }

  openNotificationContent(Notifications notification, dynamic item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationContentScreen(
                notification: notification, item: item))).then((value) {
      var idNotification = item["idnoti"];
      TokenService().readToken().then((token) {
        UserService().readUserData().then((data) {
          var userData = jsonDecode(data);
          NotificationsService()
              .notificationsRead(token, userData, idNotification);
        });
      });
    });
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
                padding: const EdgeInsets.only(left: 16, right: 16),
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: customBoxDecoration(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            child: const Text(
                              "Notificaciones",
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 18,
                                  color: DarkColor),
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            child: const Text(" | ",
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 18,
                                    color: DarkColor)),
                            alignment: Alignment.center,
                          ),
                          Container(
                            child: Text(
                                notification.category.descriptionCategory,
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 18,
                                    color: DarkColor)),
                            alignment: Alignment.center,
                          )
                        ],
                      ))
                    ]),
              ),
              notification.noRead == 0
                  ? const SizedBox(height: 8,)
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
                                    style: TextStyle(
                                        fontFamily: 'Mulish',
                                        color: Colors.white,
                                        fontSize: 12),
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
                                          style: TextStyle(
                                              fontFamily: 'Mulish',
                                              color: Color(0XFF3A3D5F)),
                                        )
                                      ],
                                    )))
                          ]
                        : hashNotification.entries
                            .map((e) => section(
                                context, e.key, e.value[0]["noalia"], e.value))
                            .toList()),
              ))
            ],
          ),
        ));
  }

  Widget section(context, int code, String alias, List<dynamic> list) {
    return Container(
      height: list.length >= 6 ? 275 : list.length * 40 + 40,
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 12),
                  child: ImageIcon(
                    AssetImage(
                        'assets/icons/vuesax-linear-keyboard-open-blue.png'),
                    color: Color(0XFF3A3D5F),
                  ),
                ),
                const Text(
                  "Código fijo: ",
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF3A3D5F),
                      fontSize: 14),
                ),
                Text(
                  code.toString(),
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0XFF666666),
                      fontSize: 14),
                ),
                const Text(
                  " | ",
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0XFF666666),
                      fontSize: 14),
                ),
                Text(
                  alias,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0XFF666666),
                      fontSize: 14),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.all(1),
                decoration: customBoxDecoration(10),
                child: ListView(
                    children: list
                        .map((e) => item(e, e["leido"] == "SI" ? false : true,
                            list.indexOf(e), list.length))
                        .toList())),
          )
        ],
      ),
    );
  }

  Widget item(dynamic notificationItem, bool tick, int index, int length) {
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
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  color: tick
                                      ? DarkColor
                                      : const Color(0XFF999999),
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
        index == length - 1 ? const SizedBox() : const CustomDivider()
      ],
    );
  }
}
