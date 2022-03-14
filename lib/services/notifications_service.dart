import 'dart:convert';

import 'package:app_cre/models/category.dart';
import 'package:app_cre/models/resultjson.dart';
import 'package:app_cre/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/services/environment.dart' as environment;

class NotificationsService {
  Future<dynamic> getCategories(token, userData) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaCategorias'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_NuTele': userData["PhoneNumber"],
          'P_ImeiTele': userData["PhoneImei"],
          'P_Modo': environment.env
        }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["isOk"];
      if (datajson == "S") {
        var categories = jsonDecode(bodyResponse)["categorias"];
        datajson = jsonEncode(categories);
        rjson = ResultJson(0, datajson, "");
      } else {
        rjson = ResultJson(
            4,
            "Error en la respuesta del servicio [RetornaCategorias]",
            bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaCategorias]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Iterable<Category> parseToListCategories(List categories) {
    Iterable<Category> list = categories.map((category) =>
        Category(
            category["nucatemovi"], category["dscatemovi"],
            category["dsimag"]));
    return list;
  }

  Future<dynamic> getNotifications(token, userData) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaNotificaciones'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          // 'P_NuTele': userData["PhoneNumber"],
          'P_NuTele': "78498664",
          // 'P_ImeiTele': userData["PhoneImei"],
          'P_ImeiTele': '+59178498664',
          'P_Modo': environment.env
        }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["isOk"];
      if (datajson == "S") {
        var notifications = jsonDecode(bodyResponse)["notificaciones"];
        datajson = jsonEncode(notifications);
        rjson = ResultJson(0, datajson, "");
      } else {
        rjson = ResultJson(
            4,
            "Error en la respuesta del servicio [RetornaNotificaciones]",
            bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaNotificaciones]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List filterOnlyCategory(List notifications, int categoryNumber) {
    List<dynamic> filterList = List.empty(growable: true);
    for(int i =0; i< notifications.length ; i++){
      if(notifications[i]["nucate"] == categoryNumber){
        filterList.add(notifications[i]);
      }
    }
    return filterList;
  }

  Future<dynamic> getImageOfNotifications(token, userData, idImage) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaImagen'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_Pin': userData["Pin"],
          // 'P_NuTele': userData["PhoneNumber"],
          'P_NuTele': "78498664",
          // 'P_ImeiTele': userData["PhoneImei"],
          'P_ImeiTele': '+59178498664',
          'P_IdImag': idImage,
          'P_Modo': environment.env
        }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      List images = jsonDecode(bodyResponse)["imagenes"];
      if (!images.isEmpty) {
        datajson = jsonEncode(images);
        rjson = ResultJson(0, datajson, "");
      } else {
        rjson = ResultJson(
            4,
            "Error en la respuesta del servicio [RetornaImagen]",
            bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaImagen]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Future<dynamic> countNotificationsToRead() async {
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var response = await getNotifications(token, userData);
    List notifications = jsonDecode(jsonDecode(response)["Message"]);
    notifications = notifications.where((element) => element["leido"]=="NO").toList();
    return notifications.length;
  }
}
