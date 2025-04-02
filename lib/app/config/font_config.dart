import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontConfig {
  static TextTheme get textTheme => GoogleFonts.bungeeTextTheme();

  static TextStyle get h1 =>
      GoogleFonts.bungee(fontSize: 96, fontWeight: FontWeight.bold);

  static TextStyle get h2 =>
      GoogleFonts.bungee(fontSize: 54, fontWeight: FontWeight.w100);

  static TextStyle get h3 =>
      GoogleFonts.bungee(fontSize: 36, fontWeight: FontWeight.w300);

  static TextStyle get body =>
      GoogleFonts.bungee(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get bodyBold =>
      GoogleFonts.bungee(fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle get caption => GoogleFonts.bungee(fontSize: 14);

  static TextStyle get button =>
      GoogleFonts.bungee(fontSize: 16, fontWeight: FontWeight.bold);
}
