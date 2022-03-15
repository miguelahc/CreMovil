import 'dart:convert';
import 'package:app_cre/services/services.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:app_cre/models/models.dart';

class ValidateCodScreen extends StatefulWidget {
  final User user;
  const ValidateCodScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ValidateCodScreen> createState() => _ValidateCodScreenState();
}

class _ValidateCodScreenState extends State<ValidateCodScreen> {
  bool onLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(gradient: DarkGradient),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: Color(0XFFF7F7F7),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.27,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              gradient: DarkGradient),
                          child: CustomTitle(
                              title: "Verificación",
                              subtitle: const [
                                "Ingresa el PIN enviado",
                                "vía SMS a tu teléfono"
                              ]),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: Form(
                            //Activando el validador de formulario
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60, right: 60),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.22,
                                        child: Row(
                                          children: <Widget>[
                                            const ImageIcon(
                                              AssetImage(
                                                  'assets/icons/vuesax-linear-mobileXL.png'),
                                              color: Color(0XFF3A3D5F),
                                              size: 38,
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Teléfono",
                                                    style: TextStyle( fontFamily: 'Mulish', color: Color(0XFF999999))),
                                                Text(
                                                  "${widget.user.prefixPhone} ${widget.user.phone}",
                                                  style: const TextStyle( fontFamily: 'Mulish', 
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
                                          selectedColor:
                                              const Color(0xFF84BD00),
                                          inactiveColor:
                                              const Color(0xFF84BD00),
                                        ),
                                        pastedTextStyle: TextStyle( fontFamily: 'Mulish', 
                                          color: Colors.green.shade600,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        length: 4,
                                        onCompleted: (code) {
                                          if (!onLoading) {
                                            setState(() {
                                              onLoading = true;
                                            });
                                            TokenService()
                                                .readToken()
                                                .then((token) {
                                              UserService()
                                                  .getPin(
                                                      token,
                                                      widget.user.phone,
                                                      widget.user.phone)
                                                  .then((response) {
                                                String message = jsonDecode(
                                                    response)['Message'];
                                                var pin = UserService()
                                                    .findPinInPaternString(
                                                        message);
                                                if (code == pin) {
                                                  UserService().saveUserData(
                                                      pin,
                                                      widget.user.name,
                                                      widget.user.phone,
                                                      widget.user.prefixPhone,
                                                      widget.user.prefixPhone +
                                                          widget.user.phone);
                                                  UserService()
                                                      .readUserData()
                                                      .then((data) {
                                                    var userData =
                                                        jsonDecode(data);
                                                    PushNotificationService()
                                                        .readPhonePushId()
                                                        .then((phonePushId) {
                                                      UserService()
                                                          .registerUser(
                                                              token,
                                                              userData,
                                                              phonePushId)
                                                          .then((value) {
                                                        print(value);
                                                      });
                                                    });
                                                  });
                                                  AccountService()
                                                      .getAccounts(
                                                          token,
                                                          pin,
                                                          widget.user.phone,
                                                          widget.user
                                                                  .prefixPhone +
                                                              widget.user.phone)
                                                      .then((value) {
                                                    var data = jsonDecode(
                                                        value)["Message"];
                                                    if (data == "OK") {
                                                      createAccount(context);
                                                    } else {
                                                      List accounts =
                                                          jsonDecode(data);
                                                      // AccountService().getListOfAccounts(data);
                                                      if (accounts.isEmpty) {
                                                        createAccount(context);
                                                      } else {
                                                        setState(() {
                                                          onLoading = false;
                                                        });
                                                        Navigator.of(context)
                                                            .pushNamedAndRemoveUntil(
                                                                'home',
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                      }
                                                    }
                                                  });
                                                } else {
                                                  setState(() {
                                                    onLoading = false;
                                                  });
                                                  _showDialogError(context);
                                                }
                                              });
                                            });
                                          }
                                        },
                                        onChanged: (String value) {},
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08),
                                          const Text(
                                            "¿No recibiste el SMS?",
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(width: 15),
                                          InkWell(
                                            child: const Text(
                                              'Reenviar',
                                              style: TextStyle( fontFamily: 'Mulish', 
                                                  color: Color(0XFF84BD00),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            onTap: () {
                                              if (!onLoading) {
                                                setState(() {
                                                  onLoading = true;
                                                });

                                                TokenService()
                                                    .readToken()
                                                    .then((token) {
                                                  UserService()
                                                      .sendPin(token,
                                                          widget.user.phone)
                                                      .then((value) {
                                                    var code = jsonDecode(
                                                        value)["Code"];
                                                    if (code == 0) {
                                                      setState(() {
                                                        onLoading = false;
                                                      });
                                                      _showDialogExit(
                                                          context, widget.user);
                                                    }
                                                  });
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 32),
                                        child: onLoading
                                            ? circularProgress()
                                            : const SizedBox(),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  )),
                  Container(
                    height: 95,
                    alignment: Alignment.center,
                    child: Footer(dark: true),
                  )
                ],
              ),
            )));
  }

  void createAccount(BuildContext context) {
    setState(() {
      onLoading = false;
    });
    _showDialogCreateAccount(context);
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }

  _showDialogCreateAccount(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          'No existen registros de servicios con el número de teléfono ingresado',
          style: TextStyle( fontFamily: 'Mulish', fontSize: 14),
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
                      'Registrar Servício',
                      style: TextStyle( fontFamily: 'Mulish', color: Colors.white, fontSize: 16),
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
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          'Hemos enviado un mensaje de texto (SMS) con tu PIN de verificación de teléfono',
          style: TextStyle( fontFamily: 'Mulish', fontSize: 14),
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
                      'Ingresar PIN',
                      style: TextStyle( fontFamily: 'Mulish', color: Colors.white, fontSize: 16),
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
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          '¡El PIN ingresado es incorrecto! \n\nPor favor revisa el SMS y vuelve a intentar',
          style: TextStyle( fontFamily: 'Mulish', fontSize: 14),
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
                      style: TextStyle( fontFamily: 'Mulish', color: Colors.white, fontSize: 16),
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
