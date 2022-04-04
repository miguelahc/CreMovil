import 'dart:convert';

import 'package:app_cre/src/models/account.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/src/services/environment.dart' as environment;
import 'package:intl/intl.dart';

import '../models/resultjson.dart';

class AccountService {
  Future<dynamic> getAccounts(token, pin, phoneNumber, phoneImei) async {
    final response = await http.post(
      //Uri.parse(environment.url + 'cre_getaccounts'),
        Uri.parse(environment.urlcre + 'RetornaCuentas'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_Pin': pin,
          'P_Nutele': phoneNumber,
          'P_DsImei': phoneImei,
          'P_Modo': environment.env
        }));

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["isOk"];
      if (datajson == "S") {
        datajson = jsonDecode(response.body)["cuentas"];
        datajson = ListAccounts.getAccounts(datajson);
        datajson = jsonEncode(datajson);
        rjson = ResultJson(0, datajson, "");
        //return jsonEncode(rjson);
      } else {
        rjson = ResultJson(4,
            "No existen cuentas para el numero " + phoneNumber, response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaCuentas]...",
          response.body);
    }
    return jsonEncode(rjson.toJson());
    //return response.body;
  }

  List getListOfAccounts(String data) {
    var parameters = jsonDecode(data);
    return parameters['cuentas'] ?? [];
  }

  Future<dynamic> registerAccount(
      token, userData, Account account, phonePushId) async {
    final response = await http.post(
      //Uri.parse(environment.url + 'cre_registeraccount'),
        Uri.parse(environment.urlcre + 'RegistrarCuenta'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_Pin': userData["Pin"],
          'P_NuTele': userData["PhoneNumber"],
          'P_ImeiTele': userData["PhoneImei"],
          'P_NuCuen': account.accountNumber,
          'P_NuDocu': account.identificationNumber,
          'P_NoAlia': account.aliasName,
          'P_PushId': phonePushId,
          'P_Modo': environment.env
        }));

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["pa_isOk"];
      if (datajson == "S") {
        int companyName = jsonDecode(response.body)["pa_nuComp"];
        String clientName = jsonDecode(response.body)["pa_noClie"];
        String typeAccount = jsonDecode(response.body)["pa_tiCuen"];
        RegisterAccount raccount =
        RegisterAccount(companyName, clientName, typeAccount);
        datajson = jsonEncode(raccount);
        rjson = ResultJson(0, datajson, "");
        //return jsonEncode(rjson);
      } else {
        datajson = jsonDecode(response.body)["pa_dsMens"];
        rjson = ResultJson(4, datajson, response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RegistrarCuenta]...",
          response.body);
    }
    //return response.body;
    return jsonEncode(rjson.toJson());
  }

  Future<dynamic> getStatement(
      token, userData, accountNumber, companyNumber) async {
    final response = await http.post(
      //Uri.parse(environment.url + 'cre_getstatement'),
        Uri.parse(environment.urlcre + 'RetornaEstadoCuenta'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          'P_NuTele': userData["PhoneNumber"],
          'P_ImeiTele': userData["PhoneImei"],
          'P_NuCuen': accountNumber,
          'P_NuComp': companyNumber,
          'P_Modo': environment.env
        }));

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["isOk"];
      if (datajson == "S") {
        String nutele = jsonDecode(response.body)["nutele"].toString();
        String idcuen = jsonDecode(response.body)["idcuen"].toString();
        String nucuen = jsonDecode(response.body)["nucuen"].toString();
        String nucomp = jsonDecode(response.body)["nucomp"].toString();
        String noalia = jsonDecode(response.body)["noalia"].toString();
        String stregi = jsonDecode(response.body)["stregi"].toString();
        String fcregi = jsonDecode(response.body)["fcregi"].toString();
        String fcmodi = jsonDecode(response.body)["fcmodi"].toString();
        String notitu = jsonDecode(response.body)["notitu"].toString();
        String essoci = jsonDecode(response.body)["essoci"].toString();
        String dsdire = jsonDecode(response.body)["dsdire"].toString();
        String cddist = jsonDecode(response.body)["cddist"].toString();
        String cdsecc = jsonDecode(response.body)["cdsecc"].toString();
        String nuuv = jsonDecode(response.body)["nuuv"].toString();
        String numz = jsonDecode(response.body)["numz"].toString();
        String dsstcuen = jsonDecode(response.body)["dsstcuen"].toString();
        String todeud = jsonDecode(response.body)["todeud"].toString();
        String nudocu = jsonDecode(response.body)["nudocu"].toString();
        DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
        List estadoCuenta = jsonDecode(response.body)["estadocuenta"];
        AccountCre accountCre = AccountCre(
            userData["Pin"],
            nutele,
            "NULL",
            nucuen,
            nucomp,
            "NULL",
            noalia,
            environment.env,
            "NULL",
            "NULL",
            "NULL",
            nudocu,
            "NULL",
            "NULL",
            idcuen,
            notitu,
            dateFormat.parse(fcregi),
            dateFormat.parse(fcmodi),
            essoci,
            dsdire,
            double.parse(todeud),
            dsstcuen,
            stregi,
            cddist,
            cdsecc,
            nuuv,
            numz,
            estadoCuenta);

        datajson = jsonEncode(accountCre);
        rjson = ResultJson(0, datajson, "");
        //return jsonEncode(rjson);
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, datajson, response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [RetornaEstadoCuenta]...",
          response.body);
    }

    return jsonEncode(rjson.toJson());
    //return response.body;
  }

  Future<dynamic> modifyAlias(
      token, userData, accountNumber, companyNumber, aliasName) async {
    final response = await http.post(
        Uri.parse(environment.urlcre + 'ModificarAlias'),
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
          "P_NoAlia": aliasName,
          'P_Modo': environment.env
        }));

    var datajson;
    ResultJson rjson;
    if (response.body != null && response.body != "") {
      datajson = jsonDecode(response.body)["isOk"];
      if (datajson == "S") {
        rjson = ResultJson(0, "OK", "");
      } else {
        datajson = jsonDecode(response.body)["dsMens"];
        rjson = ResultJson(4, datajson, response.body);
      }
    } else {
      rjson = ResultJson(
          5,
          "Error en la respuesta del servicio [ModificarAlias]...",
          response.body);
    }
    datajson = rjson.toJson();
    return jsonEncode(datajson);
  }

  Future<dynamic> disableAccount(
      token, userData, accountNumber, companyNumber) async {
    final response = await http.post(
      //Uri.parse(environment.url + 'cre_disableaccount'),
        Uri.parse(environment.urlcre + 'BajaCuenta'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body: jsonEncode({
          "P_Pin": userData["Pin"],
          'P_Nutele': userData["PhoneNumber"],
          'P_ImeiTele': userData["PhoneImei"],
          'P_NuCuen': accountNumber,
          'P_NuComp': companyNumber,
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
          "Error en la respuesta del servicio [ModificarAlias]...",
          response.body);
    //return response.body;
    datajson = rjson.toJson();
    return jsonEncode(datajson);
    //return response.body;
  }
}
