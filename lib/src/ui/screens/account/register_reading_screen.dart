import 'dart:convert';
import 'dart:io';

import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/providers/reading_form_provider.dart';
import 'package:app_cre/src/ui/screens/screens.dart';
import 'package:app_cre/src/services/services.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterReadingScreen extends StatefulWidget {
  final AccountDetail accountDetail;

  const RegisterReadingScreen({Key? key, required this.accountDetail})
      : super(key: key);

  @override
  State<RegisterReadingScreen> createState() => _RegisterReadingScreenState();
}

class _RegisterReadingScreenState extends State<RegisterReadingScreen> {
  late AccountDetail accountDetail;
  var formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    accountDetail = widget.accountDetail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0XFFF7F7F7),
        endDrawer: SafeArea(child: endDrawer(authService, context)),
        appBar: appBar(context, true),
        body: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text("Registro de lectura de medidor",
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            color: Color(0XFF82BA00),
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 80,
                      alignment: Alignment.center,
                      decoration: customBoxDecoration(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ImageIcon(
                            AssetImage(
                                'assets/icons/vuesax-linear-keyboard-open-blue.png'),
                            color: Color(0XFF3A3D5F),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  accountDetail.aliasName,
                                  style: const TextStyle(
                                      color: Color(0XFF3A3D5F),
                                      fontSize: 16,
                                      fontFamily: "Mulish"),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "C??digo fijo: ",
                                      style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0XFF3A3D5F),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      accountDetail.accountNumber,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          color: Color(0XFF999999),
                                          fontSize: 14),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                        ],
                      )),
                  Expanded(
                      child: ListView(
                    children: [
                      rowData("Titular: ", accountDetail.titularName),
                      rowData(
                          "Fecha ??ltima lectura: ",
                          formatter.format(
                              DateTime.parse(accountDetail.dateLastReading))),
                      const CustomDivider(),
                      Container(
                          height: 40,
                          margin: const EdgeInsets.only(
                              top: 32, bottom: 32, left: 64, right: 64),
                          alignment: Alignment.center,
                          decoration: customBoxDecoration(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "??ltima lectura: ",
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 16,
                                    color: Color(0XFF3A3D5F)),
                              ),
                              Text(
                                accountDetail.lastReading.toString() + " Kwh",
                                style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 16,
                                    color: Color(0XFF666666)),
                              )
                            ],
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset("assets/ejemplo.png"),
                      ),
                      Container(
                          child: ChangeNotifierProvider(
                        create: (_) => ReadingFormProvider(),
                        child: FormCurrentReadingState(
                          lastReading: accountDetail.lastReading,
                          accountDetail: accountDetail,
                        ),
                      ))
                    ],
                  ))
                ]))));
  }

  Widget rowData(String key, String value) {
    return Column(
      children: [
        const CustomDivider(),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          Text(
                            key,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF3A3D5F),
                                fontSize: 14),
                          ),
                          Text(
                            value,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                color: Color(0XFF999999),
                                fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}

class FormCurrentReadingState extends StatefulWidget {
  final int lastReading;
  final AccountDetail accountDetail;

  const FormCurrentReadingState(
      {Key? key, required this.lastReading, required this.accountDetail})
      : super(key: key);

  @override
  State<FormCurrentReadingState> createState() =>
      _FormCurrentReadingStateState();
}

class _FormCurrentReadingStateState extends State<FormCurrentReadingState>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  final double minScale = 1;
  final double maxScale = 4;

  @override
  void initState() {
    controller = TransformationController();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final readingForm = Provider.of<ReadingFormProvider>(context);
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Form(
          key: readingForm.formKey,
          child: Column(children: [
            const _CurrentReading(),
            const SizedBox(
              height: 16,
            ),
            readingForm.image != null
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Foto de la lectura de su medidor",
                          style: TextStyle(
                              color: DarkColor, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          child: Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width - 32,
                            margin: const EdgeInsets.only(top: 16),
                            decoration: customBoxDecoration(20),
                            child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: Image.file(readingForm.image!,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center)),
                          ),
                          onTap: () =>
                              _showDialogImage(context, readingForm.image),
                        )
                      ],
                    ),
                  )
                : const _ImageReading(),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                            gradient: const LinearGradient(colors: [
                              Color(0XFF618A02),
                              Color(0XFF84BD00)
                            ])),
                        child: readingForm.isLoading
                            ? circularProgress()
                            : const Text(
                                'Registrar',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                      ),
                      onPressed: () {
                        if (readingForm.isValidForm() &&
                            !readingForm.isLoading) {
                          if (readingForm.image == null) {
                            _showDialogError(context, readingForm,
                                'Debe cargar una imagen\npara adjuntar a la lectura de medidor.');
                            return;
                          }
                          readingForm.isLoading = true;
                          if (int.parse(readingForm.reading) <=
                              widget.lastReading) {
                            _showDialogError(context, readingForm,
                                'La lectura actual debe ser\nmayor a la ??ltima lectura');
                          } else {
                            TokenService().readToken().then((token) {
                              UserService().readUserData().then((data) {
                                var userData = jsonDecode(data);
                                InvoiceService()
                                    .registerReading(
                                        token,
                                        userData,
                                        widget.accountDetail.accountNumber,
                                        widget.accountDetail.companyNumber,
                                        readingForm.reading, readingForm.image!)
                                    .then((value) {
                                  int code = jsonDecode(value)["Code"];
                                  if (code == 0) {
                                    _showDialogExit(context, readingForm);
                                  } else {
                                    _showDialogError(context, readingForm,
                                        'Se produjo un error\nal registrar la lectura');
                                  }
                                });
                              });
                            });
                          }
                        }
                        FocusScope.of(context).unfocus();
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
                          border: Border.all(
                              color: const Color(0XFF3A3D5F), width: 1.5),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              color: Color(0XFF3A3D5F),
                              fontSize: 16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
            )
          ]),
        ));
  }

  _showDialogImage(context, image) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(2),
        // actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: InteractiveViewer(
                transformationController: controller,
                minScale: minScale,
                maxScale: maxScale,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        image!,
                        width: 500,
                        // fit: BoxFit.cover,
                      )),
                ))),
      ),
    );
  }

  _showDialogExit(context, readingForm) {
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
          'Los datos han sido registrados\npara su procesamiento',
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
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    readingForm.isLoading = false;
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

  _showDialogError(context, readingForm, String message) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(top: 30, bottom: 20, left: 80, right: 80),
        actionsPadding: const EdgeInsets.only(bottom: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Text(
          message,
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
                      'Regresar',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    readingForm.isLoading = false;
                    Navigator.pop(context);
                  })),
        ],
      ),
    );
  }
}

