import 'dart:convert';
import 'dart:io';
import 'package:app_cre/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/services/environment.dart' as environment;

Future<dynamic> registerUser(String token, userData, phonePushId) async {
  var os = 'Android';
  if (Platform.isIOS) {
    os = 'iOS';
  }
  final response = await http.post(
      Uri.parse(environment.url + 'cre_userregister'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode({
        'Pin': userData["Pin"],
        'PhoneNumber': userData['PhoneNumber'],
        'PhoneSO': os,
        'PhonePushId': phonePushId,
        'PhoneImei': userData['PhoneImei'],
        'Environment': environment.env
      }));
  return response.body;
}

Future<dynamic> sendPin(String token, String phoneNumer) async {
  final response = await http.post(Uri.parse(environment.url + 'cre_sendpin'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(
          {'PhoneNumber': phoneNumer, 'Environment': environment.env}));
  return response.body;
}

Future<dynamic> getPin(
    String token, String phoneNumer, String phoneImei) async {
  final response = await http.post(Uri.parse(environment.url + 'cre_getpin'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode({
        'PhoneNumber': phoneNumer,
        'PhoneImei': phoneImei,
        'Environment': environment.env
      }));
  return response.body;
}

String findPinInPaternString(String string) {
  var parameters = jsonDecode(string);
  return parameters['Pin'] ?? '-1';
}

saveUserData(pin, phoneNumber, prefixPhone, phoneImei) {
  storage.write(
      key: 'user_data',
      value:
          '{"Pin": $pin, "PhoneNumber": $phoneNumber, "PhoneImei": "$phoneImei", "PrefixPhone": "$prefixPhone"}');
}

Future<String> readUserData() async {
  return await storage.read(key: 'user_data') ?? '';
}
