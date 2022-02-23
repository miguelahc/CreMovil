import 'dart:convert';

import 'package:app_cre/models/account.dart';
import 'package:app_cre/models/account_detail.dart';
import 'package:app_cre/providers/edit_refrence_form_provider.dart';
import 'package:app_cre/screens/home_screen.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/input_decorations.dart';
import 'package:app_cre/widgets/circular_progress.dart';
import 'package:app_cre/widgets/edit_reference_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditReferenceScreen extends StatefulWidget {
  final AccountDetail account;
  EditReferenceScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<EditReferenceScreen> createState() => _EditReferenceScreen();
}

class _EditReferenceScreen extends State<EditReferenceScreen> {
  late AccountDetail account;

  @override
  void initState() {
    setState(() {
      account = widget.account;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0XFFF7F7F7),
        body: Form(
          //Activando el validador de formulario
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Stack(
            children: [
              const EditRefrenceBackground(),
              Column(
                children: [
                  ChangeNotifierProvider(
                    create: (_) => EditRefrenceFormProvider(account.aliasName),
                    child: _FormRegisterAccount(
                      account: account,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class _FormRegisterAccount extends StatelessWidget {
  final AccountDetail account;

  _FormRegisterAccount({required this.account});
  @override
  Widget build(BuildContext context) {
    final referenceForm = Provider.of<EditRefrenceFormProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.04),
      child: Form(
          key: referenceForm.formKey,
          child: Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.40),
            const SizedBox(height: 15),
            _AliasName(
              reference: account.aliasName,
            ),
            const SizedBox(height: 30),
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width - 32,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 24, bottom: 24),
              child: Text("Minimo 4 y máximo 20 carateres"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    disabledColor: Colors.black87,
                    elevation: 0,
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                          maxHeight: 50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                              colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
                      child: referenceForm.isLoading
                          ? circularProgress()
                          : const Text(
                              'Guardar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    ),
                    onPressed: () {
                      if (referenceForm.isValidForm() &&
                          !referenceForm.isLoading) {
                        referenceForm.isLoading = true;
                        TokenService().readToken().then((token) {
                          UserService().readUserData().then((data) {
                            var userData = jsonDecode(data);
                            AccountService()
                                .modifyAlias(
                                    token,
                                    userData,
                                    account.accountNumber,
                                    account.companyNumber,
                                    referenceForm.reference)
                                .then((value) {
                              var code = jsonDecode(value)["Code"];
                              if (code == 0) {
                                referenceForm.isLoading = false;
                                _showDialogExit(context);
                              }
                            });
                          });
                        });
                      }
                      FocusScope.of(context).unfocus();
                      // //Todo Login Forms
                      if (!referenceForm.isValidForm()) return;
                    }),
                MaterialButton(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    disabledColor: Colors.black87,
                    elevation: 0,
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                          maxHeight: 50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: Color(0XFF3A3D5F), width: 1.5),
                      ),
                      child: const Text(
                        'Cancelar',
                        style:
                            TextStyle(color: Color(0XFF3A3D5F), fontSize: 16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            )
          ])),
    );
  }

  _showDialogExit(context) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          'La información se ha \nmodificado con éxito',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Align(
              alignment: Alignment.center,
              child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  disabledColor: Colors.black87,
                  elevation: 0,
                  child: Container(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                        maxHeight: 50),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                            colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
                    child: const Text(
                      'Aceptar',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  })),
        ],
      ),
    );
  }
}

class _AliasName extends StatefulWidget {
  final String reference;
  const _AliasName({Key? key, required this.reference}) : super(key: key);

  @override
  State<_AliasName> createState() => _AliasNameState();
}

class _AliasNameState extends State<_AliasName> {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<EditRefrenceFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Referencia',
        labelText: 'Referencia',
        prefixIcon: Icons.language,
      ),
      style: const TextStyle(fontSize: 14),
      initialValue: widget.reference,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        registerForm.reference = value;
      },
      validator: (value) {
        String pattern = r'^[a-zA-Z\s]{4,20}$';
        RegExp regExp = RegExp(pattern);

        return regExp.hasMatch(value ?? '')
            ? null
            : 'El valor ingresado no es un referencia válida.';
      },
    );
  }
}