class _CurrentReading extends StatelessWidget {
  const _CurrentReading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readingForm = Provider.of<ReadingFormProvider>(context);
    return TextFormField(
      decoration: InputDecorations.authInputDecoration(
          hintText: 'Digite la lectura actual de su medidor',
          labelText: 'Lectura actual',
          prefixIcon: Icons.watch_later_outlined),
      style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
      initialValue: '',
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        readingForm.reading = value;
      },
      validator: (value) {
        String pattern = r'^\d+$';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value ?? '')) {
          return "Solo se aceptan carateres num??ricos";
        }
      },
    );
  }
}

class _ImageReading extends StatelessWidget {
  const _ImageReading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readingForm = Provider.of<ReadingFormProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          child: Container(
            height: 148,
            width: 160,
            decoration: customBoxDecoration(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: customButtonDecoration(15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          ImageIcon(
                            AssetImage('assets/icons/camera.png'),
                            color: Colors.white,
                            size: 39,
                          ),
                          Text(
                            "C??mara",
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                  const Text(
                    "Tomar foto",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        color: DarkColor,
                        fontWeight: FontWeight.bold),
                  )
                ]),
          ),
          onTap: () => {_pickImage(ImageSource.camera, readingForm)},
        ),
        GestureDetector(
          child: Container(
            height: 148,
            width: 160,
            decoration: customBoxDecoration(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: customButtonDecoration(15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          ImageIcon(
                            AssetImage('assets/icons/gallery.png'),
                            color: Colors.white,
                            size: 39,
                          ),
                          Text(
                            "Galer??a",
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                  const Text(
                    "Adjuntar",
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        color: DarkColor,
                        fontWeight: FontWeight.bold),
                  )
                ]),
          ),
          onTap: () => {_pickImage(ImageSource.gallery, readingForm)},
        )
      ],
    );
  }

  void _pickImage(ImageSource source, readingForm) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file == null) return;
    readingForm.image = File(file.path);
  }
}
