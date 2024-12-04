import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:shop/components/basic_dialog.dart';
import 'package:shop/constants.dart';
import 'package:shop/item_order_result_page.dart';
import 'package:shop/models/product.dart';
import 'package:kpostal/kpostal.dart';

class ItemCheckoutPage extends StatefulWidget {
  const ItemCheckoutPage({Key? key}) : super(key: key);
  @override
  State<ItemCheckoutPage> createState() => _ItemCheckoutPageState();
}

class _ItemCheckoutPageState extends State<ItemCheckoutPage> {
  var logger = Logger();

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

  final formKey = GlobalKey<FormState>();

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
  TextEditingController depositNameController = TextEditingController();

  final List<String> paymentMethodList = [
    '결제수단선택',
    '카드결제',
    '무통장입금',
  ];

  String selectedPaymentMethod = '결제수단선택';

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
            Form(
              key: formKey,
              child: Column(
                children: [
                  inputTextField(
                    currentController: buyerNameController,
                    currentHintText: '주문자명',
                  ),
                  inputTextField(
                    currentController: buyerEmailController,
                    currentHintText: '주문자 이메일',
                  ),
                  inputTextField(
                    currentController: buyerPhoneController,
                    currentHintText: '주문자 휴대전화',
                  ),
                  inputTextField(
                    currentController: receiverNameController,
                    currentHintText: '받는 사람명',
                  ),
                  inputTextField(
                    currentController: receiverPhoneController,
                    currentHintText: '받는 사람 휴대전화',
                  ),
                  ReceiverZipTextField(
                    controller: receiverZipController,
                    addrController: receiverAddress1Controller,
                    hintText: '우편번호(주민등록번호)',
                  ),
                  inputTextField(
                    currentController: receiverAddress1Controller,
                    currentHintText: '기본 주소',
                  ),
                  inputTextField(
                    currentController: receiverAddress2Controller,
                    currentHintText: '상세 주소',
                  ),
                  inputTextField(
                    currentController: userPwdController,
                    currentHintText: '비회원 주문조회 비밀번호',
                  ),
                  inputTextField(
                    currentController: userConfirmPwdController,
                    currentHintText: '비회원 주문조회 비밀번호 확인',
                    isObscure: true,
                  ),
                  paymentMethodDropdownButton(),
                  if (selectedPaymentMethod == '카드결제')
                    Column(
                      children: [
                        inputTextField(
                          currentController: cardNoController,
                          currentHintText: '카드 번호',
                        ),
                        inputTextField(
                          currentController: cardAuthController,
                          currentHintText: '카드명의자 주민번호 앞자리 또는 사업자번호',
                          currentMaxLength: 10,
                        ),
                        inputTextField(
                          currentController: cardExpiredDateController,
                          currentHintText: '카드 만료일(YYYYMM)',
                          currentMaxLength: 6,
                        ),
                        inputTextField(
                          currentController: cardPwdTowDigitsController,
                          currentHintText: '카드 비밀번호 앞2자리',
                          currentMaxLength: 2,
                        ),
                      ],
                    ),
                  if (selectedPaymentMethod == '무통장입금')
                    inputTextField(
                      currentController: depositNameController,
                      currentHintText: '입금자명',
                    ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            // if (formKey.currentState!.validate()) {
            //   if (selectedPaymentMethod == '결제수단선택') {
            //     showDialog(
            //       context: context,
            //       barrierDismissible: true,
            //       builder: (context) {
            //         return BasicDialog(
            //           content: '결제수단을 선택해 주세요',
            //           buttonText: '닫기',
            //           buttonFuction: () => Navigator.of(context).pop(),
            //         );
            //       },
            //     );
            //   }
            //   return;
            // }
            logger.d('start');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ItemOrderResultPage(
                  paymentMethod: selectedPaymentMethod,
                  paymentAmount: totalPrice,
                  receiverName: buyerNameController.text,
                  receiverPhone: buyerPhoneController.text,
                  zip: receiverZipController.text,
                  address1: receiverAddress1Controller.text,
                  address2: receiverAddress2Controller.text,
                ),
              ),
            );
            logger.d('end');
          },
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

  Widget inputTextField({
    required TextEditingController currentController,
    required String currentHintText,
    int? currentMaxLength,
    bool isObscure = false,
    bool isReadOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          // if (value!.isEmpty) {
          //   return '내용을 입력해주세요';
          // } else {
          //   if (currentController == userConfirmPwdController &&
          //       userPwdController.text != userConfirmPwdController.text) {
          //     return '비밀번호가 일치하지 않습니다';
          //   }
          // }
          return null;
        },
        controller: currentController,
        readOnly: isReadOnly,
        maxLength: currentMaxLength,
        obscureText: isObscure,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: currentHintText,
        ),
      ),
    );
  }

  Widget paymentMethodDropdownButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: .5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value ?? '';
          });
        },
        isExpanded: true,
        underline: Container(),
        items: paymentMethodList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
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

  ReceiverZipTextField({
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
