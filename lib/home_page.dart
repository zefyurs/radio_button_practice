import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_button_practice/service/service.dart';

class AcquisitionTaxCalulator extends StatefulWidget {
  const AcquisitionTaxCalulator({super.key});

  @override
  State<AcquisitionTaxCalulator> createState() => _AcquisitionTaxCalulatorState();
}

class _AcquisitionTaxCalulatorState extends State<AcquisitionTaxCalulator> {
  int? locationControl = 0;
  int? underOver85 = 0;
  int? howManyHouseRestrictionControl = 0;
  int? howManyHouseNonRestrictionControl = 0;

  double _acquisitionTax = 0;
  double _specialTaxForRural = 0;
  double _localEducationTax = 0;

  final TextEditingController _tradingPriceController = TextEditingController();
  final TextEditingController _standardPriceController = TextEditingController();

  bool _isShowInfo = false;
  bool _isTextFieldFocused = false;
  bool _isRestrictionArea = false;

  final Map<int, Widget> locationChildren = const <int, Widget>{
    0: Text('서울'),
    1: Text('수도권'),
    2: Text('광역시'),
    3: Text('기타'),
  };
  final Map<int, Widget> areaChildren = const <int, Widget>{
    0: Text('전용 85m² 이하주택'),
    1: Text('전용 85m² 이상주택'),
  };
  final Map<int, Widget> howManyHouseRestrictionWidget = const <int, Widget>{
    0: Text(
      '1주택, 일시적2주택',
      style: TextStyle(fontSize: 12),
    ),
    1: Text('2주택'),
    2: Text('3주택이상'),
  };
  final Map<int, Widget> howManyHouseNonRestrictionWidget = const <int, Widget>{
    0: Text(
      '2주택이하, 중과제외',
      style: TextStyle(fontSize: 12),
    ),
    1: Text('3주택'),
    2: Text('4주택이상'),
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

  void calculateAcquisitionTax() {
    // remove commas
    String formatteredText = _tradingPriceController.text.replaceAll(',', '');
    double tradingPrice = double.parse(formatteredText);
    double tradingPriceAfterRate = 0;
    double specialTaxforRuralAfterRate = 0;
    double localEducationTex = 0;

    if (!_isRestrictionArea && howManyHouseNonRestrictionControl == 0) {
      // ! 6억 이하
      if (tradingPrice <= 600000000) {
        // * 취득세율
        tradingPriceAfterRate = tradingPrice * 0.01;
        // * 지방교육세
        localEducationTex = tradingPrice * 0.001;

        // ! 6억 초과 ~ 9억 이하
      } else if (tradingPrice > 600000000 && tradingPrice <= 900000000) {
        // * 취득세율
        tradingPriceAfterRate =
            tradingPrice * (double.parse((((tradingPrice / 100000000 * 2 / 3) - 3) / 100).toStringAsFixed(4)));
        // * 지방교육세
        localEducationTex = _acquisitionTax * 0.01;

        // ! 9억 초과
      } else {
        // * 취득세율
        tradingPriceAfterRate = tradingPrice * 0.03;
        // * 지방교육세
        localEducationTex = tradingPrice * 0.03;
      }
      //* 농어촌특별세
      if (underOver85 == 1) {
        specialTaxforRuralAfterRate = tradingPrice * 0.002;
      }
    } else if (_isRestrictionArea && howManyHouseRestrictionControl == 0) {
      // ! 6억 이하
      if (tradingPrice <= 600000000) {
        // * 취득세율
        tradingPriceAfterRate = tradingPrice * 0.01;
        // * 지방교육세
        localEducationTex = tradingPrice * 0.001;

        // ! 6억 초과 ~ 9억 이하
      } else if (tradingPrice > 600000000 && tradingPrice <= 900000000) {
        // * 취득세율
        tradingPriceAfterRate =
            tradingPrice * (double.parse((((tradingPrice / 100000000 * 2 / 3) - 3) / 100).toStringAsFixed(4)));
        // * 지방교육세
        localEducationTex = _acquisitionTax * 0.001;
        // ! 9억 초과
      } else {
        // * 취득세율
        tradingPriceAfterRate = tradingPrice * 0.03;
        // * 지방교육세
        localEducationTex = tradingPrice * 0.003;
      }
      //* 농어촌특별세
      if (underOver85 == 1) {
        specialTaxforRuralAfterRate = tradingPrice * 0.002;
      }
      // ! 조정대상지역 2주택자
    } else if (_isRestrictionArea && howManyHouseRestrictionControl == 1) {
      // * 취득세율
      tradingPriceAfterRate = tradingPrice * 0.08;
      //* 농어촌특별세
      if (underOver85 == 1) {
        specialTaxforRuralAfterRate = tradingPrice * 0.006;
      }
      // * 지방교육세
      localEducationTex = tradingPrice * 0.004;

      // ! 3주택자
    } else if (!_isRestrictionArea && howManyHouseNonRestrictionControl == 1) {
      // * 취득세율
      tradingPriceAfterRate = tradingPrice * 0.08;
      //* 농어촌특별세
      if (underOver85 == 1) {
        specialTaxforRuralAfterRate = tradingPrice * 0.006;
      }
      // * 지방교육세
      localEducationTex = tradingPrice * 0.004;
      // ! 조정대상지역 3주택 이상
    } else if (_isRestrictionArea && howManyHouseRestrictionControl == 2) {
      // * 취득세율
      tradingPriceAfterRate = tradingPrice * 0.12;
      //* 농어촌특별세
      if (underOver85 == 1) {
        specialTaxforRuralAfterRate = tradingPrice * 0.001;
      }
      // * 지방교육세
      localEducationTex = tradingPrice * 0.004;
      // ! 4주택 이상
    } else if (!_isRestrictionArea && howManyHouseNonRestrictionControl == 2) {
      // * 취득세율
      tradingPriceAfterRate = tradingPrice * 0.12;
      //* 농어촌특별세
      if (underOver85 == 1) {
        specialTaxforRuralAfterRate = tradingPrice * 0.006;
      }
      // * 지방교육세
      localEducationTex = tradingPrice * 0.004;
      // ! 조정대상지역 3주택 이상
    } else if (_isRestrictionArea && howManyHouseRestrictionControl == 2) {
      // * 취득세율
      tradingPriceAfterRate = tradingPrice * 0.12;
      //* 농어촌특별세
      if (underOver85 == 1) {
        specialTaxforRuralAfterRate = tradingPrice * 0.006;
      }
      // * 지방교육세
      localEducationTex = tradingPrice * 0.004;
    }

    setState(() {
      _acquisitionTax = tradingPriceAfterRate;
      _specialTaxForRural = specialTaxforRuralAfterRate;
      _localEducationTax = localEducationTex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('부동산 계산기'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text('부동산 계산기'),
                  ),
                  ListTile(
                    title: const Text('취득세 계산기'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AcquisitionTaxCalulator()));
                    },
                  ),
                  ListTile(
                    title: const Text('Item 2'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
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
                      child: _isShowInfo
                          ? Column(
                              children: [
                                const Text(
                                    '취득세는 취득한 날로부터 60일 이내에 신고,납부 해야 합니다. 취득세는 법정신고기한까지 신고하지 않는 경우 납부해야 할 세액의 20%에 해당하는 신고 불성실 가산세가 붙을 수 있습니다.\n\n* 취득세 취득 시기 기준 \n일반적으로 계약상 잔금 지급일이 기준됨(계약일, 사실상잔급지급일과 무관하며 계약서에 잔금 지급일이 명시되어 있지 않은 경우 계약일+60일)\n단, 등기가 계약상 잔금지급일을 앞설 경우, 등기일이 기준됨'),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isShowInfo = !_isShowInfo;
                                      });
                                    },
                                    child: const Text('가리기'))
                              ],
                            )
                          : Column(
                              children: [
                                const Text(
                                    '취득세는 취득한 날로부터 60일 이내에 신고,납부 해야 합니다. 취득세는 법정신고기한까지 신고하지 않는 경우 납부해야 할 세액의 20%에 해당하는 신고 불성실 가산세가 붙을 수 있습니다.'),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isShowInfo = !_isShowInfo;
                                      });
                                    },
                                    child: const Text('더보기'))
                              ],
                            )),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: [
                      Expanded(child: buildTextField(_tradingPriceController, '과세표준액(매매가)')),
                      const SizedBox(width: 15),
                      const Text('원', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: buildSegmentedControl(underOver85, areaChildren, (value) {
                    setState(() {
                      underOver85 = value;
                    });
                  }),
                ),
                // * 조정대상지역 선택
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('조정대상지역'),
                    subtitle: const Text(
                      '서초구, 강남구, 송파구, 용산구(23.01.05기준)',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _isRestrictionArea,
                    onChanged: (bool? value) {
                      setState(() {
                        _isRestrictionArea = value!;
                      });
                    },
                  ),
                ),

                // * 주택수 선택
                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: _isRestrictionArea
                        ? buildSegmentedControl(howManyHouseRestrictionControl, howManyHouseRestrictionWidget, (value) {
                            setState(() {
                              howManyHouseRestrictionControl = value;
                            });
                          })
                        : buildSegmentedControl(howManyHouseNonRestrictionControl, howManyHouseNonRestrictionWidget,
                            (value) {
                            setState(() {
                              howManyHouseNonRestrictionControl = value;
                            });
                          })),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DataTable(columns: const [
                    DataColumn(label: Text('세목')),
                    DataColumn(label: Text('세액')),
                  ], rows: [
                    DataRow(cells: [
                      const DataCell(Text('취득세')),
                      DataCell(Text(formatWithCommas(_acquisitionTax.ceilToDouble()).toString())),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('농어촌특별세')),
                      DataCell(Text(formatWithCommas(_specialTaxForRural.ceilToDouble()).toString())),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('지방교육세')),
                      DataCell(Text(formatWithCommas(_localEducationTax.ceilToDouble()).toString())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(
                        '합계',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      )),
                      DataCell(Text(
                        formatWithCommas(_acquisitionTax.ceilToDouble() + _localEducationTax.ceilToDouble()).toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),

                // * 계산하기
                Align(
                    child: SizedBox(
                        width: 200,
                        child: ElevatedButton(onPressed: calculateAcquisitionTax, child: const Text('계산하기')))),
              ],
            ),
          ),
        ),
      ),
    );
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
      // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      // padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 3),
      groupValue: value,
      children: children,
      onValueChanged: onChanged,
    );
  }
}
