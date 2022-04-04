import 'package:flutter/cupertino.dart';

class EditReferenceFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _reference = "";

  EditReferenceFormProvider(this._reference);

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

  set reference(String reference) {
    _reference = reference;
    notifyListeners();
  }

  String get reference => _reference;
}
