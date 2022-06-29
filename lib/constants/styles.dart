// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {


  static TextStyle textDecoration({
    Color color = AppTheme.primaryText,
    FontWeight fontWeight = FontWeight.w700,
    double fontSize = 15,
  }) {
    return GoogleFonts.aBeeZee(
        textStyle: TextStyle(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
            letterSpacing: 0.6));
  }

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: AppTheme.filler),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: AppTheme.filler),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.secondaryText, width: 2.0),
        borderRadius: BorderRadius.circular(8),
      ),
      labelText: label,
      filled: true,
      fillColor: AppTheme.background,
      labelStyle:
          TextStyle(color: AppTheme.filler, fontWeight: FontWeight.w500),
    );
  }
}
