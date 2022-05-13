import 'dart:convert';

import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedPage = 0;
  bool isLoad = true;
  late List<dynamic> notifications;
  late PageController _pageController;
  late Iterable<Category> serviceCategories;

  void changePage(int pageNumber) {
    setState(() {
      _selectedPage = pageNumber;
      _pageController.animateToPage(pageNumber,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  openNotificationCategory(Notifications notification) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotificationCategoryScreen(notification: notification)));
  }

  bool countNotificationNoRead(List notifications){
    List result = notifications.where((element) => element["leido"]=="NO").toList();
    return result.isNotEmpty ? true: false ;
  }

  @override
  void initState() {
    _pageController = PageController();
    TokenService().readToken().then((token) {
      UserService().readUserData().then((data) {
        var userData = jsonDecode(data);
        NotificationsService().getCategories(token, userData).then((value) {
          if (jsonDecode(value)["Code"] == 0) {
            var message = jsonDecode(value)["Message"];
            serviceCategories = NotificationsService()
                .parseToListCategories(jsonDecode(message));
            NotificationsService()
                .getNotifications(token, userData)
                .then((notificationsData) {
              notifications =
                  jsonDecode(jsonDecode(notificationsData)["Message"]);

              setState(() {
                isLoad = false;
              });
            });
          }
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color(0XFFF7F7F7),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Notificaciones",
                      style: TextStyle( fontFamily: 'Mulish', fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  IconButton(
                    color: const Color(0xFF84BD00),
                    icon:  const ImageIcon(
                        AssetImage(
                            "assets/icons/vuesax-linear-setting-2.png"),
                        color: DarkColor),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationSettingsScreen(serviceCategories: serviceCategories)));
                    },
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TabButtom(
                title: "De Servicio",
                pageNumber: 0,
                selectedPage: _selectedPage,
                onPressed: () {
                  changePage(0);
                },
              ),
              TabButtom(
                title: "Fundación CRE",
                pageNumber: 1,
                selectedPage: _selectedPage,
                onPressed: () {
                  changePage(1);
                },
              )
            ]),
            isLoad
                ? Padding(
                    padding: EdgeInsets.only(top: 36),
                    child: circularProgress())
                : Expanded(
                    child: PageView(
                    onPageChanged: (page) {
                      setState(() {
                        _selectedPage = page;
                      });
                    },
                    controller: _pageController,
                    children: [
                      ListView(
                        children: [
                          Container(
                              padding:
                              const EdgeInsets.only(top: 16, left: 1, right: 1),
                              child: Column(
                                  children: serviceCategories
                                      .map((e) => itemOptionWithImage(
                                      e.descriptionCategory,
                                      e.imageCategory,
                                          () => openNotificationCategory(
                                          Notifications(
                                              e.descriptionCategory,
                                              NotificationsService()
                                                  .filterOnlyCategory(
                                                  notifications,
                                                  e.numberCategory))),
                                      countNotificationNoRead(NotificationsService()
                                          .filterOnlyCategory(
                                          notifications,
                                          e.numberCategory))))
                                      .toList())),
                        ],
                      ),
                      ListView(
                        children: [
                          Container(
                              padding:
                              const EdgeInsets.only(top: 16, left: 8, right: 8),
                              child: Column(
                                children: [
                                  itemOption("Asistencia social cooperativa",
                                      "vuesax-linear-star.png", () => null, false),
                                  itemOption("Medco", "vuesax-linear-story.png",
                                          () => null, false),
                                  itemOption("Crece",
                                      "vuesax-linear-send-square.png", () => null, false),
                                ],
                              )),
                        ],
                      )
                    ],
                  ))
          ]),
    ));
  }
}

class TabButtom extends StatelessWidget {
  final String title;
  final int pageNumber;
  final int selectedPage;
  final Function() onPressed;

  const TabButtom(
      {Key? key,
      required this.title,
      required this.pageNumber,
      required this.selectedPage,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: selectedPage == pageNumber
                ? const Color(0XFF3A3D5F)
                : const Color(0XFFF7F7F7),
            border: Border.all(color: const Color(0XFF3A3D5F), width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.44,
        margin: const EdgeInsets.only(top: 20),
        child: Text(
          title,
          style: TextStyle( fontFamily: 'Mulish', 
              color: selectedPage == pageNumber
                  ? Colors.white
                  : const Color(0XFF3A3D5F)),
        ),
      ),
    );
  }
}
