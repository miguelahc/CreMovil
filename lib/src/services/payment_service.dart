import 'dart:convert';

import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/models/payment_detail.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;

class PaymentService {
  Future<dynamic> _getPaymentTypes(token, userData, accountNumber) async {
    final response =
        await http.post(Uri.parse(environment.urlcre + 'RetornaPagos'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Response-Type': 'application/json',
              'Authorization': token
            },
            body: jsonEncode({
              'P_Pin': userData["Pin"],
              'P_NuTele': userData["PhoneNumber"],
              'P_ImeiTele': userData["PhoneImei"],
              'P_NuCuen': accountNumber,
              'P_Modo': environment.env
            }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      List<dynamic> payments = jsonDecode(bodyResponse)["pagos"];
      if (payments.isNotEmpty) {
        datajson = jsonEncode(payments[0]);
        rjson = ResultJson(0, datajson, "");
      } else {
        rjson = ResultJson(4,
            "Error en la respuesta del servicio [RetornaPagos]", bodyResponse);
      }
    } else {
      rjson = ResultJson(5,
          "Error en la respuesta del servicio [RetornaPagos]...", bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Payment _parseToPayment(dynamic item) {
    Payment payment = Payment(
        item["facturacionmensual"] ?? -1,
        item["financiamiento"] ?? -1,
        item["pagoextraordinario"] ?? -1,
        item["prepago"] ?? -1);
    return payment;
  }

  Future<Payment?> getPaymentTypes(int accountNumber) async {
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var paymentData = await _getPaymentTypes(token, userData, accountNumber);
    var code = jsonDecode(paymentData)["Code"];
    if (code == 0) {
      var msg = jsonDecode(paymentData)["Message"];
      return _parseToPayment(jsonDecode(msg));
    }
    return null;
  }

  Future<dynamic> _getPaymentDetail(
      token, userData, paymentId, paymentType) async {
    final response =
        await http.post(Uri.parse(environment.urlcre + 'RetornaDetallePago'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Response-Type': 'application/json',
              'Authorization': token
            },
            body: jsonEncode({
              'P_Pin': userData["Pin"],
              'P_NuTele': userData["PhoneNumber"],
              'P_ImeiTele': userData["PhoneImei"],
              'P_IdPago': paymentId,
              'P_Tipo': paymentType,
              'P_Modo': environment.env
            }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      List<dynamic> payments = jsonDecode(bodyResponse)["detallepagos"];
      if (payments.isNotEmpty) {
        datajson = jsonEncode(payments);
        rjson = ResultJson(0, datajson, "");
      } else {
        rjson = ResultJson(
            4,
            "Error en la respuesta del servicio [RetornaDetallePago]",
            bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaDetallePago]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<PaymentDetail> _parseToPaymentDetail(List<dynamic> items) {
    List<PaymentDetail> detail = List.empty(growable: true);
    items.forEach((item) {
      detail.add(PaymentDetail(
          item["nro"],
          item["tipo"],
          item["idpago"],
          item["iddocumento"],
          item["nrodocumento"],
          item["anho"],
          item["mes"],
          item["periodo"],
          item["moneda"],
          double.parse(item["total"].toString()),
          double.parse(item["acumulado"].toString())));
    });
    return detail;
  }

  Future<List<PaymentDetail>?> getPaymentDetail(
      int paymentId, int paymentType) async {
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var paymentData =
        await _getPaymentDetail(token, userData, paymentId, paymentType);
    var code = jsonDecode(paymentData)["Code"];
    if (code == 0) {
      var msg = jsonDecode(paymentData)["Message"];
      return _parseToPaymentDetail(jsonDecode(msg));
    }
    return null;
  }

  Future<dynamic> _getPaymentMethods(token, userData) async {
    final response =
        await http.post(Uri.parse(environment.urlcre + 'RetornaMetodosPago'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Response-Type': 'application/json',
              'Authorization': token
            },
            body: jsonEncode({
              'P_Pin': userData["Pin"],
              'P_NuTele': userData["PhoneNumber"],
              'P_ImeiTele': userData["PhoneImei"],
              'P_Modo': environment.env
            }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      List<dynamic> payments = jsonDecode(bodyResponse)["metodospago"];
      if (payments.isNotEmpty) {
        datajson = jsonEncode(payments);
        rjson = ResultJson(0, datajson, "");
      } else {
        rjson = ResultJson(
            4,
            "Error en la respuesta del servicio [RetornaMetodosPago]",
            bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaMetodosPago]...",
          bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  List<PaymentMethod> _parseToPaymentMethods(List<dynamic> items) {
    List<PaymentMethod> methods = List.empty(growable: true);
    items.forEach((item) {
      methods.add(PaymentMethod(item["id"], item["metodopago"]));
    });
    return methods;
  }

  Future<List<PaymentMethod>?> getPaymentMethods() async {
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var paymentData = await _getPaymentMethods(token, userData);
    var code = jsonDecode(paymentData)["Code"];
    if (code == 0) {
      var msg = jsonDecode(paymentData)["Message"];
      return _parseToPaymentMethods(jsonDecode(msg));
    }
    return null;
  }

  Future<dynamic> _emitPayment(token, userData, idPayment, methodPayment, accountNumber, companyNumber, amount) async {
    final response =
        await http.post(Uri.parse(environment.urlcre + 'EmitirPago'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Response-Type': 'application/json',
              'Authorization': token
            },
            body: jsonEncode({
              'P_Pin': userData["Pin"],
              'P_NuTele': userData["PhoneNumber"],
              'P_ImeiTele': userData["PhoneImei"],
              'P_Modo': environment.env,
              "P_IdPago" : idPayment,
              "P_MetodoPago" : methodPayment,
              "P_NuCuen" : accountNumber,
              "P_NuComp" : companyNumber,
              "P_Cant" : amount
            }));
    var datajson;
    ResultJson rjson;
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    if (bodyResponse != null && bodyResponse != "") {
      List<dynamic> payments = jsonDecode(bodyResponse)["datospago"];
      if (payments.isNotEmpty) {
        datajson = jsonEncode(payments);
        rjson = ResultJson(0, datajson, "");
      } else {
        rjson = ResultJson(
            4, "Error en la respuesta del servicio [EmitirPago]", bodyResponse);
      }
    } else {
      rjson = ResultJson(5,
          "Error en la respuesta del servicio [EmitirPago]...", bodyResponse);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  EmitPaymentDetail _parseToEmitPaymentDetail(dynamic item) {
    EmitPaymentDetail emitPaymentDetail = EmitPaymentDetail(
        item["idpago"],
        item["nombre"],
        item["glosa"],
        item["glosaqr"],
        item["tipomoneda"],
        double.parse(item["montototal"].toString()),
        DateTime.parse(item["fechaemision"]),
        DateTime.parse(item["fechavencimiento"]),
        item["idqr"],
        item["imagenqr"]);

    return emitPaymentDetail;
  }

  Future<EmitPaymentDetail?> emitPayment(idPayment, methodPayment, accountNumber, companyNumber, amount) async {
    var token = await TokenService().readToken();
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    var paymentData = await _emitPayment(token, userData, idPayment, methodPayment, accountNumber, companyNumber, amount);
    var code = jsonDecode(paymentData)["Code"];
    if (code == 0) {
      var msg = jsonDecode(paymentData)["Message"];
      return _parseToEmitPaymentDetail(jsonDecode(msg)[0]);
    }
    return null;
  }
}
