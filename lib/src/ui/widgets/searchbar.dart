import 'package:animate_do/animate_do.dart';
import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/delegates/delegates.dart';
import 'package:app_cre/src/models/models.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const SizedBox()
            : FadeInDown(
                duration: const Duration(milliseconds: 300),
                child: const _SearchBarBody());
      },
    );
  }
}

class _SearchBarBody extends StatefulWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  @override
  State<_SearchBarBody> createState() => _SearchBarBodyState();
}

class _SearchBarBodyState extends State<_SearchBarBody> {
  int categorySelected = 1;

  @override
  void initState() {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.getAllPlace();
    final mapBloc = BlocProvider.of<MapBloc>(context);
    searchBloc.getAllPlace();
    categorySelected = mapBloc.state.categoryMarker;
    super.initState();
  }

  void onSearchResults(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if (result.manual == true) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }

    if (result.position != null) {
      final destination = await searchBloc.getCoorsStartToEnd(
          locationBloc.state.lastKnownLocation!, result.position!);
      await mapBloc.drawRoutePolyline(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 0, bottom: 8),
                child: Text(
                  "Puntos de Atencion y Pago",
                  style: TextStyle(color: SecondaryColor),
                ),
              ),
              GestureDetector(
                  child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      height: 45,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13),
                      decoration: customBoxDecoration(15),
                      child: Row(children: const [
                        ImageIcon(
                          AssetImage('assets/icons/search-normal.png'),
                          color: DarkColor,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text('Buscar',
                              style: TextStyle(color: Colors.black87)),
                        )
                      ])),
                  onTap: () async {
                    final result = await showSearch(
                        context: context,
                        delegate: SearchDestinationDelegate());
                    if (result == null) return;

                    onSearchResults(context, result);
                  }),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 30,
                decoration: BoxDecoration(
                    boxShadow: customBoxShadow(),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    gradient: categorySelected == 1
                        ? const LinearGradient(colors: [DarkColor, DarkColor])
                        : SecondaryGradientAlt),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: customBoxShadow(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            gradient: categorySelected == 1
                                ? SecondaryGradientAlt
                                : const LinearGradient(colors: [
                                    Colors.transparent,
                                    Colors.transparent
                                  ])),
                        child: const Text(
                          "Atencion al Cliente",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () => setState(() {
                        categorySelected = 1;
                        mapBloc.add(OnChangeCategoryMarkerEvent(categorySelected));
                      }),
                    )),
                    Expanded(
                        child: GestureDetector(
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: customBoxShadow(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            gradient: categorySelected == 1
                                ? const LinearGradient(colors: [
                                    Colors.transparent,
                                    Colors.transparent
                                  ])
                                : const LinearGradient(
                                    colors: [DarkColor, DarkColor])),
                        child: const Text(
                          "Puntos de Pago",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () => setState(() {
                        categorySelected = 2;
                        mapBloc.add(OnChangeCategoryMarkerEvent(categorySelected));
                      }),
                    )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
