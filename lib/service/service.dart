import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final formatter = NumberFormat('#,###');
    final newString = formatter.format(int.tryParse(newValue.text) ?? 0);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

String formatWithCommas(double value) {
  String formattedValue = value.ceil().toString();
  final RegExp regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  formattedValue = formattedValue.replaceAllMapped(regExp, (Match match) => '${match[1]},');
  return formattedValue;
}
