import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'form.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(
        fontFamily: GoogleFonts.lato().fontFamily,
        useMaterial3: true,
        scheme: FlexScheme.damask,
        swapLegacyOnMaterial3: true,
      ),
      home: const Scaffold(
        body: MyForm(),
      ),
    );
  }
}
