import 'package:delivery_boy/model/item/IItem.dart';

class BakeryItem implements IItem {
  @override
  String name;

  @override
  String price;

  @override
  String quantity;

  BakeryItem({this.quantity, this.price, this.name});

  factory BakeryItem.fromJson(Map<String, dynamic> json) {
    return BakeryItem(
      name: json["itemName"],
      price: json["customerOrderItemSalePrice"],
      quantity: json["customerOrderItemQuantity"],
    );
  }
}

List<BakeryItem> bakeryItemsFromJson(responseBody) =>
    List<BakeryItem>.from(responseBody.map((x) => BakeryItem.fromJson(x)));
