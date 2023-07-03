import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.indigoM3,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          // useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        //hahmlet,
        // fontFamily: 'GowunDodum-Regular',
        fontFamily: 'GowunDodum-Regular',

        useMaterial3: true,
        //indigoM3, limeM3,
        swapLegacyOnMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
