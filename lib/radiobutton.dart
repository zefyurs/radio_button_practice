import 'package:flutter/material.dart';

enum ProductTypeEnum { Downloadable, Deliverable }

class MyRadioButton extends StatelessWidget {
  MyRadioButton({
    super.key,
    required this.title,
    required this.value,
    required this.productTypeEnum,
    required this.onchanged,
  });

  final String title;
  final ProductTypeEnum value;
  final ProductTypeEnum? productTypeEnum;
  final void Function(ProductTypeEnum?)? onchanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ProductTypeEnum>(
      title: Text(title),
      value: ProductTypeEnum.Downloadable,
      groupValue:
          productTypeEnum.toString() == 'Downloadable' ? ProductTypeEnum.Downloadable : ProductTypeEnum.Deliverable,
      dense: true,
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // tileColor: Theme.of(context).colorScheme.primaryContainer,
      tileColor: Colors.white,
      onChanged: onchanged,
    );
  }
}
