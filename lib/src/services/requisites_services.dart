import 'dart:convert';

import 'package:app_cre/src/models/did_you_know.dart';
import 'package:app_cre/src/models/requisite.dart';
import 'package:app_cre/src/models/resultjson.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;

class RequisitesService {
  Future<dynamic> getRequisites(token) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaRequisitos'),
        headers: <String, String>{
          'Authorization': token,
          'Response-Type': 'application/json',
        });

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["requisitos"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaRequisitos]...",
          response.body);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Future<dynamic> getRequisiteDetail(token, id) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaDetalleRequisito'),
        headers: <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'IdRequisito': id,
        }));

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["detallerequisito"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaDetalleRequisito]...",
          response.body);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<Requisite> parseData(List<dynamic> items) {
    List<Requisite> list = List.empty(growable: true);
    items.forEach((item) {
      Requisite requisite = Requisite(
          item["idrequisito"]?? 0, item["nombrerequisito"]?? "", item["idimagen"],
          item["imagenfisica"], item["ancho"], item["alto"]);
      list.add(requisite);
    });
    return list;
  }
}
