// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/service.dart';

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

TextField buildTextField(TextEditingController controller, String labelText) {
  return TextField(
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CommaTextInputFormatter()],
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      // prefixIcon: const Icon(CupertinoIcons.),
      suffixIcon: IconButton(
          onPressed: () => controller.clear(),
          icon: const Icon(
            Icons.clear,
            size: 17,
          )),
      contentPadding: const EdgeInsets.only(right: 15, left: 15),

      border: const OutlineInputBorder(),
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 13),
    ),
    // maxLength: 6,
  );
}

Widget buildSegmentedControl(int? value, Map<int, Widget> children, ValueChanged<int?> onChanged) {
  return CupertinoSlidingSegmentedControl<int>(
    groupValue: value,
    children: children,
    onValueChanged: onChanged,
  );
}
