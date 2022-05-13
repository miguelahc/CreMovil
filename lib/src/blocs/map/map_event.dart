part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitialzedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitialzedEvent(this.controller);
}

class OnStopFollowingUserEvent extends MapEvent {}
class OnStartFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocations;
  const UpdateUserPolylineEvent(this.userLocations);
}

class OnToggleUserRoute extends MapEvent{}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  const DisplayPolylinesEvent(this.polylines);
}

class OnChangeMapTypeEvent extends MapEvent{
  final MapType currentMapType;
  const OnChangeMapTypeEvent(this.currentMapType);
}

class OnChangeCategoryMarkerEvent extends MapEvent{
  final int categoryMarker;
  const OnChangeCategoryMarkerEvent(this.categoryMarker);
}