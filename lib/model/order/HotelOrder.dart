import 'package:delivery_boy/const.dart';
import 'package:delivery_boy/model/item/HotelItem.dart';
import 'package:delivery_boy/model/item/IItem.dart';
import 'package:delivery_boy/model/order/IOrder.dart';

class HotelOrder implements IOrder {
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

  HotelOrder(
      {this.customerName,
      this.customerMobileNumber,
      this.orderCode,
      this.orderCreatedDate,
      this.orderCurrentStatus,
      this.orderID,
      this.items,
      this.mainCategoryId,
      this.image,
      this.totalOrderAmount,
      this.customerAddress,
      this.locationName,
      this.locationPhNo});

  factory HotelOrder.fromJson(Map<String, dynamic> json) {
    return HotelOrder(
      customerName: json["customerName"],
      customerMobileNumber: json["customerMobileNumber"],
      orderCode: json["hotelOrderCode"],
      orderCreatedDate: json["orderedCreatedDate"],
      orderCurrentStatus: json["orderCurrentStatus"],
      orderID: json["hotelOrderId"],
      mainCategoryId: json["mainCategoryId"].toString(),
      totalOrderAmount: json["totalOrderAmount"],
      image: BASE_URL + json["sellerHotelImagePath"] + json["sellerHotelImage"],
      locationName: json["sellerHotelName"],
      locationPhNo: json["sellerHotelMobileNumber"],
      customerAddress:
          json["customerAddress"] ?? "" + "\n" + json["customerCityName"],
      items: hotelItemsFromJson(json["itemList"]),
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
