import 'dart:io';

import 'package:flutter/cupertino.dart';

class ReadingFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _reading = "";
  File? _image;

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

  set reading(String reading) {
    _reading = reading;
    notifyListeners();
  }

  String get reading => _reading;

  set image(File? image){
    _image = image;
    notifyListeners();
  }

  File? get image => _image;
}
