import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radio_button_practice/service/service.dart';

import 'components/explanation.dart';
import 'components/widget.dart';

class TransferIncomeTaxCalculator extends StatefulWidget {
  const TransferIncomeTaxCalculator({super.key});

  @override
  State<TransferIncomeTaxCalculator> createState() => _TransferIncomeTaxCalculatorState();
}

class _TransferIncomeTaxCalculatorState extends State<TransferIncomeTaxCalculator> {
  // *  🌜🌝 날짜 관련
  // ! -------------------------------------------------------------------------
  final DateTime now = DateTime.now();
  late DateTime _transactionDate; // * 양도일자
  late DateTime _acquisitionDate; // * 취득일자
  int dayDiffBetweenTransactionAndAcquisition = 0; // * 양도일자 - 취득일자 차이(일단위)
  // ! -------------------------------------------------------------------------

  // * 😁😃 Text input
  // ! -------------------------------------------------------------------------
  // * 취득가액
  final TextEditingController _acquisitionPricecController = TextEditingController();
  // * 양도가액
  final TextEditingController _transferIncomePriceController = TextEditingController();
  // ! -------------------------------------------------------------------------

  // * 💥💥 불존
  // ! -------------------------------------------------------------------------
  bool _isShowInfo = false; // * 설명카드의 가리기 표시하기 유무
  bool _isTransactionDateSelected = false; // * 양도일자 기재 여부
  bool _isAcquisitionDateSelected = false; // * 취득일자 기재 여부
  bool _isInitialTransferInYear = true; // * 양도소득기본공제 대상 여부
  // ! -------------------------------------------------------------------------

  // * 🥩🍠🍙 segmented control
  // ! -------------------------------------------------------------------------
  int _howManyHouseControl = 0;
  // ! -------------------------------------------------------------------------

  // * 🍟🍔 위젯존
  // ! -------------------------------------------------------------------------
  final Map<int, Widget> howManyHouseWidget = const <int, Widget>{
    0: Text(
      '1주택, 일시적2주택',
      style: TextStyle(fontSize: 12),
    ),
    1: Text('2주택'),
    2: Text('그이상'),
  };
  // ! -------------------------------------------------------------------------

  // * 🍱🍻 함수존
  // ! -------------------------------------------------------------------------
  double _capitalGain = 0; // * 양도차익
  double _capitalGainRate = 0; // * 양도차익 이익률
  double _tradingPriceToDouble = 0; // * 양도가액 (숫자)
  double _acquisitionPriceToDouble = 0; // * 취득가액 (숫자)
  double _deductionRateForLongTermStaying = 0; // * 장기보유특별공제율(거주)
  double _deductionRateForLongTermHolding = 0; // * 장기보유특별공제율(보유)
  double _totaldeductionRateForLongTermHolding = 0; // * 장기보유특별공제율합계
  double _capitalGainMinusdeductionRate = 0; // * 양도소득금액
  double _basicDeductionForInitialTransfer = 2000000.0; // * 양도소득 기본공제
  double _assessmentStandard = 0;
  String tradingPriceToStr = '';
  String acquisitionPriceToStr = '';

