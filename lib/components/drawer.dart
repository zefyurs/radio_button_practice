import 'package:flutter/material.dart';

import '../home_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('부동산 계산기'),
          ),
          ListTile(
            title: const Text('취득세 계산기'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AcquisitionTaxCalulator()));
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
