import 'dart:convert';

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
}
