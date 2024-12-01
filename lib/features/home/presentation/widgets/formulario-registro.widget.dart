import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1final_official/config/constant/const.dart';

class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({super.key});

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  String _email = "";
  String _contrasena = "";
  String _telefono = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final decoration1 = BoxDecoration(
      borderRadius: BorderRadius.circular(size.width * 0.03),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: kCuartoColor,
          offset: Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
    );
    const decoration2 = BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/logo.jpeg"), fit: BoxFit.cover),
    );

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.025),
      width: size.width * 0.8,
      height: size.height * 0.55,
      decoration: decoration1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: size.width * 0.2,
            height: size.height * 0.1,
            decoration: decoration2,
          ),
          TextFormFieldCustom(
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
            textPlaceholder: 'Correo Electrónico',
            icon: Icons.email,
          ),
          TextFormFieldCustom(
            onChanged: (value) {
              setState(() {
                _contrasena = value;
              });
            },
            textPlaceholder: 'Contraseña',
            icon: Icons.lock,
            isPassword: true,
          ),
          TextFormFieldCustom(
            onChanged: (value) {
              setState(() {
                _telefono = value;
              });
            },
            textPlaceholder: 'Teléfono',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          GestureDetector(
            onTap: () {
              // Aquí iría la lógica de registro
              print('Email: $_email');
              print('Contraseña: $_contrasena');
              print('Teléfono: $_telefono');
              context.push(
                  "/map"); // O la ruta que corresponda después del registro
            },
            child: Container(
              decoration: BoxDecoration(
                color: kCuartoColor,
                borderRadius: BorderRadius.circular(size.width * 0.025),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.028,
                vertical: size.height * 0.013,
              ),
              child: Text(
                "Registrarse",
                style: letterStyle.letraButton,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    super.key,
    required this.onChanged,
    required this.textPlaceholder,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
  });

  final ValueChanged<String> onChanged;
  final String textPlaceholder;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      hintText: textPlaceholder,
      hintStyle: letterStyle.placeholderInput,
      prefixIcon: Icon(icon),
      prefixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused) ? kCuartoColor : kTerciaryColor),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: kCuartoColor,
          width: 2,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: kTerciaryColor,
          width: 1,
        ),
      ),
      floatingLabelStyle:
          WidgetStateTextStyle.resolveWith((states) => GoogleFonts.rajdhani(
                color: states.contains(WidgetState.focused)
                    ? kCuartoColor
                    : kTerciaryColor,
                fontSize: size.width * 0.04,
              )),
    );

    return TextFormField(
      onChanged: onChanged,
      style: letterStyle.letraInput,
      cursorColor: kCuartoColor,
      decoration: decoration,
      obscureText: isPassword,
      keyboardType: keyboardType,
    );
  }
}
