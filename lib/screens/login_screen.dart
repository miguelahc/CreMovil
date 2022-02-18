import 'dart:convert';

import 'package:app_cre/screens/screens.dart';
import 'package:app_cre/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_cre/providers/login_form_provider.dart';
import 'package:app_cre/ui/input_decorations.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        //Activando el validador de formulario
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Stack(
          children: [
            const LoginBackground(),
            Column(
              children: [
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: _FormLogin(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _FormLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    TokenService().generateToken();
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.04),
      child: Form(
          key: loginForm.formKey,
          child: Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.45),
            const _Nombres(),
            const SizedBox(height: 15),
            const _Telefono(),
            const SizedBox(height: 30),
            MaterialButton(
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                disabledColor: Colors.black87,
                elevation: 0,
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.75,
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                      maxHeight: 50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                          colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
                  child: Text(
                    loginForm.isLoading ? 'Espere por favor ....' : 'Ingresar',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                onPressed: () {
                  if (loginForm.isValidForm()) {
                    var user = loginForm.getValues();
                    TokenService().readToken().then((value) {
                      UserService().sendPin(value, user.phone).then((value) {
                        var code = jsonDecode(value)["Code"];
                        if (code == 0) {
                          _showDialogExit(context, user);
                        } else {
                          _showDialogError(context);
                        }
                      });
                    });
                  }
                  FocusScope.of(context).unfocus();
                  // //Todo Login Forms
                  if (!loginForm.isValidForm()) return;
                }),
          ])),
    );
  }

  _showDialogExit(context, user) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          'Hemos enviado un mensaje de texto (SMS) con tu PIN de verificación de teléfono',
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
                    'Ingresar PIN',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ValidateCodScreen(
                              user: User(
                                  user.name, user.phone, user.prefixPhone))));
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
          'El numero de telefono no es valido, asegurate de ingresar un numero valido ...',
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
                    'Volver a Intentar',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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

class _Nombres extends StatelessWidget {
  const _Nombres({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Nombres',
          labelText: 'Nombres del usuario',
          prefixIcon: Icons.account_circle),
      style: const TextStyle(fontSize: 14),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        loginForm.setName(value);
      },
      validator: (value) {
        String pattern = r'[a-zA-Z ]{2,254}';
        RegExp regExp = RegExp(pattern);

        return regExp.hasMatch(value ?? '')
            ? null
            : 'El valor ingresado no es un nombre válido.';
      },
    );
  }
}

class _Telefono extends StatelessWidget {
  const _Telefono({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Row(children: [
      // SizedBox(height: MediaQuery.of(context).size.height * 0.35),
      SizedBox(
        width: 80,
        child: DropdownButtonFormField(
            value: '+591',
            items: const [
              DropdownMenuItem(value: '+591', child: Text('+591')),
              DropdownMenuItem(value: '+592', child: Text('+592')),
              DropdownMenuItem(value: '+593', child: Text('+593')),
            ],
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF84BD00)),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF84BD00), width: 2)),
            ),
            onChanged: (value) {
              loginForm.setPrefixPhone(value.toString());
            }),
      ),
      const Text(" "),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextFormField(
          // maxLength: 100,
          initialValue: '',
          keyboardType: TextInputType.number,
          decoration: InputDecorations.authInputDecoration(
              hintText: 'Teléfono',
              labelText: 'Teléfono móvil',
              prefixIcon: Icons.phone_android),
          style: const TextStyle(fontSize: 14),
          onChanged: (value) => loginForm.setPhone(value),
          validator: (value1) {
            String pattern = r'^\d+$';
            RegExp regExp = RegExp(pattern);
            if (!regExp.hasMatch(value1 ?? '')) {
              return "Solo se aceptan carateres numericos";
            }
            if (value1 == null || value1 == '') {
              return 'Este campo es requerido';
            }
            return value1.length < 4 ? 'Minimo 4 números' : null;
          },
        ),
      )
    ]);
  }
}
