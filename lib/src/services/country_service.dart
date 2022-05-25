import 'dart:convert';

import 'package:app_cre/src/models/country.dart';
import 'package:app_cre/src/models/resultjson.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;

class CountryService{
  Future<dynamic> getCountries(token) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaPaises'),
        headers: <String, String>{
          'Authorization': token,
          'Response-Type': 'application/json',
        });

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["paises"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaPaises]...",
          response.body);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<Country> parseData(List<dynamic> items) {
    List<Country> list = List.empty(growable: true);
    items.forEach((item) {
      Country country = Country(item["nupais"], item["cdpais"], item["cdprepais"], item["dsimag"]);
      list.add(country);
    });
    return list;
  }
}