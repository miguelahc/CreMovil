import 'dart:convert';

import 'package:app_cre/src/blocs/account/account_bloc.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/providers/register_account_form_provider.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RegisterAccountSession extends StatefulWidget {
  const RegisterAccountSession({Key? key}) : super(key: key);

  @override
  State<RegisterAccountSession> createState() => _RegisterAccountSession();
}

class _RegisterAccountSession extends State<RegisterAccountSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(gradient: DarkGradient),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    color: const Color(0XFFF7F7F7),
                    child: Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.27,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                                gradient: DarkGradient),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_left,
                                        color: Colors.white,
                                      )),
                                ),
                                CustomTitle(title: "Registro", subtitle: const [
                                  "Ingresa los datos solicitados",
                                  "para registrar tu C??digo Fijo o Servicio"
                                ]),
                              ],
                            )),
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: ChangeNotifierProvider(
                            create: (_) => RegisterAccountFormProvider(),
                            child: _FormRegisterAccount(),
                          ),
                        ))
                      ],
                    ),
                  )),
                ],
              ),
            )));
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
          child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    const _AccountNumber(),
                    const SizedBox(height: 10),
                    const _IdentificationNumber(),
                    const SizedBox(height: 10),
                    const _AliasName(),
                    const SizedBox(height: 30),
                    MaterialButton(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        disabledColor: Colors.black87,
                        elevation: 0,
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                              maxHeight: 50),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: PrimaryGradient),
                          child: registerForm.isLoading
                              ? circularProgress()
                              : const Text(
                                  'Registrar',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                        ),
                        onPressed: () {
                          if (registerForm.isValidForm() &&
                              !registerForm.isLoading) {
                            registerForm.isLoading = true;
                            TokenService().readToken().then((token) {
                              UserService().readUserData().then((data) {
                                var userData = jsonDecode(data);
                                Account account = registerForm.getValues();
                                PushNotificationService()
                                    .readPhonePushId()
                                    .then((phonePushId) {
                                  AccountService()
                                      .registerAccount(
                                          token, userData, account, phonePushId)
                                      .then((data) {
                                    var code = jsonDecode(data)["Code"];
                                    if (code == 0) {
                                      registerForm.isLoading = false;
                                      _showDialogExit(context);
                                    } else {
                                      registerForm.isLoading = false;
                                      _showDialogError(context);
                                    }
                                  });
                                });
                              });
                            });
                          }
                          FocusScope.of(context).unfocus();
                          // //Todo Login Forms
                          if (!registerForm.isValidForm()) return;
                        }),
                    Container(
                      color: const Color(0XFFF7F7F7),
                      height: 150,
                      alignment: Alignment.center,
                      child: Footer(dark: false),
                    )
                  ],
                )),

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
          '??Tus datos se han validado correctamente!\n\nEl registro se ha realizado con ??xito',
          style: TextStyle(fontFamily: 'Mulish', fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Align(
              alignment: Alignment.center,
              child: MaterialButton(
                  padding: const EdgeInsets.all(0),
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
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    final accountBloc = BlocProvider.of<AccountBloc>(context);
                    accountBloc.reloadAccounts();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, 'home');
                  })),
        ],
      ),
    );
  }

  _showDialogError(context) {
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
          '??No hemos podido validar la informaci??n proporcionada!\n\nFavor verifica que los datos est??n correctos e intente nuevamente.',
          style: TextStyle(fontFamily: 'Mulish', fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Align(
              alignment: Alignment.center,
              child: MaterialButton(
                  padding: const EdgeInsets.all(0),
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
                      'Regresar',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
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
          hintText: 'C??digo fijo / Servicio',
          labelText: 'C??digo fijo / Servicio',
          prefixIcon: Icons.tv),
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        registerForm.accountNumber = value;
      },
      validator: (value) {
        String pattern = r'^\d+$';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return "Solo se aceptan carateres num??ricos";
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
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
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
            : 'El valor ingresado no es un carnet de identidad o NIT v??lido.';
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
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        registerForm.aliasName = value;
      },
      validator: (value) {
        String pattern = r'^[a-zA-Z\s]+$';
        RegExp regExp = RegExp(pattern);

        return regExp.hasMatch(value ?? '')
            ? null
            : 'El valor ingresado no es un referencia v??lida.';
      },
    );
  }
}
