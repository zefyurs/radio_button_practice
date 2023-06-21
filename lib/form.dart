import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_button_practice/textbox.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

void showSnackBar(context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Control how long the SnackBar is displayed
    ),
  );
}

List<String> options = ['Downloadable', 'Deliverable'];

class _MyFormState extends State<MyForm> {
  final _productController = TextEditingController();
  final _productDesController = TextEditingController();
  String currentOption = options[0];

  @override
  void dispose() {
    _productController.dispose();
    _productDesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play ground'),
        elevation: 5,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Icon
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.category_outlined,
                color: Colors.white,
              ),
            ),

            // * 페이지 설명
            const Text(
              'Product',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Add product details in the form below',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),

            // * 텍스트 인풋
            MyTextField(
                hintText: 'Flutter App',
                labelText: 'Product Name',
                prefixIcon: const Icon(Icons.card_giftcard),
                controller: _productController), // const Text(),
            const SizedBox(height: 20),
            MyTextField(
                hintText: 'Create by Coding with Tea',
                labelText: 'Product Description',
                prefixIcon: const Icon(Icons.list_alt),
                controller: _productController), // const Text(),

            // * 라디오 버튼
            const SizedBox(height: 20),
            ListTile(
                title: const Text('Downloadable'),
                leading: Radio(
                  value: options[0],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                      showSnackBar(context, currentOption);
                    });
                  },
                )),
            ListTile(
                title: const Text('Deliverable'),
                leading: Radio(
                  value: options[1],
                  groupValue: currentOption,
                  onChanged: (value) {
                    setState(() {
                      currentOption = value.toString();
                      showSnackBar(context, currentOption);
                    });
                  },
                )),
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () => showModalBottomSheet(
                        // isDismissible: true,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => buildSheet()),
                    child: const Text('Custom height')),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(onPressed: () {}, child: const Text('Scrollable')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeDismissable({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet() => makeDismissable(
      child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.7,
          builder: (_, controller) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView(controller: controller, children: [
                Column(
                  children: [
                    ClipOval(
                      child: Container(
                        color: Colors.blue,
                        height: 150,
                        width: 150,
                        child: Image.network(
                          'https://i.namu.wiki/i/qJxqP7QZlbyFNNT4joFVDnJcgIG2pX_RESBNcBY8REYb7k1jLB4eZzsrvD8fy3WMDnvw42CoqQj2r8eniVNayS1EOCbIW4ByPKLCXOFz6W_RjZDVa9a_SFF59cZo0F6w_GzA2cwgOP-zBDIFMTJI1w.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('''신체
164cm
소속사
EDAM엔터테인먼트
학력
중앙대학교 연극영화학 휴학
데뷔
1998년 서태지 'Take 5' 포스터 모델
수상
2019년 MBC 연기대상 수목드라마부문 여자 최우수연기상 (신입사관 구해령)
경력
2014.01 유네스코 한국위원회 특별홍보대사
사이트
인스타그램, 유튜브, 트위터
작품
방송, 영화, 공연, 앨범, 곡, 기타'''),
              ]))));
}
