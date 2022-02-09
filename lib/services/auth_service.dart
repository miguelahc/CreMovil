import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBcytoCbDUARrX8eHpcR-Bdrdq0yUmSjf8';
  final String _baseUrlPrincipal = '192.168.1.4:3002';

  final storage = const FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      "usuario": "apolo",
      "password": "PruebaReto2021"
    };
    final Map<String, dynamic> authDataLoginEmpleado = {
      "usuario": email,
      "password": password
    };

    final url = Uri.http(_baseUrlPrincipal, '/usuarios/login');
    var resp = await http.post(url, body: authData);
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    final urlLogin = Uri.http(_baseUrlPrincipal, '/reto/login');

    //Envío del token para la petición
    if (decodedResp.containsKey('token')) {
      var respLogin = await http.post(urlLogin,
          body: authDataLoginEmpleado,
          headers: {
            'Authorization': 'Bearer ' + decodedResp['token'].toString()
          });
      final Map<String, dynamic> decodedRespLogin = json.decode(respLogin.body);
      if (decodedRespLogin['success'] == true) {
        await storage.write(
            key: 'token', value: 'Bearer ' + decodedResp['token'].toString());
        return null;
      } else {
        if (decodedRespLogin['message'].toString() == 'null') {
          return 'El usuario o contraseña están incorrectos.';
        } else {
          return decodedRespLogin['message'].toString();
        }
      }
    }
    return null;
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
