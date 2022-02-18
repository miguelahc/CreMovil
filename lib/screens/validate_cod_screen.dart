import 'dart:convert';
import 'package:app_cre/services/services.dart';
import 'package:flutter/material.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../models/user.dart';

class ValidateCodScreen extends StatelessWidget {
  final User user;
  const ValidateCodScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        //Activando el validador de formulario
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Stack(
          children: [
            const ValidateCodBackground(),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      children: <Widget>[
                        const ImageIcon(
                          AssetImage('assets/icons/vuesax-linear-mobileXL.png'),
                          color: Color(0XFF3A3D5F),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Teléfono",
                                style: TextStyle(color: Color(0xFF999999))),
                            Text(
                              "${user.prefixPhone} ${user.phone}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  PinCodeTextField(
                    appContext: context,
                    cursorColor: const Color(0xFF84BD00),
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      activeColor: const Color(0xFF84BD00),
                      selectedColor: const Color(0xFF84BD00),
                      inactiveColor: const Color(0xFF84BD00),
                    ),
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    onCompleted: (code) {
                      TokenService().readToken().then((token) {
                        UserService()
                            .getPin(token, user.phone, user.phone)
                            .then((response) {
                          String message = jsonDecode(response)['Message'];
                          var pin =
                              UserService().findPinInPaternString(message);
                          if (code == pin) {
                            UserService().saveUserData(
                                pin,
                                user.name,
                                user.phone,
                                user.prefixPhone,
                                user.prefixPhone + user.phone);
                            UserService().readUserData().then((data) {
                              var userData = jsonDecode(data);
                              PushNotificationService()
                                  .readPhonePushId()
                                  .then((phonePushId) {
                                UserService()
                                    .registerUser(token, userData, phonePushId)
                                    .then((value) {
                                  print(value);
                                });
                              });
                            });
                            AccountService()
                                .getAccounts(token, pin, user.phone, user.phone)
                                .then((value) {
                              var data = jsonDecode(value)["Data"];
                              List accounts =
                                  AccountService().getListOfAccounts(data);
                              if (accounts.isEmpty) {
                                _showDialogCreateAccount(context);
                              } else {
                                Navigator.pushReplacementNamed(context, "home");
                              }
                            });
                          } else {
                            _showDialogError(context);
                          }
                        });
                      });
                    },
                    onChanged: (String value) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09),
                      const Text(
                        "¿No recibiste el SMS?",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 15),
                      InkWell(
                        child: const Text(
                          'Reenviar',
                          style: TextStyle(
                              color: Color(0xFF84BD00),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          TokenService().readToken().then((token) {
                            UserService()
                                .sendPin(token, user.phone)
                                .then((value) {
                              var code = jsonDecode(value)["Code"];
                              if (code == 0) {
                                _showDialogExit(context, user);
                              }
                            });
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }

  _showDialogCreateAccount(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          'No existen registros de servicios con el número de teléfono ingresado',
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
                      'Registrar Servício',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'register');
                  })),
        ],
      ),
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
                    _dismissDialog(context);
                  })),
        ],
      ),
    );
  }

  _showDialogError(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          '¡El PIN ingresado es incorrecto! \n\nPor favor revisa el SMS y vuelve a intentar',
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
                      'Regresar',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    _dismissDialog(context);
                  })),
        ],
      ),
    );
  }
}
