import 'package:app_cre/src/blocs/map/map_bloc.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_cre/src/blocs/blocs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BtnMapType extends StatelessWidget {
  const BtnMapType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: customBoxDecoration(10),
        child: IconButton(
            icon: const Icon(Icons.layers, color: DarkColor),
            onPressed: () {
              _showDialogExit(context, mapBloc);
            }));
  }

  _showDialogExit(context, mapBloc) {
    showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => AlertDialog(
          alignment: Alignment.bottomLeft,
          insetPadding: const EdgeInsets.only(left: 16, right: 70, bottom: 24),
          contentPadding: const EdgeInsets.only(top: 16, bottom: 16),
          content: Container(
            height: 105,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("Tipo de mapa"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: mapBloc.state.currentMapType ==
                                              MapType.normal
                                          ? DarkColor
                                          : Colors.transparent,
                                      width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Image.asset(
                                "assets/normal.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            onTap: () {
                              mapBloc.add(OnChangeMapTypeEvent(MapType.normal));
                              Navigator.pop(context);
                            }),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            "Normal",
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: mapBloc.state.currentMapType ==
                                              MapType.satellite
                                          ? DarkColor
                                          : Colors.transparent,
                                      width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Image.asset(
                                "assets/satelite.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            onTap: () {
                              mapBloc
                                  .add(OnChangeMapTypeEvent(MapType.satellite));
                              Navigator.pop(context);
                            }),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            "Satelite",
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: mapBloc.state.currentMapType ==
                                              MapType.hybrid
                                          ? DarkColor
                                          : Colors.transparent,
                                      width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Image.asset(
                                "assets/hibrid.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            onTap: () {
                              mapBloc
                                  .add(OnChangeMapTypeEvent(MapType.hybrid));
                              Navigator.pop(context);
                            }),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            "Relieve",
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
