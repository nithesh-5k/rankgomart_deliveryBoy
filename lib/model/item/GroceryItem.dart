import 'package:delivery_boy/model/item/IItem.dart';

class GroceryItem implements IItem {
  @override
  String name;

  @override
  String price;

  @override
  String quantity;

  GroceryItem({this.quantity, this.price, this.name});

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      name: json["productName"],
      price: json["orderProductSalePrice"],
      quantity: json["orderProductQuantity"],
    );
  }
}

List<GroceryItem> groceryItemsFromJson(responseBody) =>
    List<GroceryItem>.from(responseBody.map((x) => GroceryItem.fromJson(x)));
