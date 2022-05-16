import 'dart:typed_data';

import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/services/attention_payment_points_service.dart';
import 'package:app_cre/src/ui/views/map_view.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapNotificationDetail extends StatefulWidget {
  Notifications notification;

  MapNotificationDetail({Key? key, required this.notification})
      : super(key: key);

  @override
  State<MapNotificationDetail> createState() => _MapNotificationDetailState();
}

class _MapNotificationDetailState extends State<MapNotificationDetail> {

  Point point = Point(-1, -1, -1);
  PositionMobil positionMobil = PositionMobil("", -1, -1);
  Set<Marker> markers = Set();
  late BitmapDescriptor icon, iconCar;
  late LocationBloc locationBloc;

  @override
  void initState() {
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
    getPointToAccount();
    if(widget.notification.category.numberCategory == 5){
      getPositionMobil();
    }
    super.initState();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  getPositionMobil() async{
    getBytesFromAsset(
      'assets/icons/vuesax-linear-car.png',
      85,
    ).then((onValue) {
      iconCar = BitmapDescriptor.fromBytes(onValue);
    });
    positionMobil = await AttentionPaymentPointsService().getPositionMobil(widget.notification.code, widget.notification.companyNumber);
    setState(() {
      markers.add(Marker(
          markerId: MarkerId(positionMobil.description),
          position: LatLng(positionMobil.latitude, positionMobil.longitude),
          infoWindow: InfoWindow(
              title: positionMobil.description,
              onTap: () {
              }),
          icon: iconCar
      ));
    });
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
      'assets/icons/vuesax-bold-location-dark.png',
      85,
    ).then((onValue) {
      icon = BitmapDescriptor.fromBytes(onValue);
    });
    point = await AttentionPaymentPointsService().getPoint(widget.notification.id);
    setState(() {
      markers.add(Marker(
          markerId: MarkerId(widget.notification.id.toString()),
          position: LatLng(point.latitude, point.longitude),
          infoWindow: InfoWindow(
              title: widget.notification.alias,
              snippet: "Codigo fijo: "+ widget.notification.code.toString(),
              onTap: () {
              }),
          icon: icon
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 44, vertical: 8),
        height: 350,
        child: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            if (locationState.lastKnownLocation == null) {
              print(locationState.lastKnownLocation.toString());
              return circularProgress();
            }

            return BlocBuilder<MapBloc, MapState>(
              builder: (context, mapState) {
                Map<String, Polyline> polylines = Map.from(mapState.polylines);
                if (!mapState.showMyRoute) {
                  polylines.removeWhere((key, value) => key == 'myRoute');
                }
                return MapView(
                    initialLocation: locationState.lastKnownLocation!,
                    polylines: polylines.values.toSet(),
                    mapType: MapType.normal,
                    categoryMarker: -1,
                    markers: markers);
              },
            );
          },
        ));
  }
}
