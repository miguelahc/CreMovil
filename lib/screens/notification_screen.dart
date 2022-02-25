import 'package:app_cre/models/notification.dart';
import 'package:app_cre/screens/notification_category_screen.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/widgets/item_option.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedPage = 0;
  late PageController _pageController;

  void changePage(int pageNumber) {
    setState(() {
      _selectedPage = pageNumber;
      _pageController.animateToPage(pageNumber,
          duration: Duration(milliseconds: 500),
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

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color(0XFFF7F7F7),
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notificaciones",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
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
            Expanded(
                child: PageView(
              onPageChanged: (page) {
                setState(() {
                  _selectedPage = page;
                });
              },
              controller: _pageController,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 16, left: 1, right: 1),
                    child: Column(
                      children: [
                        itemOption(
                            "Mantenimiento preventivo",
                            "calendar.png",
                            () => openNotificationCategory(
                                Notifications("Mantenimiento preventivo"))),
                        itemOption(
                            "Suspensión de servicio por mora",
                            "lamp-slash.png",
                            () => openNotificationCategory(Notifications(
                                "Suspensión de servicio por mora"))),
                        itemOption(
                            "Facturacion",
                            "vuesax-linear-clipboard-text.png",
                            () => openNotificationCategory(
                                Notifications("Facturacion"))),
                        itemOption(
                            "Relaciones públicas",
                            "vuesax-linear-people.png",
                            () => openNotificationCategory(
                                Notifications("Relaciones públicas"))),
                        itemOption(
                            "Servicio Técnico",
                            "vuesax-linear-judge.png",
                            () => openNotificationCategory(
                                Notifications("Servicio Técnico"))),
                        itemOption(
                            "Nueva conexión",
                            "vuesax-linear-lamp-charge-blue.png",
                            () => openNotificationCategory(
                                Notifications("Nueva conexión")))
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: Column(
                      children: [
                        itemOption("Asistencia social cooperativa",
                            "vuesax-linear-star.png", () => null),
                        itemOption(
                            "Medco", "vuesax-linear-story.png", () => null),
                        itemOption("Crece", "vuesax-linear-send-square.png",
                            () => null),
                      ],
                    )),
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
                ? Color(0XFF3A3D5F)
                : Color(0XFFF7F7F7),
            border: Border.all(color: Color(0XFF3A3D5F), width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.44,
        margin: EdgeInsets.only(top: 20),
        child: Text(
          title,
          style: TextStyle(
              color: selectedPage == pageNumber
                  ? Colors.white
                  : Color(0XFF3A3D5F)),
        ),
      ),
    );
  }
}
