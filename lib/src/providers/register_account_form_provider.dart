import 'package:app_cre/src/models/account.dart';
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
    _accountNumber = accountNumber;
    notifyListeners();
  }

  set identificationNumber(String identificationNumber) {
    _identificationNumber = identificationNumber;
    notifyListeners();
  }

  set aliasName(String aliasName) {
    _aliasName = aliasName;
    notifyListeners();
  }

  Account getValues() {
    return Account(
        _accountNumber, _identificationNumber, _aliasName);
  }
}
