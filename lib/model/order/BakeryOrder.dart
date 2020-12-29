import 'package:delivery_boy/const.dart';
import 'package:delivery_boy/model/item/BakeryItem.dart';
import 'package:delivery_boy/model/item/IItem.dart';
import 'package:delivery_boy/model/order/IOrder.dart';

class BakeryOrder implements IOrder {
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

  BakeryOrder(
      {this.customerName,
      this.customerMobileNumber,
      this.orderCode,
      this.orderCreatedDate,
      this.orderCurrentStatus,
      this.orderID,
      this.items,
      this.mainCategoryId,
      this.totalOrderAmount,
      this.customerAddress,
      this.image,
      this.locationName,
      this.locationPhNo});

  factory BakeryOrder.fromJson(Map<String, dynamic> json) {
    return BakeryOrder(
      customerName: json["customerName"],
      customerMobileNumber: json["customerMobileNumber"],
      orderCode: json["bakeryOrderCode"],
      orderCreatedDate: json["orderedCreatedDate"],
      orderCurrentStatus: json["orderCurrentStatus"],
      orderID: json["bakeryOrderId"],
      mainCategoryId: json["mainCategoryId"].toString(),
      totalOrderAmount: json["totalOrderAmount"],
      image:
          BASE_URL + json["sellerBakeryImagePath"] + json["sellerBakeryImage"],
      locationName: json["sellerBakeryName"],
      locationPhNo: json["sellerBakeryMobileNumber"],
      customerAddress:
          json["customerAddress"] ?? "" + "\n" + json["customerCityName"],
      items: bakeryItemsFromJson(json["itemList"]),
    );
  }

  @override
  String mainCategoryId;

  @override
  String totalOrderAmount;

  String customerAddress;

  @override
  String image;

  @override
  String locationName;

  @override
  String locationPhNo;
}
