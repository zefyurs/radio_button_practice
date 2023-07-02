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

// * 숫자를 한글로 변환
String chagneDigitToStrTypeNumber(double amount) {
  const units = ['', '만', '억', '조', '경'];

  int unitIndex = 0;
  while (amount >= 10000 && unitIndex < units.length - 1) {
    amount /= 10000;
    unitIndex++;
  }

  String result;
  if (amount % 1 == 0) {
    result = '${amount.toInt()}${units[unitIndex]}원';
  } else {
    String formattedAmount = amount.toStringAsFixed(1).replaceAll('.0', '');
    result = '$formattedAmount${units[unitIndex]}원';
  }

  return result;
}
