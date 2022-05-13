import 'dart:convert';

import 'package:app_cre/src/providers/edit_profile_form_provider.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  String name;
  String email;

  EditProfileScreen({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _name;
  late String _email;

  @override
  void initState() {
    _name = widget.name;
    _email = widget.email;
    super.initState();
  }

  loadData() async {
    var data = await UserService().readUserData();
    var userData = jsonDecode(data);
    setState(() {
      _name = userData["Name"];
      _email = userData["Email"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0XFFF7F7F7),
        // resizeToAvoidBottomInset: false,
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: SafeArea(
          child: Column(children: [
            Expanded(child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                      ? MediaQuery.of(context).size.height * 0.25
                      : MediaQuery.of(context).size.height * 0.35,
                  margin: const EdgeInsets.only(bottom: 4, right: 16, left: 16, top: 4),
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  decoration: customBoxDecoration(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Editar Perfil",
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              color: SecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child:
                            Stack(alignment: Alignment.bottomRight, children: [
                              Container(
                                  height: 124,
                                  width: 124,
                                  child: DottedBorder(
                                    padding: const EdgeInsets.all(4),
                                    borderType: BorderType.Circle,
                                    dashPattern: const [10, 5, 10, 5, 10, 5],
                                    child: CircleAvatar(
                                      radius: MediaQuery.of(context).size.width,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: MediaQuery.of(context).size.width,
                                        backgroundImage:
                                        const AssetImage('assets/foto.png'),
                                      ),
                                    ),
                                  )),
                              Container(
                                  height: 35,
                                  width: 35,
                                  decoration: customBoxDecoration(18),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const ImageIcon(
                                      AssetImage(
                                          'assets/icons/vuesax-linear-edit.png'),
                                      color: SecondaryColor,
                                    ),
                                  ))
                            ]),
                          ),
                        )
                      ]),
                ),
                ChangeNotifierProvider(
                    create: (_) => EditProfileFormProvider(_name, _email),
                    child: FormEditProfile(name: _name, email: _email))
              ],
            ))
          ]),
        ));
  }
}

class FormEditProfile extends StatefulWidget {
  String name;
  String email;

  FormEditProfile({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  State<FormEditProfile> createState() => _FormEditProfileState();
}

class _FormEditProfileState extends State<FormEditProfile> {
  @override
  Widget build(BuildContext context) {
    final editForm = Provider.of<EditProfileFormProvider>(context);
    return Container(
        child: Form(
      key: editForm.formKey,
      child: Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(left: 24, right: 24),
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(children: [
                _Name(name: widget.name),
                const SizedBox(
                  height: 16,
                ),
                _Email(email: widget.email)
              ]),
            ),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                          colors: [Color(0XFF618A02), Color(0XFF84BD00)])),
                  child: editForm.isLoading
                      ? circularProgress()
                      : const Text(
                          'Guardar',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              color: Colors.white,
                              fontSize: 16),
                        ),
                ),
                onPressed: () async {
                  if (editForm.isValidForm() && !editForm.isLoading) {
                    editForm.isLoading = true;
                    var token = await TokenService().readToken();
                    var data = await UserService().readUserData();
                    var userData = jsonDecode(data);
                    UserService().saveUserData(
                        userData["Pin"],
                        editForm.name,
                        userData["PhoneNumber"],
                        editForm.email,
                        userData["PrefixPhone"],
                        userData["PhoneImei"]);
                    var dataUpdate = await UserService().readUserData();
                    var userDataUpdate = jsonDecode(dataUpdate);
                    print(userDataUpdate.toString());
                    var phonePushId =
                        await PushNotificationService().readPhonePushId();
                    UserService()
                        .registerUser(token, userDataUpdate, phonePushId)
                        .then((value) {
                      var code = jsonDecode(value)["Code"];
                      if (code == 0) {
                        _showDialogExit(context);
                        editForm.isLoading = false;
                      } else {
                        _showDialogError(context);
                        editForm.isLoading = false;
                      }
                    });
                  }
                  FocusScope.of(context).unfocus();
                }),
          ])),
    ));
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
          '¡Tus datos se han guardado!',
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
                      style:
                          TextStyle(fontFamily: 'Mulish', color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(currentPage: 2)));
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
          '¡Ocurrio un error al guardar tus datos!',
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
                      style:
                          TextStyle(fontFamily: 'Mulish', color: Colors.white),
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

class _Name extends StatelessWidget {
  String name;

  _Name({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editForm = Provider.of<EditProfileFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Nombre',
          labelText: 'Nombre',
          prefixIcon: Icons.person_outline),
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      textCapitalization: TextCapitalization.words,
      initialValue: name,
      onChanged: (value) {
        editForm.name = value;
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

class _Email extends StatelessWidget {
  String email;

  _Email({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editForm = Provider.of<EditProfileFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Email',
          labelText: 'Email',
          prefixIcon: Icons.email_outlined),
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      textCapitalization: TextCapitalization.words,
      initialValue: email,
      onChanged: (value) {
        editForm.email = value.toString().trim();
      },
      validator: (value) {
        String pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+(\s?)*$";
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return "El valor ingresado no es un email valido";
        }
      },
    );
  }
}
