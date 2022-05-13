part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable{

  const AccountEvent();

  @override
  List<Object> get props => [];
}

class OnLoadInitAllAccountsEvent extends AccountEvent{
  final List<dynamic> all;
  const OnLoadInitAllAccountsEvent(this.all);
}

class OnUpdateAccountListEvent extends AccountEvent{
  final List<dynamic> accounts;
  const OnUpdateAccountListEvent(this.accounts);
}

class OnUpdateServiceListEvent extends AccountEvent{
  final List<dynamic> services;
  const OnUpdateServiceListEvent(this.services);
}
