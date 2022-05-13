import 'dart:convert';
import 'package:path/path.dart';
import 'dart:io';

import 'package:app_cre/src/models/invoice_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;
import 'package:path_provider/path_provider.dart';

import '../models/resultjson.dart';

class InvoiceService {
  Future<dynamic> getInvoiceDetail(
      token, userData, documentNumber, companyNumber) async {
    final response = await http.post(
      //Uri.parse(environment.url + 'cre_getinvoicedetails'),
        Uri.parse(environment.urlcre + 'RetornaDatosFactura'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_NuTele': userData["PhoneNumber"],
          'P_ImeiTele': userData["PhoneImei"],
          'P_NumeroDocumento': documentNumber,
          'P_NuComp': companyNumber,
          'P_Modo': environment.env
        }));

    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);

    var datajson;
    ResultJson rjson;
    List conceptosDetalleFactura;
    if (bodyResponse != null && bodyResponse != "") {
      datajson = jsonDecode(bodyResponse)["isOk"];
      if (datajson == "S") {
        conceptosDetalleFactura = jsonDecode(bodyResponse)["conceptos"];
        DataInvoice dataSimulacion = DataInvoice(
            0, // double.parse(nuBaseCredFisc),
            "",
            "",
            "",
            "",
            0, //double.parse(nuTotaFact),
            conceptosDetalleFactura,
            0,
            0,
            DateTime.now(),
            DateTime.now(),
            0,
            0);
        datajson = jsonEncode(dataSimulacion.toJson());
        rjson = ResultJson(0, datajson, "");
        //return jsonEncode(rjson);
      } else {
        datajson = jsonDecode(bodyResponse)["dsMens"];
        rjson = ResultJson(4, datajson, "");
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaDatosFactura]...",
          bodyResponse);
    }
    //return response.body;
    datajson = jsonEncode(rjson.toJson());
    return datajson;
    //return response.body;
  }

  Future<dynamic> simulateInvoice(
      token, userData, accountNumber, companyNumber, currentReading) async {
    final response = await http.post(
      //Uri.parse(environment.url + 'cre_getsimulateinvoice'),
        Uri.parse(environment.urlcre + 'SimulaFactura'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_Pin': userData["Pin"],
          'P_NuTele': userData["PhoneNumber"],
          'P_ImeiTele': userData["PhoneImei"],
          'P_NuCuen': accountNumber,
          'P_NuComp': companyNumber,
          'P_LectActual': currentReading,
          'P_Modo': environment.env
        }));
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    var datajson;
    ResultJson rjson;
    final List conceptosDetalleFactura;
    if (bodyResponse != null && bodyResponse != "") {
      conceptosDetalleFactura = jsonDecode(bodyResponse)["conceptos"];
      datajson = (jsonDecode(bodyResponse)["conceptos"])[0]["dsconc"];
      if (conceptosDetalleFactura.length >= 0 &&
          datajson.toString().toLowerCase() != "error") {
        DataInvoice detalleSimulacion = DataInvoice(
            0,
            "",
            "",
            "",
            "",
            0,
            conceptosDetalleFactura,
            0,
            0,
            DateTime.now(),
            DateTime.now(),
            0,
            0);
        datajson = jsonEncode(detalleSimulacion.toJson());
        rjson = ResultJson(0, datajson, "");
        //return jsonEncode(rjson);
      } else {
        datajson = (jsonDecode(bodyResponse)["conceptos"])[0]["dtconc"];
        rjson = ResultJson(4, datajson, bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [SimulaFactura]...",
          bodyResponse);
    }
    //return response.body;
    datajson = jsonEncode(rjson.toJson());
    return datajson;
    //return response.body;
  }

  parseData(InvoiceDetail invoiceDetail, String data) {
    List detalle = jsonDecode(jsonDecode(data)["Message"])["detalle"];
    var message = jsonDecode(jsonDecode(data)["Message"]);
    invoiceDetail.titularName = message["TitularName"];
    invoiceDetail.categoryName = message["CategoryName"];
    invoiceDetail.totalInvoice = message["TotaInvoice"];
    invoiceDetail.baseTaxCredit = message["BaseTaxCredit"];
    invoiceDetail.others = detalle.where(
          (element) =>
      element["Category"] == "" &&
          element["Description"] != "Total facturado" &&
          element["Description"] != "Base para crédito fiscal",
    );
    invoiceDetail.energyPower = detalle.where(
          (element) =>
      element["Category"] != "" &&
          element["Category"] == "Energía y potencia",
    );
    invoiceDetail.municipalFees = detalle.where(
          (element) =>
      element["Category"] != "" &&
          element["Category"] == "Tasas municipales",
    );
    invoiceDetail.chargesPayments = detalle.where(
          (element) =>
      element["Category"] != "" && element["Category"] == "Cargos y Abonos",
    );
  }

  Future<dynamic> registerReading(
      token, userData, accountNumber, companyNumber, currentReading, File file) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    Directory directory = Directory(appDirectory.path + "/images");
    if(!directory.existsSync()){
      directory.createSync();
    }
    final fileName = basename(file.path);
    File fileCopy = file.copySync(directory.path+"/"+fileName);
    var image2 = fileCopy.readAsBytesSync();
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RegistrarLectura'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token,
          'P_Pin': userData["Pin"],
          'P_NuTele': userData["PhoneNumber"],
          'P_ImeiTele': userData["PhoneImei"],
          'P_NuCuen': accountNumber,
          'P_NuComp': companyNumber,
          'P_Lect': currentReading,
          'P_Modo': environment.env
        },
        body: image2
    );
    var bodyResponse = Utf8Decoder().convert(response.bodyBytes);
    ResultJson rjson;
    if (bodyResponse != null && bodyResponse != "") {
      var ok = jsonDecode(bodyResponse)["isOk"];
      if ( ok == "S") {
        var message = jsonDecode(bodyResponse)["dsMens"];
        rjson = ResultJson(0, message, "");
        //return jsonEncode(rjson);
      } else {
        rjson = ResultJson(4, "Error en la respuesta del servicio [RegistrarLectura]...", bodyResponse);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RegistrarLectura]...",
          bodyResponse);
    }
    //return response.body;
    var datajson = jsonEncode(rjson.toJson());
    return datajson;
  }
}
