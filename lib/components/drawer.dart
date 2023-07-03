import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final int pageIndex;
  final Function(int) onPageSelected;

  const MyDrawer({super.key, required this.pageIndex, required this.onPageSelected});

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
            leading: const Icon(Icons.calculate),
            title: const Text('취득세 계산기'),
            onTap: () {
              onPageSelected(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('양도소득세 계산기'),
            onTap: () {
              onPageSelected(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('창 닫기'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
