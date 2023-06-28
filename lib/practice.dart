import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  int _sum = 0;

  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();

  void summary() {
    setState(() {
      _sum = int.parse(_aController.text) + int.parse(_bController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('더하기'),
      ),
      body: Column(
        children: [
          TextField(
              controller: _aController,
              decoration: const InputDecoration(
                hintText: '숫자를 입력하세요',
              )),
          TextField(
              controller: _bController,
              decoration: const InputDecoration(
                hintText: '숫자를 입력하세요',
              )),
          TextButton(
            onPressed: summary,
            child: Text('더하기'),
          ),
          Text('합계: $_sum'),
        ],
      ),
    );
  }
}
