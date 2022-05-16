import 'dart:convert';
import 'dart:typed_data';

import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

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
  List<dynamic> images = List.empty(growable: true);
  late Uint8List bytes;
  Point point = Point(-1, -1, -1);
  Set<Marker> markers = Set();
  late BitmapDescriptor icon;

  @override
  void initState() {
    initializeNotification();
    getImage();
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    getPointToAccount();
    super.initState();
  }

  initializeNotification() {
    notification = widget.notification;
    notification.alias = widget.item["noalia"];
    notification.code = widget.item["nucuen"];
    notification.title = widget.item["dstitu"];
    notification.message = widget.item["dsmens"];
    notification.date = DateTime.parse(widget.item["fcnoti"]);
    notification.imageId = widget.item["idimag"] ?? -1;
    notification.id = widget.item["idnoti"];
    notification.companyNumber = widget.item["nucomp"];
    notification.havePosition = widget.item["opunirxy"] != "S" ? false : true;
  }

  getImage() {
    if (notification.imageId != -1) {
      TokenService().readToken().then((token) {
        UserService().readUserData().then((data) {
          var userData = jsonDecode(data);
          NotificationsService()
              .getImageOfNotifications(token, userData, notification.imageId)
              .then((images) {
            var message = jsonDecode(images)["Message"];
            var code = jsonDecode(images)["Code"];
            if (code == 0) {
              setState(() {
                this.images = jsonDecode(message);
                var image = jsonDecode(message)[0];
                loadImage = false;
                bytes = const Base64Decoder().convert(image["dsimag"]);
              });
            } else {
              setState(() {
                loadImage = false;
              });
            }
          });
        });
      });
    } else {
      setState(() {
        loadImage = false;
      });
    }
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getPointToAccount() async {
    getBytesFromAsset(
      'assets/icons/vuesax-bold-location.png',
      85,
    ).then((onValue) {
      icon = BitmapDescriptor.fromBytes(onValue);
    });
    point = await AttentionPaymentPointsService().getPoint(notification.id);
    setState(() {
      markers.add(Marker(
          markerId: MarkerId(notification.id.toString()),
          position: LatLng(point.latitude, point.longitude),
          infoWindow: InfoWindow(
              title: notification.alias,
              snippet: "Codigo fijo: " + notification.code.toString(),
              onTap: () {}),
          icon: icon));
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
                            child: Text(notification.category.descriptionCategory,
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
              Expanded(
                  child: ListView(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(horizontal: 44),
                    child: Text(
                      "Enviado " +
                          formatter.format(notification.date).toString(),
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          color: Color(0XFF666666),
                          fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 44),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      notification.title,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          color: DarkColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 44),
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      notification.message,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        color: Color(0XFF666666),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 44, vertical: 8),
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 44, vertical: 8),
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 44, vertical: 8),
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Stack(
                            children: [
                              loadImage
                                  ? circularProgress()
                                  : images.isEmpty
                                      ? const SizedBox()
                                      : Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        )
                            ],
                          ))
                      : const SizedBox(),
                  notification.category.numberCategory == 5
                      ? map()
                      : notification.havePosition
                          ? map()
                          : SizedBox()
                ],
              ))
            ],
          ),
        ));
  }

  Widget map() {
    return Container(
      height: 350,
      child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isAllGranted
              ? MapNotificationDetail(notification: notification)
              : const GpsAccessScreen();
        },
      ),
    );
  }
}