  void calculateTransferIncomeTax() {
    if (_acquisitionPricecController.text.isEmpty || _transferIncomePriceController.text.isEmpty) {
      return;
    }

    double transectionPrice = double.parse(_transferIncomePriceController.text.replaceAll(',', '')); // * 양도가액
    double acquisitionPrice = double.parse(_acquisitionPricecController.text.replaceAll(',', '')); // * 취득가액

    double capitalGain = transectionPrice - acquisitionPrice; // * 양도차익
    double capitalGainRate = capitalGain / acquisitionPrice * 100; // * 양도차익 이익률

    if (_howManyHouseControl == 0) {
      // * 장기보율 특별 공제율
      if (_isTransactionDateSelected && _isAcquisitionDateSelected) {
        final Duration difference = _transactionDate.difference(_acquisitionDate);
        dayDiffBetweenTransactionAndAcquisition = difference.inDays;

        // * 1인1주택 거주 기간 기준
        // * 2년 이상~11년 미만 거주인 경우, 보유기간 * 4%, 10년 이상은 최대 40%

        if (dayDiffBetweenTransactionAndAcquisition >= 730 && dayDiffBetweenTransactionAndAcquisition < 3650) {
          int years = dayDiffBetweenTransactionAndAcquisition ~/ 365;
          setState(() {
            _deductionRateForLongTermStaying = years * 0.04;
          });
        } else if (dayDiffBetweenTransactionAndAcquisition >= 3650) {
          setState(() {
            _deductionRateForLongTermStaying = 0.04;
          });
        }
        // * 3년 이상~11
        if (dayDiffBetweenTransactionAndAcquisition >= 1095 && dayDiffBetweenTransactionAndAcquisition < 3650) {
          int years = dayDiffBetweenTransactionAndAcquisition ~/ 365;
          setState(() {
            _deductionRateForLongTermHolding = years * 0.04;
          });
        } else if (dayDiffBetweenTransactionAndAcquisition >= 4015) {
          setState(() {
            _deductionRateForLongTermStaying = 0.04;
          });
        }
      }

      // * 양도소득기본공제 여부
      if (_isInitialTransferInYear) {
        _basicDeductionForInitialTransfer = 20000000;
      } else {
        _basicDeductionForInitialTransfer = 0;
      }

      setState(() {
        _capitalGain = capitalGain; // * 양도차익
        _capitalGainRate = capitalGainRate; //* 양도차익 이익률
        _totaldeductionRateForLongTermHolding =
            _deductionRateForLongTermHolding + _deductionRateForLongTermStaying; //* 장기보육특별공제율 합계
        _capitalGainMinusdeductionRate =
            _capitalGain - (_capitalGain * _totaldeductionRateForLongTermHolding); // * 양도소득금액
        _assessmentStandard = _capitalGainMinusdeductionRate - _basicDeductionForInitialTransfer; // * 과세표준
      });
    } else {
      null;
    }
  }
  // ! -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _transactionDate = DateTime.now();
    _acquisitionDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SubmmitButton(title: '계산하기', onPressed: () => calculateTransferIncomeTax()),
      body: ListView(
        children: [
          //* 타이틀
          const SubTitleWidget(icon: Icon(Icons.calculate), title: '양도세 계산(농지외 유상취득)'),

          //* 설명카드
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ExplanationCard(
                isShowInfo: _isShowInfo,
                onTap: () => setState(() => _isShowInfo = !_isShowInfo),
                text: transferIncomeTaxExplanation),
          ),
          const SizedBox(height: 15),

          // * 주택수 선택
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: buildSegmentedControl(
              _howManyHouseControl,
              howManyHouseWidget,
              (value) {
                setState(() {
                  if (value == 0) {
                    _howManyHouseControl = 0;
                  } else if (value == 1) {
                    _howManyHouseControl = 1;
                  } else {
                    _howManyHouseControl = 2;
                  }
                  // calculateAcquisitionTax();
                });
              },
            ),
          ),
          const SizedBox(height: 15),

