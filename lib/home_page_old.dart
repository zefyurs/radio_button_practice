import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? locationControl = 0;
  int? areaControl = 0;
  int? houseQuantityControl = 0;

  final TextEditingController _tradingPriceController = TextEditingController();
  final TextEditingController _standardPriceController = TextEditingController();

  bool _isTextFieldFocused = false;
  bool _isUnderControlled = false;
  bool _isInitialPurchade = false;

  final Map<int, Widget> locationChildren = const <int, Widget>{
    0: Text('서울'),
    1: Text('수도권'),
    2: Text('광역시'),
    3: Text('기타'),
  };
  final Map<int, Widget> areaChildren = const <int, Widget>{
    0: Text('40m² 이하'),
    1: Text('60m² 이하'),
    2: Text('85m² 이하'),
    3: Text('85m² 초과'),
  };
  final Map<int, Widget> houseQuantityChildren = const <int, Widget>{
    0: Text('1주택자'),
    1: Text('2주택자'),
    2: Text('3주택자'),
    3: Text('그 이상'),
  };

  @override
  void dispose() {
    _standardPriceController.dispose();
    _tradingPriceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isTextFieldFocused) {
      // 텍스트 필드 포커스 해제
      FocusScope.of(context).unfocus();
      _isTextFieldFocused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('부동산 계산기'),
        ),
        body: ListView(
          // padding: const EdgeInsets.all(15),
          children: [
            //
            //* 타이틀
            ListTile(
              // contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calculate),
              title: const Text('취득세 계산(농지외 유상취득)', style: TextStyle(fontSize: 18)),
              iconColor: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                    '취득세는 취득한 날로부터 60일 이내에 신고,납부 해야 합니다. 취득세는 법정신고기한까지 신고하지 않는 경우 납부해야 할 세액의 20%에 해당하는 신고 불성실 가산세가 붙을 수 있습니다.\n\n* 취득세 취득 시기 기준 \n일반적으로 계약상 잔금 지급일이 기준됨(계약일, 사실상잔급지급일과 무관하며 계약서에 잔금 지급일이 명시되어 있지 않은 경우 계약일+60일)\n단, 등기가 계약상 잔금지급일을 앞설 경우, 등기일이 기준됨'),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: buildSegmentedControl(locationControl, locationChildren, (value) {
                setState(() {
                  locationControl = value;
                });
              }),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: buildSegmentedControl(areaControl, areaChildren, (value) {
                setState(() {
                  areaControl = value;
                });
              }),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: buildSegmentedControl(houseQuantityControl, houseQuantityChildren, (value) {
                setState(() {
                  houseQuantityControl = value;
                });
              }),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                children: [
                  Expanded(flex: 1, child: buildTextField(_tradingPriceController, '거래금액(만원)')),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: buildTextField(_standardPriceController, '시가표준(만원)'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('조정대상지역'),
                subtitle: const Text(
                  '서초구, 강남구, 송파구, 용산구(23.01.05기준)',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isUnderControlled,
                onChanged: (bool? value) {
                  setState(() {
                    _isUnderControlled = value!;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(height: 0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('생애최초 구입'),
                value: _isInitialPurchade,
                onChanged: (bool? value) {
                  setState(() {
                    _isInitialPurchade = value!;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(height: 0),
            )
          ],
        ),
      ),
    );
  }

  TextField buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      keyboardType: TextInputType.number,
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
      // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      // padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 3),
      groupValue: value,
      children: children,
      onValueChanged: onChanged,
    );
  }
}
