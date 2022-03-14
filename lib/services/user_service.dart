import 'dart:convert';
import 'dart:io';
import 'package:app_cre/models/account.dart';
import 'package:app_cre/models/resultjson.dart';
import 'package:app_cre/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/services/environment.dart' as environment;

class UserService {
  Future<dynamic> registerUser(String token, userData, phonePushId) async {
    var os = 'Android';
    if (Platform.isIOS) {
      os = 'iOS';
    }
    final response = await http.post(
      //Uri.parse(environment.url + 'cre_userregister'),
        Uri.parse(environment.urlcre + 'RegistrarUsuario'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        /*
        body: jsonEncode({
          'Pin': userData["Pin"],
          'PhoneNumber': userData['PhoneNumber'],
          'PhoneSO': os,
          'PhonePushId': phonePushId,
          'PhoneImei': userData['PhoneImei'],
          'Environment': environment.env
        })*/
        body: jsonEncode({
          'P_Pin': userData["Pin"],
          'P_NuTele': userData['PhoneNumber'],
          'P_SoTele': os,
          'P_PushIdTele': phonePushId,
          'P_ImeiTele': userData['PhoneImei'],
          'P_Modo': environment.env
        }));
    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["isOk"];
      if (datajson == "S") {
        rjson = new ResultJson(0, "OK", "");
        //return jsonEncode(rjson);
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = new ResultJson(4, datajson, response.body);
      }
    } else
      rjson = new ResultJson(
          5,
          "Error en la respuesta del servicio [RegistrarUsuario]...",
          response.body);
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
        rjson = new ResultJson(0, "OK", "");
        //return jsonEncode(rjson);
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = new ResultJson(4, datajson, response.body);
      }
    } else
      rjson = new ResultJson(5,
          "Error en la respuesta del servicio [RetornaPin]...", response.body);
    //return response.body;
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Future<dynamic> getPin(
      String token, String phoneNumer, String phoneImei) async {
    //final response = await http.post(Uri.parse(environment.url + 'cre_getpin'),
    final response = await http.post(
        Uri.parse(environment.urlcre + 'ObtenerPin'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        /*
        body: jsonEncode({
          'PhoneNumber': phoneNumer,
          'PhoneImei': phoneImei,
          'Environment': environment.env
        })*/
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
        accountcre = new AccountCre(
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
            new List.empty(growable: true));
        datajson = jsonEncode(accountcre.toJson());
        rjson = new ResultJson(0, datajson, "");
        //return jsonEncode(rjson);
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = new ResultJson(4, datajson, response.body);
      }
    } else
      rjson = new ResultJson(5,
          "Error en la respuesta del servicio [RetornaPin]...", response.body);
    //return response.body;
    return jsonEncode(rjson.toJson());
  }

  String findPinInPaternString(String string) {
    var parameters = jsonDecode(string);
    return parameters['Pin'] ?? '-1';
  }

  saveUserData(pin, name, phoneNumber, prefixPhone, phoneImei) {
    storage.write(
        key: 'user_data',
        value:
        '{"Pin": "$pin", "Name": "$name", "PhoneNumber": "$phoneNumber", "PhoneImei": "$phoneImei", "PrefixPhone": "$prefixPhone"}');
  }

  Future<String> readUserData() async {
    return await storage.read(key: 'user_data') ?? '';
  }
}
