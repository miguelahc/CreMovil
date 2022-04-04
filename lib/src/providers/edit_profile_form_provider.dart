import 'package:flutter/cupertino.dart';

class EditProfileFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";

  EditProfileFormProvider( this._name, this._email);

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

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String get name => _name;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String get email => _email;
}
