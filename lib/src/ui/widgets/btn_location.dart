import 'package:app_cre/src/blocs/location/location_bloc.dart';
import 'package:app_cre/src/blocs/map/map_bloc.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/ui/components/components.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: customBoxDecoration(10),
        child: IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icons/icon-Ubicacion.png'),
              color: DarkColor,
              size: 26,
            ),
            onPressed: () {
              final userLocation = locationBloc.state.lastKnownLocation;

              if (userLocation == null) {
                final snack = CustomSnackbar(message: 'No hay ubicación');
                ScaffoldMessenger.of(context).showSnackBar(snack);
                return;
              }

              mapBloc.moveCamera(userLocation);
            }));
  }
}
