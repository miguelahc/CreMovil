import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_cre/services/environment.dart';
import 'package:app_cre/services/storage_service.dart';

class TokenService extends ChangeNotifier {
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'User': '@ppm0v11',
    'Pwd': 'm0v11cr3',
    'App': 'CRE',
  };

  generateToken() async {
    //final response = await http.get(Uri.parse(url + 'GetToken'), headers: headers);
    // String tocken = response.body;
    String tockenApp = "Q1JFfCp8QHBwbTB2MTF8KnxtMHYxMWNyM3wqfDIwMjIwMzAx";
    storage.write(key: 'token', value: tockenApp);
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
