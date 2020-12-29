import 'package:delivery_boy/model/item/IItem.dart';

class HotelItem implements IItem {
  @override
  String name;

  @override
  String price;

  @override
  String quantity;

  HotelItem({this.quantity, this.price, this.name});

  factory HotelItem.fromJson(Map<String, dynamic> json) {
    return HotelItem(
      name: json["itemName"],
      price: json["customerOrderItemSalePrice"],
      quantity: json["customerOrderItemQuantity"],
    );
  }
}

List<HotelItem> hotelItemsFromJson(responseBody) =>
    List<HotelItem>.from(responseBody.map((x) => HotelItem.fromJson(x)));
