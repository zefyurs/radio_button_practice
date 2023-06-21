// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String productName;
  final String productDescription;

  const MyButton({
    Key? key,
    required this.productName,
    required this.productDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: const Text("Submit Form"),
    );
  }
}
