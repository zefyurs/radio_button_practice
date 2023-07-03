import 'package:flutter/material.dart';
import 'package:radio_button_practice/transferincometax_cal_page.dart';

import 'acquisition_cal_page.dart';
import 'components/widget.dart';
import 'components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    const AcquisitionCalculator(),
    const TransferIncomeTaxCalculator(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
              appBar: const MyAppBar(),
              drawer: MyDrawer(
                pageIndex: _pageIndex,
                onPageSelected: (int index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
              ),
              body: _pages[_pageIndex]),
        ),
      ),
    );
  }
}
