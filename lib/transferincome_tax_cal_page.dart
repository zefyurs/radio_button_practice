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

  // * bool
  bool transferDateIsSelected = false;
  bool _isShowInfo = false;

  double _capitalGain = 0;
  double _earningRate = 0;
  double tradingPriceToDouble = 0;
  double acquisitionPriceToDouble = 0;

  String tradingPriceToStr = '';
  String acquisitionPriceToStr = '';

  // * 취득가액
  final TextEditingController _acquisitionPrice = TextEditingController();
  // * 양도가액
  final TextEditingController _transferIncomePrice = TextEditingController();
  final DateTime _acquisitionDate = DateTime.now();

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
  }

  @override
  void initState() {
    super.initState();
    transferDate = DateTime.now();
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
                      leading: const Text('양도일자'),
                      title: Text(
                        transferDateIsSelected == false ? '-' : DateFormat('yy년 MM월 dd일 ').format(transferDate),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CupertinoDatePicker(
                                            onDateTimeChanged: (date) {
                                              setState(() {
                                                transferDate = date;
                                                transferDateIsSelected = true;
                                              });
                                            },
                                            mode: CupertinoDatePickerMode.date,
                                            minimumDate: DateTime(2000),
                                            maximumDate: DateTime.now().add(const Duration(days: 1 * 365))),
                                      ),
                                      DecisionButton(
                                        onPressed: () => {},
                                        title: '확인',
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: const Text('양도일자 선택'),
                      ),
                    )),

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
                const SizedBox(height: 15),

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
                        '수익률',
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
                          Text('${_earningRate.toStringAsFixed(2)} %'),
                          // Text(double.parse(_acquisitionPrice.text) / double.parse(_transferIncomePrice.text) * 100),
                        ],
                      )),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _acquisitionPrice.text.isEmpty || _transferIncomePrice.text.isEmpty
                              ? const Text('0')
                              : Text(
                                  '${formatWithCommas(_capitalGain).toString()}(${chagneDigitToStrTypeNumber(_capitalGain)})'),
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
