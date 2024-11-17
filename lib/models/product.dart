class Product{
  int? productNo;
  String? productName;
  String? productDetails;
  String? productImageUrl;
  double? price;

  Product({
    this.productNo,
    this.productName,
    this.productDetails,
    this.productImageUrl,
    this.price,
  });

  Product.fromJson(Map<String,dynamic> json){
    productNo=int.parse(json['productNo']);
    productName=json['productName'];
    productDetails=json['productDetails'];
    productImageUrl=json['productImageUrl'];
    price=json['price'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> json={};
    json['productNo']=productNo;
    json['productName']=productName;
    json['productDetails']=productDetails;
    json['productImageUrl']=productImageUrl;
    json['price']=price;
    return json;
  }
}