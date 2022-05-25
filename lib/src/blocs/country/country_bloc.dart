import 'dart:async';
import 'dart:convert';

import 'package:app_cre/src/models/country.dart';
import 'package:app_cre/src/services/country_service.dart';
import 'package:app_cre/src/services/services.dart';

class CountryBloc{
  final _countriesData = StreamController<List<Country>>.broadcast();

  Stream<List<Country>> get allCountries {
    return _countriesData.stream;
  }

  void getCountries() async{
    final token = await TokenService().readToken();
    final response = await CountryService().getCountries(token);
    var message = jsonDecode(response)["Message"];
    List<dynamic> list = jsonDecode(message);
    List<Country> countries = CountryService().parseData(list);
    countries.sort((a, b) => a.id.compareTo(b.id));
    _countriesData.sink.add(countries);
  }

  void dispose(){
    _countriesData.close();
  }
}

final countryBloc = CountryBloc();

