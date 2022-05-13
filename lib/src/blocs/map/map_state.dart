part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;
  final MapType currentMapType;
  final int categoryMarker;

  // Polylines
  final Map<String, Polyline> polylines;
  /*
    'mi_ruta: {
      id: polylineID Google,
      points: [ [lat,lng], [123123,123123], [123123,123123] ]
      width: 3
      color: black87
    },
  */


  const MapState({
    this.isMapInitialized = false, 
    this.isFollowingUser = true,
    this.showMyRoute = true,
    this.currentMapType = MapType.normal,
    this.categoryMarker = 1,
    Map<String, Polyline>? polylines
  }): polylines = polylines ?? const {};


  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    MapType? currentMapType,
    int? categoryMarker,
    Map<String, Polyline>? polylines
  }) 
  => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    showMyRoute: showMyRoute ?? this.showMyRoute,
    currentMapType: currentMapType ?? this.currentMapType,
    categoryMarker: categoryMarker ?? this.categoryMarker,
    polylines: polylines ?? this.polylines,
  );

  @override
  List<Object> get props => [ isMapInitialized, isFollowingUser, showMyRoute, currentMapType, categoryMarker, polylines ];
  
}


