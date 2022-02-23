import 'dart:convert';
import 'dart:math';

import 'package:app_cre/models/invoice_detail.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/services/environment.dart' as environment;

class InvoiceService {
  Future<dynamic> getInvoiceDetail(
      token, userData, documentNumber, companyNumber) async {
    final response = await http.post(
        Uri.parse(environment.url + 'cre_getinvoicedetails'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          // 'PhoneNumber': userData["PhoneNumber"],
          'PhoneNumber': "78498664",
          // 'PhoneImei': userData["PhoneImei"],
          'PhoneImei': "HHH",
          // 'DocumentNumber': documentNumber,
          "DocumentNumber": "105283937",
          'CompanyNumber': companyNumber,
          'Environment': environment.env
        }));
    return response.body;
  }

  Future<dynamic> simulateInvoice(
      token, userData, accountNumber, companyNumber, currentReading) async {
    final response = await http.post(
        Uri.parse(environment.url + 'cre_getsimulateinvoice'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'Pin': userData["Pin"],
          'PhoneNumber': userData["PhoneNumber"],
          'PhoneImei': userData["PhoneImei"],
          'AccountNumber': accountNumber,
          'CompanyNumber': companyNumber,
          'CurrentReading': currentReading,
          'Environment': environment.env
        }));
    return response.body;
  }

  parseData(InvoiceDetail invoiceDetail, String data) {
    Iterable<dynamic> message = jsonDecode(jsonDecode(data)["Message"]);
    invoiceDetail.others = message.where(
      (element) =>
          element["Category"] == null &&
          element["Description"] != "Total facturado" &&
          element["Description"] != "Base para crédito fiscal",
    );

    invoiceDetail.totalInvoice = message
        .where((element) =>
            element["Category"] == null &&
            element["Description"] == "Total facturado")
        .first["Value"];

    invoiceDetail.baseTaxCredit = message
        .where((element) =>
            element["Category"] == null &&
            element["Description"] == "Base para crédito fiscal")
        .first["Value"];

    invoiceDetail.energyPower = message.where(
      (element) =>
          element["Category"] != null &&
          element["Category"] == "Energía y potencia",
    );
    invoiceDetail.municipalFees = message.where(
      (element) =>
          element["Category"] != null &&
          element["Category"] == "Tasas municipales",
    );
    invoiceDetail.chargesPayments = message.where(
      (element) =>
          element["Category"] != null &&
          element["Category"] == "Cargos y Abonos",
    );
  }
}