          // * 양도일자 선택
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                children: [
                  FilledButton.tonalIcon(
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: const Text('양도일자'),
                      onPressed: () {
                        myDateTimePicker(context, (date) {
                          setState(() {
                            _transactionDate = date;
                            _isTransactionDateSelected = true;
                          });
                        });
                      }),
                  Expanded(
                    child: Text(
                      _isTransactionDateSelected == false
                          ? '양도일자를 선택해주세요.'
                          : DateFormat('yy년 MM월 dd일 ').format(_transactionDate),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 5),

          //* 양도가액 입력
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(children: [
                Expanded(
                    child: Stack(children: [
                  buildTextField(
                      _transferIncomePriceController,
                      '양도가액',
                      (string) => setState(() {
                            _tradingPriceToDouble = double.parse(string.replaceAll(',', ''));
                            tradingPriceToStr = chagneDigitToStrTypeNumber(_tradingPriceToDouble);
                          })),
                  _transferIncomePriceController.text.isNotEmpty
                      ? DisplayDigitToStr(text: tradingPriceToStr)
                      : const SizedBox.shrink(),
                ])),
                const SizedBox(width: 15),
                const Text('원', style: TextStyle(fontSize: 18))
              ])),
          const SizedBox(height: 15),

          // * 취득일자 선택
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(children: [
                FilledButton.tonalIcon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text('취득일자'),
                    onPressed: () {
                      myDateTimePicker(context, (date) {
                        setState(() {
                          _acquisitionDate = date;
                          _isAcquisitionDateSelected = true;
                        });
                      });
                    }),
                Expanded(
                  child: Text(
                    _isAcquisitionDateSelected == false
                        ? '취득일자를 선택해주세요.'
                        : DateFormat('yy년 MM월 dd일 ').format(_acquisitionDate),
                    textAlign: TextAlign.center,
                  ),
                ),
              ])),
          const SizedBox(height: 5),

          //* 취득가액 입력
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(children: [
                Expanded(
                    child: Stack(children: [
                  buildTextField(
                      _acquisitionPricecController,
                      '취득가액',
                      (string) => setState(() {
                            _acquisitionPriceToDouble = double.parse(string.replaceAll(',', ''));
                            acquisitionPriceToStr = chagneDigitToStrTypeNumber(_acquisitionPriceToDouble);
                          })),
                  _acquisitionPricecController.text.isNotEmpty
                      ? DisplayDigitToStr(text: acquisitionPriceToStr)
                      : const SizedBox.shrink(),
                ])),
                const SizedBox(width: 15),
                const Text('원', style: TextStyle(fontSize: 18))
              ])),
          const SizedBox(height: 5),

          // * 양도소득기본공제 대상 유무
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('양도소득기본공제 대상 유무'),
              subtitle: const Text(
                '부동산과 그 권리, 유가증권(주식), 파생상품 매도시 \n1과세연도 중 각각 250만원 1회 공제',
                style: TextStyle(fontSize: 12),
              ),
              value: _isInitialTransferInYear,
              onChanged: (bool? value) {
                setState(() {
                  _isInitialTransferInYear = value!;
                  // calculateAcquisitionTax();
                });
              },
            ),
          ),

          // * 데이터 테이블

          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: DataTable(columnSpacing: 0, horizontalMargin: 0, columns: const [
              DataColumn(
                  label: Text(
                '세목',
              )),
              DataColumn(
                  label: Expanded(
                child: Text(
                  '%',
                  textAlign: TextAlign.end,
                ),
              )),
              DataColumn(
                  label: Expanded(
                child: Text(
                  '세액',
                  textAlign: TextAlign.end,
                ),
              )),
            ], rows: [
              DataRow(cells: [
                const DataCell(Text('양도차익')),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${_capitalGainRate.toStringAsFixed(1)} %'),
                    // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _acquisitionPricecController.text.isEmpty || _transferIncomePriceController.text.isEmpty
                        ? const Text('0')
                        : Text(
                            '${formatWithCommas(_capitalGain).toString()}\n(${chagneDigitToStrTypeNumber(_capitalGain)})',
                            textAlign: TextAlign.end,
                          ),
                  ],
                )),
              ]),
              DataRow(cells: [
                DataCell(Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('장기보유특별공제율'),
                    IconButton(
                        onPressed: () {
                          myShowDiagram(context, '장기보유특별공제율', longTermStaying);
                        },
                        icon: const Icon(
                          CupertinoIcons.question_circle_fill,
                          size: 20,
                        ))
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${(_totaldeductionRateForLongTermHolding * 100).toStringAsFixed(0)} %'),
                    // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _acquisitionPricecController.text.isEmpty || _transferIncomePriceController.text.isEmpty
                        ? const Text('0')
                        : Text(
                            '${formatWithCommas(_capitalGain * _totaldeductionRateForLongTermHolding).toString()}\n(${chagneDigitToStrTypeNumber(_capitalGain * _totaldeductionRateForLongTermHolding)})',
                            textAlign: TextAlign.end,
                          ),
                  ],
                )),
              ]),
              DataRow(cells: [
                const DataCell(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('양도소득금액'),
                    Text('(양도차익-장기보유특별공제율)', style: TextStyle(fontSize: 12)),
                  ],
                )),
                const DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('-'),
                    // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _acquisitionPricecController.text.isEmpty || _transferIncomePriceController.text.isEmpty
                        ? const Text('0')
                        : Text(
                            '${formatWithCommas(_capitalGainMinusdeductionRate).toString()}\n(${chagneDigitToStrTypeNumber(_capitalGainMinusdeductionRate)})',
                            textAlign: TextAlign.end,
                          ),
                  ],
                )),
              ]),
              const DataRow(cells: [
                DataCell(Text('양도소득 기본공제')),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('-'),
                    // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('2,500,000\n(2백5십만원)', textAlign: TextAlign.end),
                  ],
                )),
              ]),
              DataRow(cells: [
                const DataCell(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('과세표준'),
                    Text('(양도소득금액-양도소득기본공제)', style: TextStyle(fontSize: 12)),
                  ],
                )),
                const DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('-'),
                    // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                  ],
                )),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _acquisitionPricecController.text.isEmpty || _transferIncomePriceController.text.isEmpty
                        ? const Text('0')
                        : Text(
                            '${formatWithCommas(_assessmentStandard).toString()}\n(${chagneDigitToStrTypeNumber(_assessmentStandard)})',
                            textAlign: TextAlign.end,
                          ),
                  ],
                )),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}
