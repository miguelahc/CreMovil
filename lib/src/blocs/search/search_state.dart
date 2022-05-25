part of 'search_bloc.dart';

class SearchState extends Equatable {
  
  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> history;
  final List<AttentionPaymentPoint> placesOther;
  final List<AttentionPaymentPoint> historyOther;

  const SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.placesOther = const [],
    this.history = const [],
    this.historyOther = const [],
  });
  

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<AttentionPaymentPoint>? placesOther,
    List<Feature>? history,
    List<AttentionPaymentPoint>? historyOther
  }) 
  => SearchState(
    displayManualMarker: displayManualMarker ?? this.displayManualMarker,
    places: places ?? this.places,
    placesOther: placesOther ?? this.placesOther,
    history: history ?? this.history,
    historyOther: historyOther ?? this.historyOther
  );


  @override
  List<Object> get props => [ displayManualMarker, places, history, placesOther, historyOther ];
}

