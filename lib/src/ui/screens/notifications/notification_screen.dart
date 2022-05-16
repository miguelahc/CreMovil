import 'dart:convert';

import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  IconButton(
                    color: const Color(0xFF84BD00),
                    icon: const ImageIcon(
                        AssetImage("assets/icons/vuesax-linear-setting-2.png"),
                        color: DarkColor),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationSettingsScreen()));
                    },
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TabButton(
                title: "De Servicio",
                pageNumber: 0,
                selectedPage: _selectedPage,
                onPressed: () {
                  changePage(0);
                },
              ),
              TabButton(
                title: "Fundación CRE",
                pageNumber: 1,
                selectedPage: _selectedPage,
                onPressed: () {
                  changePage(1);
                },
              )
            ]),
            BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
              if (state.categories.isEmpty) {
                return Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: circularProgress());
              }
              return Expanded(
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
                              children: state.categories.entries
                                  .map((category) => itemOptionWithImage(
                                    category.key.descriptionCategory,
                                    category.key.imageCategory,
                                      () => openNotificationCategory(
                                          Notifications(
                                              category.key)),
                                      category.value == 0 ? false: true))
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
                              itemOption(
                                  "Crece",
                                  "vuesax-linear-send-square.png",
                                  () => null,
                                  false),
                            ],
                          )),
                    ],
                  )
                ],
              ));
            })
          ]),
    ));
  }
}
