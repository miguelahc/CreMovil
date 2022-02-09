import 'package:flutter/material.dart';
import 'package:app_cre/providers/login_form_provider.dart';
import 'package:app_cre/ui/input_decorations.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen1 extends StatelessWidget {
  const LoginScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: const _FormLogin(),
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
  const _FormLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.04),
      child: Form(
          key: loginForm.formKey,
          child: Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.45),
            const _Nombres(),
            const SizedBox(height: 20),
            const _Telefono(),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.black87,
                elevation: 0,
                color: const Color(0xFF84BD00),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere por favor ....' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (loginForm.isValidForm()) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  child: const Text(
                                    "Ingresar PIN",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  if (loginForm.isValidForm()) {
                                    Navigator.pushReplacementNamed(
                                        context, 'validar');
                                  }
                                }),
                          ),
                        ],
                      ),
                    );
                  }
                  FocusScope.of(context).unfocus();
                  // //Todo Login Forms
                  if (!loginForm.isValidForm()) return;
                  loginForm.isLoading = true;
                })
          ])),
    );
  }
}

class _Nombres extends StatelessWidget {
  const _Nombres({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Nombres',
          labelText: 'Nombres del usuario',
          prefixIcon: Icons.account_circle),
      initialValue: '',
      textCapitalization: TextCapitalization.words,
      onChanged: (value) => LoginFormProvider().nombreUsuario = value,
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
              // print(value);
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
              prefixIcon: Icons.local_phone_sharp),
          onChanged: (value) => LoginFormProvider().telefonoUsuario = value,
          validator: (value1) {
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

class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}
