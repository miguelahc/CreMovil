// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import 'package:app_cre/screens/login_screen.dart';

class IntroSliderPage extends StatefulWidget {
  List<Slide> slides = <Slide>[];

  IntroSliderPage({
    Key? key,
    required this.slides,
  }) : super(key: key);
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add(
      Slide(
        title: "Bienvenido a CRE-App",
        description:
            "La manera más fácil de consultar tus facturas de consumo eléctrico.",
        pathImage: "assets/amico.png",
        colorBegin: const Color(0xFF2E6361),
        colorEnd: const Color(0xFF3A3D5F),
      ),
    );
    slides.add(
      Slide(
        title: "Registra tus datos",
        description:
            "Solo debes ingresar 4 datos y podrás ver tus facturas de consumo.\n\n Puedes registrar uno o varios medidores y consultar fechas de emisión, corte y pago.",
        pathImage: "assets/data.png",
        colorBegin: const Color(0xFF2E6361),
        colorEnd: const Color(0xFF3A3D5F),
      ),
    );
    slides.add(
      Slide(
        title: "Descarga tus facturas",
        description:
            "Podrás descargar tus facturas en formato PDF directo a tu celular.\n\n También puedes enviarlas por WhatsApp o compartirlas vía correo electrónico.",
        pathImage: "assets/facturas.png",
        colorBegin: const Color(0xFF2E6361),
        colorEnd: const Color(0xFF3A3D5F),
      ),
    );
    slides.add(
      Slide(
        title: "Servicios y Soporte ",
        description:
            "Ponemos a tu disposición nuestra línea de ayuda y soporte.\n\n También puedes obtener información completa sobre todos nuestros servicios.",
        pathImage: "assets/support.png",
        colorBegin: const Color(0xFF2E6361),
        colorEnd: const Color(0xFF3A3D5F),
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(bottom: 60.0, top: 120.0),
            child: SizedBox(
              height: 200,
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                      child: Image.asset(
                    currentSlide.pathImage.toString(),
                    width: 160.0,
                    height: 160.0,
                    fit: BoxFit.contain,
                  )),
                  Container(
                    child: Text(
                      currentSlide.title.toString(),
                      //style: currentSlide.styleTitle,
                      style: const TextStyle(
                        color: Color(0xFF3A3D5F),
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        decorationThickness: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    margin: const EdgeInsets.only(top: 40.0),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 40),
                    child: Text(
                      currentSlide.description.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Mulish',
                          fontSize: 14.0),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3A3D5F),
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ])),
        ),
        IntroSlider(
          slides: slides,
          renderSkipBtn: const Text(
            "Saltar intro",
            style: TextStyle(color: Color(0xFF84BD00)),
          ),
          renderNextBtn: const Text(
            "Siguiente",
            style: TextStyle(color: Colors.black),
          ),
          renderDoneBtn: const Text("Continuar",
              style: TextStyle(color: Color(0xFF84BD00))),
          // // colorDoneBtn: Colors.white,
          colorActiveDot: const Color(0xFF84BD00),
          sizeDot: 8.0,
          typeDotAnimation: dotSliderAnimation.DOT_MOVEMENT,
          listCustomTabs: renderListCustomTabs(),
          scrollPhysics: const BouncingScrollPhysics(),
          // // shouldHideStatusBar: false,
          onDonePress: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          ),
        )
      ]),
      bottomNavigationBar: const CustomBar(),
    );
  }
}

class CustomBar extends StatelessWidget {
  const CustomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff3A3D5F),
        width: double.infinity,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            //Icon(Icons.info_outline, color: Colors.white),
            //Text(
            //  "  Recuerde pagar sus facturas a tiempo para evitar cortes de energía",
            //  style: TextStyle(
            //   color: Colors.white,
            //      fontFamily: 'Mulish',
            //      fontWeight: FontWeight.bold,
            //      fontSize: 12.0),
            //  textAlign: TextAlign.center,
            // maxLines: 5,
            //),
            Image.asset("assets/Logo.png"),
          ],
        ));
  }
}
