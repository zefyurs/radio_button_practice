// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/service.dart';
import 'explanation.dart';

TextField buildTextField(TextEditingController controller, String labelText, void Function(String)? onChanged) {
  return TextField(
    onChanged: onChanged,
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

// * 설명카드 위젯
class ExplanationCard extends StatefulWidget {
  const ExplanationCard({super.key, required this.isShowInfo, required this.onTap, required this.text});

  final void Function() onTap;
  final bool isShowInfo;
  final String text;

  @override
  State<ExplanationCard> createState() => _ExplanationCardState();
}

class _ExplanationCardState extends State<ExplanationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.isShowInfo
            ? Column(
                children: [Text(widget.text), GestureDetector(onTap: widget.onTap, child: const Text('가리기'))],
              )
            : Column(
                children: [
                  Text(
                    transferIncomeTaxExplanation,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GestureDetector(onTap: widget.onTap, child: const Text('더보기'))
                ],
              ));
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      title: const Text(
        'cal',
        style: TextStyle(
          // fontFamily: GoogleFonts.doHyeon().fontFamily,
          fontSize: 30,
        ),
      ),
    );
  }
}

// * 하단 버튼 위젯
class SubmmitButton extends StatelessWidget {
  const SubmmitButton({super.key, required this.title, required this.onPressed});
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ))),
        ],
      ),
    );
  }
}

// * 취소, 확인 버튼
class DecisionButton extends StatelessWidget {
  const DecisionButton({super.key, required this.title, required this.onPressed});
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonal(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[300])),
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.tonal(
                onPressed: onPressed,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                )),
          ),
        ],
      ),
    );
  }
}

// * 제목 위젯
class SubTitleWidget extends StatelessWidget {
  const SubTitleWidget({super.key, required this.icon, required this.title});

  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // contentPadding: EdgeInsets.zero,
      leading: icon,
      title: Text(title, style: const TextStyle(fontSize: 18)),
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

// * 숫자 -> 글자 위젯
class DisplayDigitToStr extends StatelessWidget {
  const DisplayDigitToStr({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: MediaQuery.of(context).size.width * 0.50,
      child: Container(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

Future<dynamic> myDateTimePicker(BuildContext context, Function(DateTime) onChanged) {
  return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: onChanged,
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: DateTime(2000),
                    maximumDate: DateTime.now().add(const Duration(days: 1 * 365))),
              ),
              SubmmitButton(title: '확인', onPressed: () => Navigator.pop(context)),
            ],
          ),
        );
      });
}

Future<dynamic> myShowDiagram(BuildContext context, String title, String explanation) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          content: Text(explanation),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인')),
          ],
        );
      });
}
