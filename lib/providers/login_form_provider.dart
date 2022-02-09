import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String nombreUsuario = '';
  String telefonoUsuario = '';
  String prefijoTelefono = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    // print(formKey.currentState?.validate());

    // print('$nombreUsuario - $telefonoUsuario - $prefijoTelefono');

    return formKey.currentState?.validate() ?? false;
  }
}
