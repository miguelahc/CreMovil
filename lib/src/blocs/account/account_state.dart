part of 'account_bloc.dart';

class AccountState extends Equatable {

  final List<dynamic> all;
  final List<dynamic> accounts;
  final List<dynamic> services;

  const AccountState({
    this.all = const [],
    this.accounts = const [],
    this.services = const []
  });

  AccountState copyWith({
    List<dynamic>? all,
    List<dynamic>? accounts,
    List<dynamic>? services,
  })
  => AccountState(
    all: all ?? this.all,
    accounts: accounts ?? this.accounts,
    services: services ?? this.services
  );

  @override
  List<Object?> get props => [ all, accounts, services];

}