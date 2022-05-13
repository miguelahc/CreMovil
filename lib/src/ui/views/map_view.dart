import 'dart:async';
import 'dart:typed_data';

import 'package:app_cre/src/blocs/map/map_bloc.dart';
import 'package:app_cre/src/models/attention_payment_point.dart';
import 'package:app_cre/src/models/schedule.dart';
import 'package:app_cre/src/services/attention_payment_points_service.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:app_cre/src/ui/screens/maps/content_pop_up.dart';
import 'package:app_cre/src/ui/widgets/circular_progress.dart';
import 'package:app_cre/src/ui/widgets/custom_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:app_cre/src/blocs/blocs.dart';

class MapView extends StatefulWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final MapType mapType;
  final int categoryMarker;
  final Set<Marker> markers;

  MapView(
      {Key? key,
      required this.initialLocation,
      required this.polylines,
      required this.mapType,
      required this.categoryMarker,
      required this.markers})
      : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Set<Marker> markersAttention = Set();
  Set<Marker> markersPay = Set();
  List<AttentionPaymentPoint> points = List.empty(growable: true);
  late BitmapDescriptor attentionIcon, payIcon;
  MapType currentMapType = MapType.normal;

  @override
  void initState() {
    addMarkers();
    super.initState();
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

  addMarkers() async {
    getBytesFromAsset(
      'assets/icons/vuesax-bold-location.png',
      80,
    ).then((onValue) {
      attentionIcon = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset(
      'assets/icons/vuesax-bold-location-dark.png',
      80,
    ).then((onValue) {
      payIcon = BitmapDescriptor.fromBytes(onValue);
    });
    points = await AttentionPaymentPointsService().getPoints("");
    setState(() {
      points.forEach((element) {
        if (element.typeId == 1) {
          markersAttention.add(Marker(
              markerId: MarkerId(element.id.toString()),
              infoWindow: InfoWindow(
                  title: element.name,
                  snippet: element.address,
                  onTap: () {
                    openDialog(element);
                  }),
              position: LatLng(double.parse(element.latitude),
                  double.parse(element.longitude)),
              icon: attentionIcon));
        } else {
          markersPay.add(Marker(
              markerId: MarkerId(element.id.toString()),
              infoWindow: InfoWindow(
                  title: element.name,
                  snippet: element.address,
                  onTap: () {
                    openDialog(element);
                  }),
              position: LatLng(double.parse(element.latitude),
                  double.parse(element.longitude)),
              icon: payIcon));
        }
      });
    });
  }

  openDialog(AttentionPaymentPoint element) async {
    _showDialog(context, element);
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final CameraPosition initialCameraPosition =
        CameraPosition(target: widget.initialLocation, zoom: 15);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (pointerMoveEvent) =>
            mapBloc.add(OnStopFollowingUserEvent()),
        child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            compassEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapType: widget.mapType,
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
            polylines: widget.polylines,
            onMapCreated: (controller) =>
                mapBloc.add(OnMapInitialzedEvent(controller)),
            onCameraMove: (position) => mapBloc.mapCenter = position.target,
            markers: widget.categoryMarker == 1
                ? markersAttention
                : widget.categoryMarker == 2
                    ? markersPay
                    : widget.markers),
      ),
    );
  }

  _showDialog(context, AttentionPaymentPoint element) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.only(left: 16, right: 16),
          contentPadding: const EdgeInsets.only(top: 16, bottom: 16),
          actionsPadding: const EdgeInsets.only(bottom: 12),
          backgroundColor: const Color(0XFFF7F7F7),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: ContentPopUp(point: element),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        disabledColor: Colors.black87,
                        elevation: 0,
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.4,
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                              maxHeight: 50),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color(0XFF618A02),
                                Color(0XFF84BD00)
                              ])),
                          child: const Text(
                            'Ruta hasta aqui',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                        onPressed: () async {
                          final searchBloc =
                              BlocProvider.of<SearchBloc>(context);
                          final locationBloc =
                              BlocProvider.of<LocationBloc>(context);
                          final mapBloc = BlocProvider.of<MapBloc>(context);
                          var position = LatLng(double.parse(element.latitude),
                              double.parse(element.longitude));
                          final destination =
                              await searchBloc.getCoorsStartToEnd(
                                  locationBloc.state.lastKnownLocation!,
                                  position);
                          await mapBloc.drawRoutePolyline(destination);
                          Navigator.pop(context);
                        })),
                const SizedBox(
                  width: 15,
                ),
                Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        disabledColor: Colors.black87,
                        elevation: 0,
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.4,
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                              maxHeight: 50),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: const Color(0XFF3A3D5F), width: 1.5),
                          ),
                          child: const Text(
                            'Cerrar',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Color(0XFF3A3D5F),
                                fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
              ],
            )
          ]),
    );
  }
}

