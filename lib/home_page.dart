import 'package:flutter/material.dart';
import 'package:radio_button_practice/service/service.dart';

import 'components/button.dart';
import 'components/drawer.dart';
import 'components/explanation.dart';

class AcquisitionTaxCalulator extends StatefulWidget {
  const AcquisitionTaxCalulator({super.key});

  @override
  State<AcquisitionTaxCalulator> createState() => _AcquisitionTaxCalulatorState();
}

class _AcquisitionTaxCalulatorState extends State<AcquisitionTaxCalulator> {
  int? locationControl = 0;
  int? _isUnderOrOver85 = 0;
  int? howManyHouseRestrictionControl = 0;
  int? howManyHouseNonRestrictionControl = 0;

  double _acquisitionTax = 0;
  double _acquisitionTaxRate = 0;
  double _specialTaxForRural = 0;
  double _specialTaxForRuralRate = 0;
  double _localEducationTax = 0;
  double _localEducationTaxRate = 0;

  final TextEditingController _tradingPriceController = TextEditingController();

  bool _isShowInfo = false;
  bool _isTextFieldFocused = false;
  bool _isRestrictionArea = false;
  bool _isFirstBuying = false;

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
    _tradingPriceController.dispose();
    super.dispose();
  }

  void calculateAcquisitionTax() {
    // remove commas
    String formatteredText = _tradingPriceController.text.replaceAll(',', '');
    double tradingPrice = double.parse(formatteredText);

    double acquisitionTaxRate;
    double localEducationTaxRate;
    double specialTaxforRuralAfterRate;

    // ? #### 비조정대상
    // * 비조정대상지역 1~2주택자
    if (!_isRestrictionArea && howManyHouseNonRestrictionControl == 0) {
      if (tradingPrice <= 600000000) {
        acquisitionTaxRate = 0.01;
        localEducationTaxRate = 0.001;
      } else if (tradingPrice > 600000000 && tradingPrice <= 900000000) {
        acquisitionTaxRate = (double.parse((((tradingPrice / 100000000 * 2 / 3) - 3) / 100).toStringAsFixed(4)));
        localEducationTaxRate = acquisitionTaxRate * 0.1;
      } else {
        acquisitionTaxRate = 0.03;
        localEducationTaxRate = 0.003;
      }
      if (_isUnderOrOver85 == 1) {
        specialTaxforRuralAfterRate = 0.002;
      } else {
        specialTaxforRuralAfterRate = 0;
      }

      // * 비조정대상지역 3주택자
    } else if (!_isRestrictionArea && howManyHouseNonRestrictionControl == 1) {
      acquisitionTaxRate = 0.08;
      if (_isUnderOrOver85 == 1) {
        specialTaxforRuralAfterRate = 0.006;
      } else {
        specialTaxforRuralAfterRate = 0;
      }
      localEducationTaxRate = 0.004;

      // * 비조정대상지역 4주택 이상
    } else if (!_isRestrictionArea && howManyHouseNonRestrictionControl == 2) {
      // * 취득세율
      acquisitionTaxRate = 0.12;
      //* 농어촌특별세
      if (_isUnderOrOver85 == 1) {
        specialTaxforRuralAfterRate = 0.006;
      } else {
        specialTaxforRuralAfterRate = 0;
      }
      // * 지방교육세
      localEducationTaxRate = 0.004;

      // ? #### 조정대상
      // * 조정대상지역 1주택자
    } else if (_isRestrictionArea && howManyHouseRestrictionControl == 0) {
      if (tradingPrice <= 600000000) {
        acquisitionTaxRate = 0.01;
        localEducationTaxRate = 0.001;
      } else if (tradingPrice > 600000000 && tradingPrice <= 900000000) {
        acquisitionTaxRate = (double.parse((((tradingPrice / 100000000 * 2 / 3) - 3) / 100).toStringAsFixed(4)));
        localEducationTaxRate = acquisitionTaxRate * 0.1;
      } else {
        acquisitionTaxRate = 0.03;
        localEducationTaxRate = 0.003;
      }
      if (_isUnderOrOver85 == 1) {
        specialTaxforRuralAfterRate = 0.002;
      } else {
        specialTaxforRuralAfterRate = 0;
      }

// * 조정대상지역 2주택자
    } else if (_isRestrictionArea && howManyHouseRestrictionControl == 1) {
      acquisitionTaxRate = 0.08;
      if (_isUnderOrOver85 == 1) {
        specialTaxforRuralAfterRate = 0.006;
      } else {
        specialTaxforRuralAfterRate = 0;
      }
      localEducationTaxRate = 0.004;

// * 조정대상지역 3주택 이상
    } else if (_isRestrictionArea && howManyHouseRestrictionControl == 2) {
      acquisitionTaxRate = 0.12;
      if (_isUnderOrOver85 == 1) {
        specialTaxforRuralAfterRate = 0.01;
      } else {
        specialTaxforRuralAfterRate = 0;
      }
      localEducationTaxRate = 0.004;

// * 조정대상지역 4주택 이상
    } else {
      acquisitionTaxRate = 0.12;
      if (_isUnderOrOver85 == 1) {
        specialTaxforRuralAfterRate = 0.01;
      } else {
        specialTaxforRuralAfterRate = 0;
      }
      localEducationTaxRate = 0.004;
    }

    setState(() {
      _acquisitionTax = tradingPrice * acquisitionTaxRate;
      _acquisitionTaxRate = acquisitionTaxRate;
      _specialTaxForRural = tradingPrice * specialTaxforRuralAfterRate;
      _specialTaxForRuralRate = specialTaxforRuralAfterRate;
      _localEducationTax = tradingPrice * localEducationTaxRate;
      _localEducationTaxRate = localEducationTaxRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('부동산 계산기'),
            ),
            drawer: const MyDrawer(),
            bottomNavigationBar: // * 계산하기
                Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 250,
                      child: ElevatedButton(
                          onPressed: _tradingPriceController.text.isNotEmpty ? calculateAcquisitionTax : () {},
                          child: const Text(
                            '계산하기',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ))),
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
                                Text(acquisitionTaxExplanation),
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
                                Text(
                                  acquisitionTaxExplanation,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                  child: buildSegmentedControl(_isUnderOrOver85, areaChildren, (value) {
                    setState(() {
                      _isUnderOrOver85 = value;
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
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('생애 최초 주택구입'),
                    subtitle: const Text(
                      '취득가액 12억원 이하 주택 취득세 200만원 감면\n(지방세특례제한법 제36조의3, 2025년 12월 31일까지)',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _isFirstBuying,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFirstBuying = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DataTable(columns: const [
                    DataColumn(
                        label: Expanded(
                            child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('세목')],
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('세율')],
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('세액')],
                    ))),
                  ], rows: [
                    DataRow(cells: [
                      const DataCell(Text('취득세')),
                      DataCell(Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(('${_acquisitionTaxRate * 100} %')),
                        ],
                      ))),
                      DataCell(Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(formatWithCommas(_acquisitionTax.ceilToDouble()).toString()),
                          ],
                        ),
                      )),
                    ]),
                    DataRow(cells: [
                      const DataCell(Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('농어촌특별세'),
                          Text(
                            '(전용면적85㎟ 초과만)',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      )),
                      DataCell(Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text(('${_specialTaxForRuralRate * 100} %'))]))),
                      DataCell(Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text(formatWithCommas(_specialTaxForRural.ceilToDouble()).toString())]))),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('지방교육세')),
                      DataCell(Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text(('${(_localEducationTaxRate * 100).toStringAsFixed(2)} %'))]))),
                      DataCell(Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text(formatWithCommas(_localEducationTax.ceilToDouble()).toString())]))),
                    ]),
                    if (_isFirstBuying)
                      const DataRow(cells: [
                        DataCell(Text('생애최초주택구입감면')),
                        DataCell(
                            Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(('-'))]))),
                        DataCell(Expanded(
                            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('-2,000,000')]))),
                      ]),
                    DataRow(cells: [
                      DataCell(Text(
                        '합계',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      )),
                      _tradingPriceController.text.isNotEmpty
                          ? DataCell(Text(_isFirstBuying
                              ? '${((_acquisitionTax.ceilToDouble() + _localEducationTax.ceilToDouble() - 2000000) / double.parse(_tradingPriceController.text.replaceAll(',', '')) * 100).toStringAsFixed(2)} %'
                              : '${((_acquisitionTax.ceilToDouble() + _localEducationTax.ceilToDouble()) / double.parse(_tradingPriceController.text.replaceAll(',', '')) * 100).toStringAsFixed(2)} %'))
                          : const DataCell(Text('-')),
                      DataCell(Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _isFirstBuying
                                  ? formatWithCommas(
                                          _acquisitionTax.ceilToDouble() + _localEducationTax.ceilToDouble() - 2000000)
                                      .toString()
                                  : formatWithCommas(_acquisitionTax.ceilToDouble() + _localEducationTax.ceilToDouble())
                                      .toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                    ]),
                  ]),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
