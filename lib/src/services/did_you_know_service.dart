import 'dart:convert';

import 'package:app_cre/src/models/did_you_know.dart';
import 'package:app_cre/src/models/resultjson.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;

class DidYouKnowService {
  Future<dynamic> getDidYouKnow(token) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaListaSabiasQue'),
        headers: <String, String>{
          'Authorization': token,
          'Response-Type': 'application/json',
        });

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["sabiasque"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [ModificarAlias]...",
          response.body);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<DidYouKnow> parseData(List<dynamic> items) {
    List<DidYouKnow> list = List.empty(growable: true);
    items.forEach((item) {
      DidYouKnow didYouKnow = DidYouKnow(
          item["idsabiasque"], item["nombresabiasque"], item["idimagen"],
          item["imagenfisica"], item["ancho"], item["alto"]);
      list.add(didYouKnow);
    });
    return list;
  }
}
