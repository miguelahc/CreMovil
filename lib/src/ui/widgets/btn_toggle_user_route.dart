import 'package:app_cre/src/blocs/map/map_bloc.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_cre/src/blocs/blocs.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: customBoxDecoration(10),
        child: IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: DarkColor),
            onPressed: () {
              mapBloc.add(OnToggleUserRoute());
            }));
  }
}
