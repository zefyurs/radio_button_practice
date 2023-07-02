// import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'acquisition_tax_cal_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorSchemeSeed: Colors.indigo,
        // fontFamily: 'SCDream',
        fontFamily: GoogleFonts.gothicA1().fontFamily,
        useMaterial3: true,
      ),
      home: const AcquisitionTaxCalulator(),
    );
  }
}
