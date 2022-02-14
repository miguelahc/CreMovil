import 'dart:convert';

import 'package:app_cre/models/account.dart';
import 'package:app_cre/providers/register_account_form_provider.dart';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/input_decorations.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterAccountScreen extends StatelessWidget {
  const RegisterAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        //Activando el validador de formulario
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Stack(
          children: [
            const RegisterAccountBackground(),
            Column(
              children: [
                ChangeNotifierProvider(
                  create: (_) => RegisterAccountFormProvider(),
                  child: _FormRegisterAccount(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _FormRegisterAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterAccountFormProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.04),
      child: Form(
          key: registerForm.formKey,
          child: Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.40),
            const _AccountNumber(),
            const SizedBox(height: 15),
            const _IdentificationNumber(),
            const SizedBox(height: 15),
            const _AliasName(),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                disabledColor: Colors.black87,
                elevation: 0,
                color: const Color(0xFF84BD00),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: const Text(
                    'Registrar',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                onPressed: () {
                  if (registerForm.isValidForm()) {
                    readToken().then((token) {
                      readUserData().then((data) {
                        var userData = jsonDecode(data);
                        Account account = registerForm.getValues();
                        // NOTE: Repace PhonePushId here
                        registerAccount(
                                token, userData, account, userData["PhoneImei"])
                            .then((data) {
                          var message = jsonDecode(data)["Message"];
                          var companyName = jsonDecode(message)["CompanyName"];
                          var clientName = jsonDecode(message)["ClientName"];
                          if (companyName != null && clientName != null) {
                            _showDialogExit(context);
                          } else {
                            _showDialogError(context);
                          }
                        });
                      });
                    });
                  }
                  FocusScope.of(context).unfocus();
                  // //Todo Login Forms
                  if (!registerForm.isValidForm()) return;
                })
          ])),
    );
  }

  _showDialogExit(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          '¡Tus datos se han validado correctamente!\n\nEl registro se ha realizado con éxito',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.black87,
                elevation: 0,
                color: const Color(0xFF618A02),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: const Text(
                    "Ingresar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'home');
                }),
          ),
        ],
      ),
    );
  }

  _showDialogError(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          '¡No hemos podido validar la información proporcionada!\n\nFavor verifica que los datos estén correctos e intente nuevamente.',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.black87,
                elevation: 0,
                color: const Color(0xFF618A02),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: const Text(
                    "Regresar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}

class _AccountNumber extends StatelessWidget {
  const _AccountNumber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterAccountFormProvider>(context);
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Código fijo / Servicio',
          labelText: 'Código fijo / Servicio',
          prefixIcon: Icons.tv),
      style: const TextStyle(fontSize: 14),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        registerForm.accountNumber = value;
      },
      validator: (value) {
        String pattern = r'^\d+$';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return "Solo se aceptan carateres numéricos";
        }
      },
    );
  }
}

class _IdentificationNumber extends StatelessWidget {
  const _IdentificationNumber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterAccountFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Carnet de identidad o NIT',
          labelText: 'Carnet de identidad o NIT',
          prefixIcon: Icons.switch_account),
      style: const TextStyle(fontSize: 14),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        registerForm.identificationNumber = value;
      },
      validator: (value) {
        String pattern = r'^[\w]+$';
        RegExp regExp = RegExp(pattern);

        return regExp.hasMatch(value ?? '')
            ? null
            : 'El valor ingresado no es un carnet de identidad o NIT válido.';
      },
    );
  }
}

class _AliasName extends StatelessWidget {
  const _AliasName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterAccountFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Referencia',
        labelText: 'Referencia',
        prefixIcon: Icons.language,
      ),
      style: const TextStyle(fontSize: 14),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        registerForm.aliasName = value;
      },
      validator: (value) {
        String pattern = r'^[a-zA-Z]+$';
        RegExp regExp = RegExp(pattern);

        return regExp.hasMatch(value ?? '')
            ? null
            : 'El valor ingresado no es un referencia válida.';
      },
    );
  }
}
