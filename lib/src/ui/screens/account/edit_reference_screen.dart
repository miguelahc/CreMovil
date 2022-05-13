import 'dart:convert';

import 'package:app_cre/src/blocs/account/account_bloc.dart';
import 'package:app_cre/src/models/account_detail.dart';
import 'package:app_cre/src/providers/edit_refrence_form_provider.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class EditReferenceScreen extends StatefulWidget {
  final AccountDetail account;
  const EditReferenceScreen({Key? key, required this.account}) : super(key: key);

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
        // resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: DarkGradient
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                          color:  const Color(0XFFF7F7F7),
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.27,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                                  gradient: DarkGradient
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(context);
                                        },
                                        icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white,)
                                    ),
                                  ),
                                  CustomTitle(
                                    title: "Editar Referencia", 
                                    subtitle: const [
                                    "Ingresa la información solicitada", 
                                    "para modificar la referencia", 
                                    "de su servicio"
                                    ]),
                                ],
                              )
                            ),
                            Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: ChangeNotifierProvider(
                                    create: (_) => EditReferenceFormProvider(account.aliasName),
                                    child: _FormEditReference(account: account,),
                                  ),
                                )
                            )
                          ],
                        ),
                      )
                  )
                ],
              ),
            )
        )
    );
  }
}

class _FormEditReference  extends StatelessWidget {
  final AccountDetail account;

  const _FormEditReference({required this.account});
  @override
  Widget build(BuildContext context) {
    final referenceForm = Provider.of<EditReferenceFormProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.04),
      child: Form(
          key: referenceForm.formKey,
          child: Column(
              children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            _AliasName(
              reference: account.aliasName,
            ),
            const SizedBox(height: 16),
            Container(
              height: 40,
              decoration: customBoxDecoration(10),
              width: MediaQuery.of(context).size.width - 32,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 24, bottom: 24),
              child: Row(
                children: const [
                  Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child:Icon(Icons.error_outline, color: DarkColor,)
                  ),
                  Text("Minimo 4 y máximo 20 carateres", style: TextStyle( fontFamily: 'Mulish', color: DarkColor),),],
              )
            ),
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 32),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                            padding: const EdgeInsets.all(0),
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
                                TextStyle( fontFamily: 'Mulish', color: Colors.white, fontSize: 16),
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
                              if (!referenceForm.isValidForm()) return;
                            }),
                        MaterialButton(
                            padding: const EdgeInsets.all(0),
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
                                Border.all(color: const Color(0XFF3A3D5F), width: 1.5),
                              ),
                              child: const Text(
                                'Cancelar',
                                style:
                                TextStyle( fontFamily: 'Mulish', color: Color(0XFF3A3D5F), fontSize: 16),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                  )
                ))

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
                      'Aceptar',
                      style: TextStyle( fontFamily: 'Mulish', color: Colors.white, fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    final accountBloc = BlocProvider.of<AccountBloc>(context);
                    accountBloc.reloadAccounts();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(currentPage: 1)));
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
    final registerForm = Provider.of<EditReferenceFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Referencia',
        labelText: 'Referencia',
        prefixIcon: Icons.language,
      ),
      style: const TextStyle( fontFamily: 'Mulish', fontSize: 14),
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
