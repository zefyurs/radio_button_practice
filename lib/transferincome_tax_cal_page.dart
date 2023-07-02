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
  // * 날짜 관련
  final DateTime now = DateTime.now();
  late DateTime transferDate;
  late DateTime acquisitionDate;

  int dayDifference = 0;

  // * bool
  bool transferDateIsSelected = false;
  bool acquisitionDateIsSelected = false;
  bool isInitialTransferInYear = true;

  bool _isShowInfo = false;

  double _capitalGain = 0;
  double _earningRate = 0;
  double tradingPriceToDouble = 0;
  double acquisitionPriceToDouble = 0;
  double sReductionRateForLongTermStaying = 0;

  String tradingPriceToStr = '';
  String acquisitionPriceToStr = '';

  // * 취득가액
  final TextEditingController _acquisitionPrice = TextEditingController();
  // * 양도가액
  final TextEditingController _transferIncomePrice = TextEditingController();

  void calculateTransferIncomeTax() {
    if (_acquisitionPrice.text.isEmpty || _transferIncomePrice.text.isEmpty) {
      return;
    }
    final double transferIncomePrice = double.parse(_transferIncomePrice.text.replaceAll(',', ''));
    final double acquisitionPrice = double.parse(_acquisitionPrice.text.replaceAll(',', ''));
    final double transferIncomeTax = transferIncomePrice - acquisitionPrice;
    final double transferIncomeTaxRate = transferIncomeTax / transferIncomePrice * 100;

    setState(() {
      _capitalGain = transferIncomeTax;
      _earningRate = transferIncomeTaxRate;
    });

    if (transferDateIsSelected && acquisitionDateIsSelected) {
      final Duration difference = transferDate.difference(acquisitionDate);
      dayDifference = difference.inDays;

      if (dayDifference > 1095) {
        int years = dayDifference ~/ 365;
        setState(() {
          sReductionRateForLongTermStaying = years * 0.02;
        });
      } else {
        setState(() {
          sReductionRateForLongTermStaying = 0;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    transferDate = DateTime.now();
    acquisitionDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: const MyAppBar(),
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

                // * 양도일자 선택

                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Expanded(
                        child: Text(
                          transferDateIsSelected == false
                              ? '양도일자를 선택해주세요.'
                              : DateFormat('yy년 MM월 dd일 ').format(transferDate),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      leading: FilledButton.tonalIcon(
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: const Text('양도일자'),
                          onPressed: () {
                            myDateTimePicker(context, (date) {
                              setState(() {
                                transferDate = date;
                                transferDateIsSelected = true;
                              });
                            });
                          }),
                    )),
                const SizedBox(height: 5),

                //* 양도가액 입력
                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(children: [
                      Expanded(
                          child: Stack(children: [
                        buildTextField(
                            _transferIncomePrice,
                            '양도가액',
                            (string) => setState(() {
                                  tradingPriceToDouble = double.parse(string.replaceAll(',', ''));
                                  tradingPriceToStr = chagneDigitToStrTypeNumber(tradingPriceToDouble);
                                })),
                        _transferIncomePrice.text.isNotEmpty
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
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Expanded(
                        child: Text(
                          acquisitionDateIsSelected == false
                              ? '취득일자를 선택해주세요.'
                              : DateFormat('yy년 MM월 dd일 ').format(acquisitionDate),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      leading: FilledButton.tonalIcon(
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: const Text('취득일자'),
                          onPressed: () {
                            myDateTimePicker(context, (date) {
                              setState(() {
                                acquisitionDate = date;
                                acquisitionDateIsSelected = true;
                              });
                            });
                          }),
                    )),
                const SizedBox(height: 5),

                //* 취득가액 입력
                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(children: [
                      Expanded(
                          child: Stack(children: [
                        buildTextField(
                            _acquisitionPrice,
                            '취득가액',
                            (string) => setState(() {
                                  acquisitionPriceToDouble = double.parse(string.replaceAll(',', ''));
                                  acquisitionPriceToStr = chagneDigitToStrTypeNumber(acquisitionPriceToDouble);
                                })),
                        _acquisitionPrice.text.isNotEmpty
                            ? DisplayDigitToStr(text: acquisitionPriceToStr)
                            : const SizedBox.shrink(),
                      ])),
                      const SizedBox(width: 15),
                      const Text('원', style: TextStyle(fontSize: 18))
                    ])),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('양도소득기본공제 대상 유무'),
                    subtitle: const Text(
                      '부동산과 그 권리, 유가증권(주식), 파생상품 매도시 \n1과세연도 중 각각 250만원 1회 공제',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: isInitialTransferInYear,
                    onChanged: (bool? value) {
                      setState(() {
                        isInitialTransferInYear = value!;
                        // calculateAcquisitionTax();
                      });
                    },
                  ),
                ),
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
                          Text('${_earningRate.toStringAsFixed(1)} %'),
                          // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                        ],
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _acquisitionPrice.text.isEmpty || _transferIncomePrice.text.isEmpty
                              ? const Text('0')
                              : Text(
                                  '${formatWithCommas(_capitalGain).toString()}\n(${chagneDigitToStrTypeNumber(_capitalGain)})',
                                  textAlign: TextAlign.end,
                                ),
                        ],
                      )),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('장기보유특별공제율')),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${(sReductionRateForLongTermStaying * 100).toStringAsFixed(0)} %'),
                          // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                        ],
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _acquisitionPrice.text.isEmpty || _transferIncomePrice.text.isEmpty
                              ? const Text('0')
                              : Text(
                                  '${formatWithCommas(_capitalGain * sReductionRateForLongTermStaying).toString()}\n(${chagneDigitToStrTypeNumber(_capitalGain * sReductionRateForLongTermStaying)})',
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
                          _acquisitionPrice.text.isEmpty || _transferIncomePrice.text.isEmpty
                              ? const Text('0')
                              : Text(
                                  '${formatWithCommas(_capitalGain - (_capitalGain * sReductionRateForLongTermStaying)).toString()}\n(${chagneDigitToStrTypeNumber(_capitalGain - (_capitalGain * sReductionRateForLongTermStaying))})',
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
                          _acquisitionPrice.text.isEmpty || _transferIncomePrice.text.isEmpty
                              ? const Text('0')
                              : Text(
                                  '${formatWithCommas(_capitalGain - (_capitalGain * sReductionRateForLongTermStaying) - 2500000).toString()}\n(${chagneDigitToStrTypeNumber(_capitalGain - (_capitalGain * sReductionRateForLongTermStaying - 2500000))})',
                                  textAlign: TextAlign.end,
                                ),
                        ],
                      )),
                    ]),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
