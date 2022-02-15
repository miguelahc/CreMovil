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
                        const Icon(
                          Icons.phone_android_outlined,
                          size: 44,
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.black87,
                elevation: 0,
                color: const Color(0xFF618A02),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: const Text(
                    "Registrar Servício",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'register');
                }),
          ),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.black87,
                elevation: 0,
                color: const Color(0xFF618A02),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: const Text(
                    "Ingresar PIN",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  _dismissDialog(context);
                }),
          ),
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
                  _dismissDialog(context);
                }),
          ),
        ],
      ),
    );
  }
}
