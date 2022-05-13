import 'dart:convert';

import 'package:app_cre/src/models/attention_payment_point.dart';
import 'package:app_cre/src/models/point.dart';
import 'package:app_cre/src/models/position_mobil.dart';
import 'package:app_cre/src/models/schedule.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;
import 'package:intl/intl.dart';

import '../models/resultjson.dart';

class AttentionPaymentPointsService {
  Future<dynamic> _getPoints(token) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaPuntosAtencionPago'),
        headers: <String, String>{
          'Response-Type': 'application/json',
          'Authorization': token
        });
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["puntos"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(bodyResponse)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaPuntosAtencionPago]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<AttentionPaymentPoint> _parseData(List<dynamic> items) {
    List<AttentionPaymentPoint> list = List.empty(growable: true);
    items.forEach((item) {
      AttentionPaymentPoint point = AttentionPaymentPoint(
          item["idpunto"],
          item["nombre"],
          item["direccion"],
          item["idtipo"],
          item["tipo"],
          item["latitud"],
          item["longitud"]);
      list.add(point);
    });
    return list;
  }

  Future<List<AttentionPaymentPoint>> getPoints(String query) async {
    List<AttentionPaymentPoint> points =
        List<AttentionPaymentPoint>.empty(growable: true);
    var token = await TokenService().readToken();
    var data = await _getPoints(token);
    var msg = jsonDecode(data)["Message"];
    var code = jsonDecode(data)["Code"];
    if (code == 0) {
      List<dynamic> list = jsonDecode(msg);
      points = AttentionPaymentPointsService()._parseData(list);
    }
    if (query != null) {
      points = points
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return points;
  }

  Future<dynamic> _getPoint(token, userData, int notificationId) async {
    final response =
        await http.post(Uri.parse(environment.urlcre + 'RetornaPuntos'),
            headers: <String, String>{
              'Response-Type': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token
            },
            body: jsonEncode({
              "P_Pin": userData["Pin"],
              "P_NuTele": userData["PhoneNumber"],
              "P_ImeiTele": userData["PhoneImei"],
              "P_IdNoti": notificationId,
              "P_Modo": environment.env
            }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["puntos"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(bodyResponse)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaPuntos]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Point _parseDataToPoint(List<dynamic> items) {
    Point point = Point(items[0]["idnoti"], items[0]["nux"], items[0]["nuy"]);
    return point;
  }

  Future<Point> getPoint(int notificationId) async {
    Point point = Point(notificationId, -1, -1);
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var pointData = await _getPoint(token, userData, notificationId);
    var msg = jsonDecode(pointData)["Message"];
    var code = jsonDecode(pointData)["Code"];
    if (code == 0) {
      List<dynamic> list = jsonDecode(msg);
      point = _parseDataToPoint(list);
    }
    return point;
  }

  Future<dynamic> _getPositionMobil(
      token, userData, int accountNumber, int companyNumber) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    var list = formattedDate.split(" ");
    String dateNow = list[0] + "T" + list[1] + "Z";
    final response =
        await http.post(Uri.parse(environment.urlcre + 'RetornaPosicionMovil'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Response-Type': 'application/json',
              'Authorization': token
            },
            body: jsonEncode({
              "P_Pin": userData["Pin"],
              "P_NuTele": userData["PhoneNumber"],
              "P_ImeitTele": userData["PhoneImei"],
              "P_NuCuen": accountNumber,
              "P_NuComp": companyNumber,
              "P_FcLect": dateNow,
              "P_Modo": environment.env
            }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["isOk"];
      if (datajson == "S") {
        rjson = ResultJson(0, jsonEncode(bodyResponse), "");
      } else {
        rjson = ResultJson(
            4,
            "Error en la respuesta del servicio [RetornaPosicionMovil]...",
            bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaPosicionMovil]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  PositionMobil _parseDataToPositionMobil(items) {
    PositionMobil point =
        PositionMobil(items["P_DsText"], items["P_X"], items["P_Y"]);
    return point;
  }

  Future<PositionMobil> getPositionMobil(
      int accountNumber, int companyNumber) async {
    PositionMobil point = PositionMobil("", -1, -1);
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var pointData =
        await _getPositionMobil(token, userData, accountNumber, companyNumber);
    var msg = jsonDecode(pointData)["Message"];
    var code = jsonDecode(pointData)["Code"];
    if (code == 0) {
      dynamic item = jsonDecode(msg);
      point = _parseDataToPositionMobil(jsonDecode(item));
    }
    return point;
  }

  Future<dynamic> _getSchedules(token, userData, int pointId) async {
    final response =
    await http.post(Uri.parse(environment.urlcre + 'RetornaHorarios'),
        headers: <String, String>{
          'Response-Type': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          "P_Pin": userData["Pin"],
          "P_NuTele": userData["PhoneNumber"],
          "P_ImeiTele": userData["PhoneImei"],
          "IdPunto": pointId,
          "P_Modo": environment.env
        }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["horarios"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(bodyResponse)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaHorarios]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<Schedule> _parseDataToSchedule(List<dynamic> items) {
    List<Schedule> list = List.empty(growable: true);
    items.forEach((item) {
      Schedule schedule = Schedule(
          item["idpunto"],
          item["nombrepunto"],
          item["idhorario"],
          item["descripcionhorario"],
          item["desde"],
          item["hasta"],
          item["desde1"]?? "none",
          item["hasta1"]?? "none");
      list.add(schedule);
    });
    return list;
  }

  Future<List<Schedule>> getSchedules(int pointId) async {
    List<Schedule> schedules = List.empty(growable: true);
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var pointData = await _getSchedules(token, userData, pointId);
    var msg = jsonDecode(pointData)["Message"];
    var code = jsonDecode(pointData)["Code"];
    if (code == 0) {
      List<dynamic> list = jsonDecode(msg);
      schedules = _parseDataToSchedule(list);
    }
    return schedules;
  }

  Future<dynamic> _getPhones(token, userData, int pointId) async {
    final response =
    await http.post(Uri.parse(environment.urlcre + 'RetornaTelefonos'),
        headers: <String, String>{
          'Response-Type': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          "P_Pin": userData["Pin"],
          "P_NuTele": userData["PhoneNumber"],
          "P_ImeiTele": userData["PhoneImei"],
          "IdPunto": pointId,
          "P_Modo": environment.env
        }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["telefonos"];
      if (datajson != null) {
        rjson = ResultJson(0, jsonEncode(datajson), "");
      } else {
        datajson = jsonDecode(bodyResponse)["dsMens"];
        rjson = ResultJson(4, jsonEncode(datajson), bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaTelefonos]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<String> _parseDataToPhones(List<dynamic> items) {
    List<String> list = List.empty(growable: true);
    items.forEach((item) {
      list.add(item["telefono"]);
    });
    return list;
  }

  Future<List<String>> getPhones(int pointId) async {
    List<String> phones = List.empty(growable: true);
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var pointData = await _getPhones(token, userData, pointId);
    var msg = jsonDecode(pointData)["Message"];
    var code = jsonDecode(pointData)["Code"];
    if (code == 0) {
      List<dynamic> list = jsonDecode(msg);
      phones = _parseDataToPhones(list);
    }
    return phones;
  }

}
