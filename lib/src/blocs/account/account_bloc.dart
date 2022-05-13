import 'dart:async';
import 'dart:convert';

import 'package:app_cre/src/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent,AccountState>{

  AccountBloc() : super(const AccountState()){

    on<OnLoadInitAllAccountsEvent> (
      (event, emit) => emit(state.copyWith(all: event.all)),
    );

    on<OnUpdateAccountListEvent> (
          (event, emit) => emit(state.copyWith(accounts: event.accounts)),
    );

    on<OnUpdateServiceListEvent> (
          (event, emit) => emit(state.copyWith(services: event.services)),
    );
  }

  void getAccounts() async{
    final token = await TokenService().readToken();
    final data = await UserService().readUserData();
    var userData = jsonDecode(data);
    final response = await AccountService().getAccounts(token,userData["Pin"], userData["PhoneNumber"],
        userData["PhoneImei"]);
    var message = jsonDecode(response)["Message"];
    Iterable<dynamic> list = jsonDecode(message);
    add(OnLoadInitAllAccountsEvent(list.toList()));
    _filterList(list.toList());
  }

  _filterList(List<dynamic> all){
    var accounts = all
        .where((element) => element["AccountTypeRegister"] == "Cuenta")
        .toList();
    var services = all
        .where((element) => element["AccountTypeRegister"] == "Servicio")
        .toList();

    add(OnUpdateAccountListEvent(accounts));
    add(OnUpdateServiceListEvent(services));
  }

  void reloadAccounts() async{
    getAccounts();
  }
}
