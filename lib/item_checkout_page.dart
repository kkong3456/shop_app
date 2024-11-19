import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product.dart';
import 'package:kpostal/kpostal.dart';

class ItemCheckoutPage extends StatefulWidget {
  const ItemCheckoutPage({Key? key}) : super(key: key);
  @override
  State<ItemCheckoutPage> createState() => _ItemCheckoutPageState();
}

class _ItemCheckoutPageState extends State<ItemCheckoutPage> {
  List<Product> checkoutList = [
    Product(
      productNo: 1,
      productName: '노트북(LapTop)',
      productImageUrl: 'https://picsum.photos/id/1/300/300',
      price: 600000,
    ),
    Product(
      productNo: 4,
      productName: '키보드(Keyboard)',
      productImageUrl: 'https://picsum.photos/id/60/300/300',
      price: 50000,
    ),
  ];

  List<Map<int, int>> quantityList = [
    {1: 2},
    {4: 3},
  ];

  double totalPrice = 0;

  // controller 변수추가
  TextEditingController buyerNameController = TextEditingController();
  TextEditingController buyerEmailController = TextEditingController();
  TextEditingController buyerPhoneController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverZipController = TextEditingController();
  TextEditingController receiverAddress1Controller = TextEditingController();
  TextEditingController receiverAddress2Controller = TextEditingController();
  TextEditingController userPwdController = TextEditingController();
  TextEditingController userConfirmPwdController = TextEditingController();
  TextEditingController cardNoController = TextEditingController();
  TextEditingController cardAuthController = TextEditingController();
  TextEditingController cardExpiredDateController = TextEditingController();
  TextEditingController cardPwdTowDigitsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < checkoutList.length; i++) {
      totalPrice +=
          checkoutList[i].price! * quantityList[i][checkoutList[i].productNo]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 시작'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: checkoutList.length,
              itemBuilder: (context, index) {
                return checkoutContainer(
                  productNo: checkoutList[index].productNo ?? 0,
                  productName: checkoutList[index].productName ?? '',
                  productImageUrl: checkoutList[index].productImageUrl ?? '',
                  price: checkoutList[index].price ?? 0,
                  quantity:
                      quantityList[index][checkoutList[index].productNo] ?? 0,
                );
              },
            ),
            textEditFormField(
              controller: buyerNameController,
              hintText: '주문자명',
            ),
            textEditFormField(
              controller: buyerEmailController,
              hintText: '주문자 이메일',
            ),
            textEditFormField(
              controller: buyerPhoneController,
              hintText: '주문자 전화번호',
            ),
            textEditFormField(
              controller: receiverNameController,
              hintText: '받는 사람명',
            ),
            textEditFormField(
              controller: receiverPhoneController,
              hintText: '받는 사람 전화번호',
            ),
            ReceiverZipTextField(
              controller: receiverZipController,
              hintText: '우편번호',
              addrController: receiverAddress1Controller,
            ),
            textEditFormField(
              controller: receiverAddress1Controller,
              hintText: '주소 1',
            ),
            textEditFormField(
              controller: receiverAddress2Controller,
              hintText: '주소 2',
            ),
            textEditFormField(
              controller: userPwdController,
              hintText: '사용자 비밀번호',
              maxLength: 10,
            ),
            textEditFormField(
              controller: userConfirmPwdController,
              hintText: '사용자 비밀번호 확인',
              obscureOk: true,
              maxLength: 10,
            ),
            textEditFormField(
              controller: cardNoController,
              hintText: '카드 번호',
            ),
            textEditFormField(
              controller: cardAuthController,
              hintText: '카드 인증번호',
              obscureOk: true,
            ),
            textEditFormField(
              controller: cardExpiredDateController,
              hintText: '카드 만료일',
            ),
            textEditFormField(
              controller: cardPwdTowDigitsController,
              hintText: '카드 비밀번호 입력하기',
              obscureOk: true,
              maxLength: 4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {},
          child: Text('총 ${numberFormat.format(totalPrice)}원 결제하기'),
        ),
      ),
    );
  }

  Widget checkoutContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price,
    required int quantity,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: productImageUrl,
            width: MediaQuery.of(context).size.width * .3,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return const Center(
                child: Text('오류 발생'),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  productName,
                  textScaler: const TextScaler.linear(1.2),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${numberFormat.format(price)}원'),
                Text('수량 : $quantity'),
                Text('합계 : ${numberFormat.format(price * quantity)}원'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget buyerNameTextField() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: TextFormField(
  //       controller: buyerNameController,
  //       decoration: const InputDecoration(
  //           border: OutlineInputBorder(), hintText: '주문자명'),
  //     ),
  //   );
  // }
}

// ignore: camel_case_types, must_be_immutable
class textEditFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  bool? obscureOk;
  int? maxLength;

  // ignore: use_super_parameters
  textEditFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureOk,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: maxLength ?? 100,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
        obscureText: obscureOk ?? false,
      ),
    );
  }
}

class ReceiverZipTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController addrController;
  final String hintText;

  const ReceiverZipTextField({
    Key? key,
    required this.controller,
    required this.addrController,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hintText,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          FilledButton(
            onPressed: () {
              print('우편번호 찾기 버튼 클릭');
              // 우편번호 찾기 버튼 클릭 시 우편번호 찾기 페이지 열기
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return KpostalView(callback: (Kpostal result) {
                      controller.text = result.postCode;
                      addrController.text = result.address;
                    });
                  },
                ),
              );
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Text('우편번호 찾기'),
            ),
          ),
        ],
      ),
    );
  }
}
