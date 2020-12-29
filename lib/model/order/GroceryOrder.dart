import 'package:delivery_boy/model/item/GroceryItem.dart';
import 'package:delivery_boy/model/item/IItem.dart';
import 'package:delivery_boy/model/order/IOrder.dart';

class GroceryOrder implements IOrder {
  @override
  String customerMobileNumber;

  @override
  String customerName;

  @override
  String orderCode;

  @override
  String orderCreatedDate;

  @override
  String orderCurrentStatus;

  @override
  String orderID;

  @override
  List<IItem> items;

  GroceryOrder(
      {this.customerName,
      this.customerMobileNumber,
      this.orderCode,
      this.orderCreatedDate,
      this.orderCurrentStatus,
      this.orderID,
      this.items,
      this.mainCategoryId,
      this.totalOrderAmount,
      this.customerAddress});

  factory GroceryOrder.fromJson(Map<String, dynamic> json) {
    return GroceryOrder(
      customerName: json["customerName"],
      customerMobileNumber: json["customerMobileNumber"],
      orderCode: json["orderCode"],
      orderCreatedDate: json["orderedCreatedDate"],
      orderCurrentStatus: json["orderCurrentStatus"],
      orderID: json["orderId"],
      mainCategoryId: json["mainCategoryId"].toString(),
      totalOrderAmount: json["totalOrderAmount"],
      customerAddress:
          json["customerAddress"] ?? "" + "\n" + json["customerCityName"],
      items: groceryItemsFromJson(json["itemList"]),
    );
  }

  @override
  String mainCategoryId;

  @override
  String totalOrderAmount;

  String customerAddress;

  //not used
  String image, locationName, locationPhNo;
}
