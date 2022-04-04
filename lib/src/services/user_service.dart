import 'dart:convert';
import 'dart:io';
import 'package:app_cre/src/models/account.dart';
import 'package:app_cre/src/models/resultjson.dart';
import 'package:app_cre/src/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;

class UserService {
  Future<dynamic> registerUser(String token, userData, phonePushId) async {
    var os = 'Android';
    if (Platform.isIOS) {
      os = 'iOS';
    }
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RegistrarUsuario'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_Pin': userData["Pin"],
          'P_NuTele': userData['PhoneNumber'],
          'P_SoTele': os,
          'P_PushIdTele': phonePushId,
          'P_ImeiTele': userData['PhoneImei'],
          "P_Email" : userData["Email"],
          "P_NoUsua" : userData["Name"],
          'P_Modo': environment.env
        }));
    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["isOk"];
      if (datajson == "S") {
        rjson = ResultJson(0, "OK", "");
        //return jsonEncode(rjson);
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, datajson, response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RegistrarUsuario]...",
          response.body);
    }
    //return response.body;
    return jsonEncode(rjson.toJson());
  }

  Future<dynamic> sendPin(String token, String phoneNumer) async {
    //final response = await http.post(Uri.parse(environment.url + 'cre_sendpin'),
    final response = await http.post(
        Uri.parse(environment.urlcre + 'RetornaPin'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({'P_NuTele': phoneNumer, 'P_Modo': environment.env}));

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["isOk"];
      if (datajson == "S") {
        rjson = ResultJson(0, response.body, "");
      }
      else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, datajson, response.body);
      }
    } else {
      rjson = ResultJson(5,
          "Error en la respuesta del servicio [RetornaPin]...", response.body);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Future<dynamic> getPin(
      String token, String phoneNumer, String phoneImei) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'ObtenerPin'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_NuTele': phoneNumer,
          'P_ImeiTele': phoneImei,
          'P_Modo': environment.env
        }));

    var datajson;
    ResultJson rjson;
    AccountCre accountcre;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["isOk"];
      if (datajson == "S") {
        datajson = jsonDecode(response.body)["pin"];
        accountcre = AccountCre(
            datajson,
            phoneNumer,
            phoneImei,
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            environment.env,
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            new DateTime(1900, 1, 1),
            new DateTime(1900, 1, 1),
            "NULL",
            "NULL",
            -1,
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            "NULL",
            List.empty(growable: true));
        datajson = jsonEncode(accountcre.toJson());
        rjson = ResultJson(0, datajson, "");
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, datajson, response.body);
      }
    } else {
      rjson = ResultJson(5,
          "Error en la respuesta del servicio [RetornaPin]...", response.body);
    }
    return jsonEncode(rjson.toJson());
  }

  String findPinInPaternString(String string) {
    var parameters = jsonDecode(string);
    return parameters['Pin'] ?? '-1';
  }

  saveUserData(pin, name, phoneNumber, email, prefixPhone, phoneImei) {
    storage.write(
        key: 'user_data',
        value:
        '{"Pin": "$pin", "Name": "$name", "PhoneNumber": "$phoneNumber", "Email": "$email", "PhoneImei": "$phoneImei", "PrefixPhone": "$prefixPhone"}');
  }

  Future<String> readUserData() async {
    return await storage.read(key: 'user_data') ?? '';
  }
}
