import 'dart:convert';

import 'package:app_cre/src/blocs/blocs.dart';
import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:app_cre/src/providers/login_form_provider.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<Country> countries = List.empty(growable: true);
  bool loadCountries = false;

  @override
  void initState() {
    getCountries();
    super.initState();
  }

  void getCountries() async {
    final token = await TokenService().readToken();
    final response = await CountryService().getCountries(token);
    var message = jsonDecode(response)["Message"];
    List<dynamic> list = jsonDecode(message);
    setState(() {
      countries = CountryService().parseData(list);
      countries.sort((a, b) => a.id.compareTo(b.id));
      loadCountries = true;
    });
  }

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
                                title: "Ingresar",
                                subtitle: const [
                                  "Digite su nombre y número de",
                                  "teléfono para continuar"
                                ]),
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: ChangeNotifierProvider(
                              create: (_) => LoginFormProvider(),
                              child: _FormLogin(countries: countries),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 95,
                    alignment: Alignment.center,
                    child: Footer(dark: true),
                  )
                ],
              ),
            )));
  }
}

class _FormLogin extends StatefulWidget {
  List<Country> countries;

  _FormLogin({Key? key, required this.countries});

  @override
  State<_FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<_FormLogin> {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.04),
      child: Form(
        key: loginForm.formKey,
        child: Column(
            mainAxisAlignment:
                WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
            children: [
              const _Nombres(),
              const SizedBox(height: 15),
              _Telefono(countries: widget.countries),
              const SizedBox(height: 30),
              MaterialButton(
                  padding: const EdgeInsets.all(0),
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
                      decoration: customButtonDecoration(30),
                      child: loginForm.isLoading
                          ? circularProgress()
                          : const Text(
                              'Ingresar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                  onPressed: () {
                    if (loginForm.isValidForm() && !loginForm.isLoading) {
                      loginForm.isLoading = true;
                      var user = loginForm.getValues();
                      TokenService().readToken().then((token) {
                        UserService()
                            .sendPin(token, user.phone, user.prefixPhone)
                            .then((value) {
                          var code = jsonDecode(value)["Code"];
                          var message = jsonDecode(value)["Message"];
                          if (code == 0) {
                            var lastName = jsonDecode(message)["P_NoUsua"];
                            var lastEmail = jsonDecode(message)["P_Emai"];
                            user.name = lastName ?? user.name;
                            user.email = lastEmail ?? user.email;
                            _showDialogExit(context, user, loginForm);
                          } else {
                            _showDialogError(context, loginForm);
                          }
                        });
                      });
                    }
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;
                  }),
            ]),
      ),
    );
  }

  _showDialogExit(context, user, loginForm) {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: const Text(
          'Hemos enviado un mensaje de texto (SMS) con tu PIN de verificación de teléfono',
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
                    'Ingresar PIN',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                onPressed: () {
                  loginForm.isLoading = false;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ValidateCodScreen(user: user)));
                }),
          ),
        ],
      ),
    );
  }

  _showDialogError(context, loginForm) {
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
          'El numero de telefono no es valido, asegurate de ingresar un numero valido ...',
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
                    'Volver a Intentar',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
                onPressed: () {
                  loginForm.isLoading = false;
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
          prefixIcon: Icons.person_outline),
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        loginForm.setName(value);
      },
      validator: (value) {
        String pattern = r'[a-zA-Z ]{2,20}';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return 'El valor ingresado no es un nombre válido.';
        }
        if (value == null || value == '') {
          return 'Este campo es requerido';
        }
        return value.length > 20 ? 'Maximo 20 caracteres' : null;
      },
    );
  }
}

class _Telefono extends StatefulWidget {
  List<Country> countries;

  _Telefono({Key? key, required this.countries});

  @override
  State<_Telefono> createState() => _TelefonoState();
}

class _TelefonoState extends State<_Telefono> {
  @override
  Widget build(BuildContext context) {
    countryBloc.getCountries();
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      alignment: Alignment.center,
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
            width: 100,
            child: widget.countries.isEmpty
                ? withOutData(context, loginForm)
                : withData(context, widget.countries, loginForm)),
        Expanded(
          child: TextFormField(
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
                return "Solo se aceptan caracteres numericos";
              }
              if (value1 == null || value1 == '') {
                return 'Este campo es requerido';
              }
              return value1.length < 4 ? 'Minimo 4 números' : null;
            },
          ),
        )
      ]),
    );
  }

  Widget withData(context, List<Country> data, loginForm) {
    return DropdownButtonFormField(
        isExpanded: true,
        menuMaxHeight: 250,
        value: data[0].code.toString(),
        items: (data
            .map((e) => DropdownMenuItem(
                value: e.code,
                child: Row(children: [
                  Image.memory(
                    base64Decode(e.flag),
                    width: 24,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    e.code.toString(),
                    style: const TextStyle(fontSize: 14),
                  )
                ])))
            .toList()),
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF84BD00)),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF84BD00), width: 2)),
        ),
        onChanged: (value) {
          loginForm.setPrefixPhone(value.toString());
        });
  }

  Widget withOutData(context, loginForm) {
    return SizedBox();
  }
}
