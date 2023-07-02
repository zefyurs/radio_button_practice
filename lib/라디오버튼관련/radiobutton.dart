import 'package:flutter/material.dart';

enum ProductTypeEnum { downLoadable, deliverable }

class MyRadioButton extends StatelessWidget {
  const MyRadioButton({
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
      value: ProductTypeEnum.downLoadable,
      groupValue:
          productTypeEnum.toString() == 'Downloadable' ? ProductTypeEnum.downLoadable : ProductTypeEnum.deliverable,
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
