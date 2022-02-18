import 'package:flutter/cupertino.dart';

class EditRefrenceFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String reference = "";

  bool isValidForm() {
    formKey.currentState?.save();
    return formKey.currentState?.validate() ?? false;
  }
}
