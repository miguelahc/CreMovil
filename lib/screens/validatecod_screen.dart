import 'package:flutter/material.dart';
import 'package:app_cre/providers/login_form_provider.dart';
import 'package:app_cre/ui/input_decorations.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ValidatecodScreen extends StatelessWidget {
  const ValidatecodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        //Activando el validador de formulario
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Stack(
          children: [
            const LoginBackground(),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3),
                      const Text(
                        "Teléfono",
                        style: TextStyle(
                          color: Color(0xFFA39F9F),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      // onCompleted: (v) {
                      //   if (v.length == 4) {
                      //     Navigator.pushReplacementNamed(context, 'validar');
                      //   }
                      // },
                      onChanged: (value) => {
                            if (value.length == 4)
                              {
                                // LoginFormProvider().nombreUsuario = value
                                Navigator.pushReplacementNamed(context, 'home')
                              }
                          }),
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
                      const Text(
                        "    Reenviar",
                        style: TextStyle(
                          color: Color(0xFF84BD00),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
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
}
