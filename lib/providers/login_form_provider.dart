import 'package:app_cre/models/models.dart';
import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String phone = '';
  String prefixPhone = '+591';

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

  setName(String name) {
    this.name = name;
    notifyListeners();
  }

  setPhone(String phone) {
    this.phone = phone;
    notifyListeners();
  }

  setPrefixPhone(String prefixPhone) {
    this.prefixPhone = prefixPhone;
    notifyListeners();
  }

  User getValues() {
    return User(this.name, this.phone, this.prefixPhone);
  }
}
