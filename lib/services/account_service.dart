import 'dart:convert';

import 'package:app_cre/models/account.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/services/environment.dart' as environment;

Future<dynamic> getAccounts(token, pin, phoneNumber, phoneImei) async {
  final response = await http.post(
      Uri.parse(environment.url + 'cre_getaccounts'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode({
        'Pin': pin,
        'PhoneNumber': phoneNumber,
        'PhoneImei': phoneImei,
        'Environment': environment.env
      }));
  return response.body;
}

List getListOfAccounts(String data) {
  var parameters = jsonDecode(data);
  return parameters['cuentas'] ?? [];
}

Future<dynamic> registerAccount(
    token, userData, Account account, phonePushId) async {
  final response = await http.post(
      Uri.parse(environment.url + 'cre_registeraccount'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode({
        'Pin': userData["Pin"],
        'PhoneNumber': userData["PhoneNumber"],
        'PhoneImei': userData["PhoneImei"],
        'AccountNumber': account.accountNumber,
        'IdentificationNumber': account.identificationNumber,
        'AliasName': account.aliasName,
        'PhonePushId': phonePushId,
        'Environment': environment.env
      }));
  return response.body;
}