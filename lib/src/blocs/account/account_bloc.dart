import 'dart:async';
import 'dart:convert';

import 'package:app_cre/src/services/services.dart';

class AccountBloc{
  final _accountsData = StreamController<Iterable<dynamic>>.broadcast();

  Stream<Iterable<dynamic>> get allAccounts {
    return _accountsData.stream;
  }

  void getAccounts() async{
    final token = await TokenService().readToken();
    final data = await UserService().readUserData();
    var userData = jsonDecode(data);
    final response = await AccountService().getAccounts(token,userData["Pin"], userData["PhoneNumber"],
        userData["PhoneImei"]);
    var message = jsonDecode(response)["Message"];
    Iterable<dynamic> list = jsonDecode(message);
    _accountsData.sink.add(list);
  }

  void reloadAccounts() async{
    getAccounts();
  }

  void dispose(){
    _accountsData.close();
  }
}

final accountBloc = AccountBloc();