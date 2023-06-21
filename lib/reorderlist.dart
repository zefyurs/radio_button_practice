import 'package:flutter/material.dart';

class ReorderList extends StatefulWidget {
  const ReorderList({super.key});

  @override
  State<ReorderList> createState() => _ReorderListState();
}

class _ReorderListState extends State<ReorderList> {
  final List myTiles = ['1. Flutter App', '2. Create by Coding with Tea', '3. Downloadable', '4. Deliverable'];

  void updateMyTile(int oldIndex, int newIndex) {
    setState(() {
      final tile = myTiles.removeAt(oldIndex);

      myTiles.insert(newIndex, tile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ReorderableListView(children: [
        for (final tile in myTiles)
          ListTile(
            key: ValueKey(tile),
            title: Text(tile),
          )
      ], onReorder: (oldIndex, newIndex) => updateMyTile(oldIndex, newIndex)),
    );
  }
}
