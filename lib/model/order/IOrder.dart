import 'package:delivery_boy/model/item/IItem.dart';

class IOrder {
  String orderID;
  String orderCode;
  String orderCreatedDate;
  String orderCurrentStatus;
  String customerName;
  String customerMobileNumber;
  String mainCategoryId;
  String image;
  String locationName;
  String locationPhNo;
  String totalOrderAmount;
  String customerAddress;
  List<IItem> items;
}
