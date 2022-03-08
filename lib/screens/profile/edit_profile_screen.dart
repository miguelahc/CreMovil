import 'package:app_cre/providers/edit_profile_form_provider.dart';
import 'package:app_cre/services/auth_service.dart';
import 'package:app_cre/ui/box_decoration.dart';
import 'package:app_cre/ui/colors.dart';
import 'package:app_cre/ui/input_decorations.dart';
import 'package:app_cre/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0XFFF7F7F7),
        resizeToAvoidBottomInset: false,
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: SafeArea(
          child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              margin: const EdgeInsets.only(bottom: 4, right: 16, left: 16),
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              decoration: customBoxDecoration(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Editar Perfil",
                      style: TextStyle(
                          color: SecondaryColor, fontWeight: FontWeight.w600),
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
                                    backgroundImage: const
                                        AssetImage('assets/foto.png'),
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
                create: (_) => EditProfileFormProvider(),
                child: const FormEditProfile())
          ]),
        ));
  }
}

class FormEditProfile extends StatefulWidget {
  const FormEditProfile({Key? key}) : super(key: key);

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
              child: Column(children: const [
                _Name(),
                SizedBox(
                  height: 16,
                ),
                _Email()
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
                onPressed: () {
                  if (editForm.isValidForm() && !editForm.isLoading) {}
                  FocusScope.of(context).unfocus();
                }),
          ])),
    ));
  }
}

class _Name extends StatelessWidget {
  const _Name({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editForm = Provider.of<EditProfileFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Nombre',
          labelText: 'Nombre',
          prefixIcon: Icons.person_outline),
      style: const TextStyle(fontSize: 14),
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        editForm.name = value;
      },
      validator: (value) {
        String pattern = r'[a-zA-Z ]{2,254}';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return "El valor ingresado no es un nombre valido";
        }
      },
    );
  }
}

class _Email extends StatelessWidget {
  const _Email({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editForm = Provider.of<EditProfileFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Email',
          labelText: 'Email',
          prefixIcon: Icons.email_outlined),
      style: const TextStyle(fontSize: 14),
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        editForm.email = value;
      },
      validator: (value) {
        String pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return "El valor ingresado no es un email valido";
        }
      },
    );
  }
}
