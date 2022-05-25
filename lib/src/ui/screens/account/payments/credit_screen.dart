import 'package:app_cre/src/ui/components/components.dart';
import 'package:flutter/material.dart';

class CreditScreen extends StatefulWidget {
  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, left: 2, right: 2),
            height: 40,
            decoration: customBoxDecoration(10),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: ImageIcon(
                    AssetImage('assets/icons/info-circle.png'),
                    color: DarkColor,
                  ),
                ),
                Text(
                  "¡Los datos de tu tarjeta no serán guardados!",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: DarkColor),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 2, right: 2),
            padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
            decoration: customBoxDecoration(10),
            child: Column(
              children: [
                TextFormField(
                  initialValue: '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre del titular de la tarjeta',
                      labelText: 'Nombre del titular de la tarjeta',
                      prefixIcon: null),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) => {},
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
                SizedBox(height: 16,),
                TextFormField(
                  initialValue: '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nro. de la Tarjeta',
                      labelText: 'Nro. de la Tarjeta',
                      prefixIcon: null),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) => {},
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
                const SizedBox(height: 16,),
                TextFormField(
                  initialValue: '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Fecha de caducidad: MM/AA',
                      labelText: 'Fecha de caducidad: MM/AA',
                      prefixIcon: null),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) => {},
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
                const SizedBox(height: 16,),
                TextFormField(
                  initialValue: '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Código de Autorización: CVV',
                      labelText: 'Código de Autorización: CVV',
                      prefixIcon: null),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) => {},
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
