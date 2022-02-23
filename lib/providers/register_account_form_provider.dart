import 'package:app_cre/models/account.dart';
import 'package:flutter/material.dart';

class RegisterAccountFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _accountNumber = '';
  String _identificationNumber = '';
  String _aliasName = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    formKey.currentState?.save();
    return formKey.currentState?.validate() ?? false;
  }

  set accountNumber(String accountNumber) {
    this._accountNumber = accountNumber;
    notifyListeners();
  }

  set identificationNumber(String identificationNumber) {
    this._identificationNumber = identificationNumber;
    notifyListeners();
  }

  set aliasName(String aliasName) {
    this._aliasName = aliasName;
    notifyListeners();
  }

  Account getValues() {
    return Account(
        this._accountNumber, this._identificationNumber, this._aliasName);
  }
}
