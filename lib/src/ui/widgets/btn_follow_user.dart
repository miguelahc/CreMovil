import 'package:app_cre/src/blocs/map/map_bloc.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_cre/src/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: 40,
      height: 40,
      decoration: customBoxDecoration(10),
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return IconButton(
              icon: Icon(
                  state.isFollowingUser
                      ? Icons.directions_run_rounded
                      : Icons.hail_rounded,
                  color: DarkColor),
              onPressed: () {
                mapBloc.add(OnStartFollowingUserEvent());
              });
        },
      ),
    );
  }
}
