import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1final_official/config/constant/const.dart';

class LetterStyle {
  BuildContext context;

  LetterStyle(this.context);

  Size get size => MediaQuery.of(context).size;

  // READ : LETRAS DEL SCREEN AUTH

  TextStyle get tituloHome => GoogleFonts.kaushanScript(
      fontSize: size.width * 0.115,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: shadowKSN2);

  TextStyle get titulo2Home => GoogleFonts.aBeeZee(
      fontSize: size.width * 0.05,
      color: Colors.white,
      // fontWeight: FontWeight.bold,
      shadows: shadowKSN1);

  TextStyle get titleAuth => GoogleFonts.rajdhani(
        fontSize: size.width * 0.08,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  TextStyle get letraInput => GoogleFonts.rajdhani(
        fontSize: size.width * 0.05,
        color: kCuartoColor,
      );

  TextStyle get placeholderInput => GoogleFonts.rajdhani(
        fontSize: size.width * 0.05,
        color: kTerciaryColor,
      );

  TextStyle get letraButton => GoogleFonts.rajdhani(
        fontSize: size.width * 0.05,
        color: Colors.white,
        // fontWeight: FontWeight.bold
      );

  // READ : LETRAS DEL SCREEN COMUNICADOS
  TextStyle get tituloComunicados => GoogleFonts.rajdhani(
        fontSize: size.width * 0.08,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  TextStyle get letra1Comunicados => GoogleFonts.rajdhani(
        color: kCuartoColor,
        fontSize: size.width * 0.045,
        fontWeight: FontWeight.bold,
      );

  TextStyle get letra2Comunicados => GoogleFonts.rajdhani(
        color: kTerciaryColor,
        fontSize: size.width * 0.04,
        fontWeight: FontWeight.bold,
      );

  TextStyle get letra3Comunicados => GoogleFonts.rajdhani(
        color: kTerciaryColor,
        fontSize: size.width * 0.04,
      );

  TextStyle get letra1OptionsComunicados => GoogleFonts.rajdhani(
        color: kCuartoColor,
        fontSize: size.width * 0.06,
        fontWeight: FontWeight.bold,
      );

  TextStyle get letra2OptionsComunicados => GoogleFonts.rajdhani(
        color: kCuartoColor,
        fontSize: size.width * 0.04,
        fontWeight: FontWeight.bold,
      );

  TextStyle get letra3OptionsComunicados => GoogleFonts.rajdhani(
        color: kTerciaryColor,
        fontSize: size.width * 0.04,
        fontWeight: FontWeight.bold,
      );

  // READ : LETRAS DEL VIEW COMUNICADO SCREEN
  TextStyle get tituloViewComunicado => GoogleFonts.rajdhani(
        fontSize: size.width * 0.08,
        fontWeight: FontWeight.bold,
        color: kPrimaryColor,
      );

  TextStyle get letra1ViewComunicado => GoogleFonts.rajdhani(
        color: kPrimaryColor,
        fontSize: size.width * 0.05,
        // fontWeight: FontWeight.bold,
      );

  TextStyle get letra2ViewComunicado => GoogleFonts.rajdhani(
        color: kCuartoColor,
        fontSize: size.width * 0.05,
        // fontWeight: FontWeight.bold,
      );

  TextStyle get letra3ViewComunicado => GoogleFonts.rajdhani(
        color: kCuartoColor,
        fontSize: size.width * 0.08,
        fontWeight: FontWeight.bold,
      );

  // READ :  IA PROFESOR SCREEN

  TextStyle get letra1IAProfesor => GoogleFonts.rajdhani(
        fontSize: size.width * 0.04,
        fontWeight: FontWeight.bold,
        color: kCuartoColor,
      );

  TextStyle get letra2IAProfesor => GoogleFonts.rajdhani(
        fontSize: size.width * 0.045,
        fontWeight: FontWeight.bold,
        color: kCuartoColor,
        height: 1.5,
      );

  TextStyle get letra3IAProfesor => GoogleFonts.rajdhani(
        fontSize: size.width * 0.04,
        fontWeight: FontWeight.w600,
        color: kCuartoColor,
      );

  TextStyle get tituloIAProfesor => GoogleFonts.kaushanScript(
      fontSize: size.width * 0.08,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: shadowKSN2);

  TextStyle get titulo2IAProfesor => GoogleFonts.aBeeZee(
      color: Colors.white,
      // fontWeight: FontWeight.bold,
      fontSize: size.width * 0.05,
      shadows: shadowKSN1);
}
