import 'package:app_cre/src/ui/components/box_decoration.dart';
import 'package:app_cre/src/ui/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            final result = SearchResult(cancel: true);
            close(context, result);
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;
    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        final placesOther = state.placesOther;
        return Container(
            height: MediaQuery.of(context).size.height - 160,
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
            decoration: customBoxDecoration(10),
            child: ListView(children: [
              ...placesOther.map((place) => Column(
                    children: [
                      ListTile(
                          title: Text(place.name),
                          subtitle: Text(place.address),
                          leading: ImageIcon(
                            AssetImage('assets/icons/vuesax-bold-location.png'),
                            color: place.typeId == 1
                                ? SecondaryColor
                                : PrimaryColor,
                          ),
                          onTap: () {
                            final result = SearchResult(
                                cancel: false,
                                manual: false,
                                position: LatLng(double.parse(place.latitude),
                                    double.parse(place.longitude)),
                                name: place.name,
                                description: place.name);

                            // searchBloc.add(AddToHistoryOEvent(place));

                            close(context, result);
                          }),
                      Container(
                        height: 1,
                        color: Colors.black26,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      )
                    ],
                  )),
            ]));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final historyComplete =
        BlocProvider.of<SearchBloc>(context).state.historyOther;
    final history = historyComplete
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()) ||
            element.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
      decoration: customBoxDecoration(15),
      child: ListView(
        children: [
          ListTile(
              style: ListTileStyle.list,
              leading: const ImageIcon(
                AssetImage('assets/icons/vuesax-bold-location.png'),
                color: Colors.black,
              ),
              title: const Text('Colocar la ubicación manualmente',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                final result = SearchResult(cancel: false, manual: true);
                close(context, result);
              }),
          ...history.map((place) => ListTile(
              title: Text(place.name),
              subtitle: Text(place.address),
              leading: ImageIcon(
                AssetImage('assets/icons/vuesax-bold-location.png'),
                color: place.typeId == 1 ? SecondaryColor : DarkColor,
              ),
              onTap: () {
                final result = SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(double.parse(place.latitude),
                        double.parse(place.longitude)),
                    name: place.name,
                    description: place.address);

                close(context, result);
              }))
        ],
      ),
    );
  }
}
