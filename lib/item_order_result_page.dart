import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product.dart';

class ItemOrderResultPage extends StatefulWidget {
  ItemOrderResultPage({
    super.key,
    required this.paymentMethod,
    required this.paymentAmount,
    required this.receiverName,
    required this.receiverPhone,
    required this.zip,
    required this.address1,
    required this.address2,
  });

  String paymentMethod = '';
  double paymentAmount = 0;
  String receiverName = '';
  String receiverPhone = '';
  String zip = '';
  String address1 = '';
  String address2 = '';

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

  @override
  State<ItemOrderResultPage> createState() => _ItemOrderResultPageState();
}

class _ItemOrderResultPageState extends State<ItemOrderResultPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String generateOrderNumber() {
    final dateTime = DateTime.now();
    String orderNo =
        '${dateTime.year}${dateTime.month}${dateTime.day}-${dateTime.hour}${dateTime.minute}${dateTime.millisecond}';
    return orderNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.96),
      appBar: AppBar(
        title: const Text('주문완료'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(8),
                child: const Text(
                  '주문이 완료되었습니다.',
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
              if (widget.paymentMethod == '무통장입금')
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('아래 계좌정보로 입금해 주시면 결제완료처리가 됩니다.'),
                ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    if (widget.paymentMethod == '무통장입금') depositInforRow(),
                    if (widget.paymentMethod != '무통장입금') const Divider(),
                    orderNumberRow(),
                    const Divider(),
                    paymentAmountRow(),
                    const Divider(),
                    shippingAddressRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('홈으로')),
      ),
    );
  }

  Widget depositInforRow() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 4,
            child: Text('입금계좌안내'),
          ),
          Expanded(
            flex: 6,
            child: Text('123456789(은행명)'),
          ),
        ],
      ),
    );
  }

  Widget paymentAmountRow() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 4,
            child: Text(widget.paymentMethod == '무통장입금' ? '입금금액' : '결제금액'),
          ),
          Expanded(
            flex: 6,
            child: Text('${numberFormat.format(widget.paymentAmount)}원'),
          ),
        ],
      ),
    );
  }

  Widget orderNumberRow() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            flex: 4,
            child: Text('주문번호'),
          ),
          Expanded(
            flex: 6,
            child: Text(generateOrderNumber()),
          )
        ],
      ),
    );
  }

  Widget shippingAddressRow() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('배송지')],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.receiverName}(${widget.receiverPhone})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${widget.address1} ${widget.address2}'),
                Text('(${widget.zip})'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
