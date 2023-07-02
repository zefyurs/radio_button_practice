import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateSettingButtomSheet extends StatelessWidget {
  const DateSettingButtomSheet({
    super.key,
    required this.initialDate,
    this.submitTitle = '선택',
    this.bottomWidget,
  });
  final DateTime initialDate;
  final String submitTitle;
  final Widget? bottomWidget;
  // final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final initialDateTime = DateTime(now.year, now.month, now.day);
    DateTime setDateTimes = initialDateTime;

    return Column(
      children: [
        CupertinoDatePicker(
          initialDateTime: initialDateTime,
          onDateTimeChanged: (dateTime) {
            setDateTimes = dateTime;
          },
          mode: CupertinoDatePickerMode.date,
        ),
        const SizedBox(height: 8),
        // if (bottomWidget != null) bottomWidget!,
        // if (bottomWidget != null)
        //   const SizedBox(
        //     height: 20,
        //   ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: SizedBox(
        //         height: 10,
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //               foregroundColor: Colors.black,
        //               backgroundColor: Colors.white,
        //               textStyle: Theme.of(context).textTheme.titleMedium),
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //           child: const Text("취소"),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     Expanded(
        //         child: SizedBox(
        //             height: 10,
        //             child: ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                     foregroundColor: Colors.white,
        //                     backgroundColor: Colors.black,
        //                     textStyle: Theme.of(context).textTheme.titleMedium),
        //                 onPressed: () {
        //                   Navigator.pop(context, setDateTimes);
        //                 },
        //                 child: Text(submitTitle)))),
        // ],
        // ),
      ],
    );
  }
}
