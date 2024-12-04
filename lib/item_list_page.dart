import 'package:flutter/material.dart';
import 'package:shop/%20my_order_list.page.dart';
import 'package:shop/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shop/item_basket_page.dart';
import 'package:shop/item_details_page.dart';

import 'models/product.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key}) : super(key: key);

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Product> productLists = [
    Product(
      productNo: 1,
      productName: '노트북(LapTop)',
      productImageUrl: 'https://picsum.photos/id/1/300/300',
      price: 600000,
    ),
    Product(
      productNo: 2,
      productName: '스마트폰(Phone)',
      productImageUrl: 'https://picsum.photos/id/20/300/300',
      price: 500000,
    ),
    Product(
      productNo: 3,
      productName: '머그컵(Cup)',
      productImageUrl: 'https://picsum.photos/id/30/300/300',
      price: 15000,
    ),
    Product(
      productNo: 4,
      productName: '키보드(Keyboard)',
      productImageUrl: 'https://picsum.photos/id/60/300/300',
      price: 50000,
    ),
    Product(
      productNo: 5,
      productName: '포도(Grape)',
      productImageUrl: 'https://picsum.photos/id/75/300/300',
      price: 75000,
    ),
    Product(
      productNo: 6,
      productName: '책(book)',
      productImageUrl: 'https://picsum.photos/id/24/300/300',
      price: 24000,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('제품 리스트'), centerTitle: true, actions: [
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const MyOrderListPage();
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const ItemBasketPage();
                },
              ),
            );
          },
        )
      ]),
      body: GridView.builder(
        itemCount: productLists.length,
        itemBuilder: (context, index) {
          return productContainer(
            productNo: productLists[index].productNo ?? 0,
            productName: productLists[index].productName ?? '',
            productImageUrl: productLists[index].productImageUrl ?? '',
            price: productLists[index].price ?? 0,
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
        ),
      ),
    );
  }

  Widget productContainer(
      {required int productNo,
      required String productName,
      required String productImageUrl,
      required double price}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ItemDetailsPage(
                productNo: productNo,
                productName: productName,
                productImageUrl: productImageUrl,
                price: price,
              );
            },
          ),
        );
      },
      child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: productImageUrl,
                height: 155,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                  );
                },
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Text('오류 발생'),
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(1),
                child: Text('${numberFormat.format(price)}원'),
              )
            ],
          )),
    );
  }
}
