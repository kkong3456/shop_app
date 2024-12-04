import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:shop/constants.dart';
import 'package:shop/enums/delivery_status.dart';
import 'package:shop/enums/payment_status.dart';
import 'package:shop/models/order.dart';
import 'package:shop/models/product.dart';
import 'package:kpostal/kpostal.dart';

class MyOrderListPage extends StatefulWidget {
  const MyOrderListPage({Key? key}) : super(key: key);
  @override
  State<MyOrderListPage> createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {
  var logger = Logger();

  List<Product> productList = [
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

  List<Order> orderList = [
    Order(
      orderId: 1,
      productNo: 1,
      orderDate: '2023-11-24',
      orderNo: '20231124-123456123',
      quantity: 2,
      totalPrice: 12000000,
      paymentStatus: 'completed',
      deliveryStatus: 'delivering',
    ),
    Order(
      orderId: 2,
      productNo: 4,
      orderDate: '2023-11-24',
      orderNo: '20231124-141020312',
      quantity: 3,
      totalPrice: 15000000,
      paymentStatus: 'completed',
      deliveryStatus: 'waiting',
    ),
  ];
  List<Map<int, int>> quantityList = [
    {1: 2},
    {4: 3},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 주문목록'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                return orderContainer(
                  productNo: orderList[index].productNo ?? 0,
                  productName: productList[index].productName ?? '',
                  productImageUrl: productList[index].productImageUrl ?? '',
                  price: orderList[index].totalPrice ?? 0,
                  quantity:
                      quantityList[index][orderList[index].productNo] ?? 0,
                  orderDate: orderList[index].orderDate ?? '',
                  orderNo: orderList[index].orderNo ?? '',
                  paymentStatus: orderList[index].paymentStatus ?? '',
                  deliveryStatus: orderList[index].deliveryStatus ?? '',
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          child: const Text('홈으로'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget orderContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price,
    required int quantity,
    required String orderDate,
    required String orderNo,
    required String paymentStatus,
    required String deliveryStatus,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              '주문날짜 : $orderDate',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                    Text(
                      '${PaymentStatus.getStatusName(paymentStatus).statusName}/${DeliveryStatus.getStatusName(deliveryStatus).statusName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('주문취소'),
              ),
              const SizedBox(
                width: 10,
              ),
              FilledButton.tonal(
                child: const Text('배송조회'),
                onPressed: () {},
              )
            ],
          )
        ],
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
