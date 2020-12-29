import 'dart:ui';

import 'package:delivery_boy/const.dart';
import 'package:delivery_boy/model/item/IItem.dart';
import 'package:delivery_boy/model/order/BakeryOrder.dart';
import 'package:delivery_boy/model/order/GroceryOrder.dart';
import 'package:delivery_boy/model/order/HotelOrder.dart';
import 'package:delivery_boy/model/order/IOrder.dart';
import 'package:delivery_boy/pages/login/LoginScreen.dart';
import 'package:delivery_boy/provider/DeliveryBoy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../../request.dart';

class OrdersMainPage extends StatefulWidget {
  @override
  _OrdersMainPageState createState() => _OrdersMainPageState();
}

class _OrdersMainPageState extends State<OrdersMainPage> {
  List<IOrder> everyOrders = [], presentOrders = [];
  var responseBody;
  bool current = true, flag = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getOrders() async {
    everyOrders.clear();
    presentOrders.clear();
    Map<String, String> body = {
      "custom_data": "getdeliveryboyorderlist",
      "deliveryBoyId": Provider.of<DeliveryBoy>(context, listen: false)
          .deliveryBoy
          .deliveryboyId,
      "orderCurrentStatus": ""
    };
    responseBody = await postRequest("API/deliveryboy_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "success") {
        var temp = responseBody['orderList'];
        if (mounted) {
          setState(() {
            for (int i = 0; i < temp.length; i++) {
              if (temp[i]['mainCategoryId'] == 1) {
                everyOrders.add(GroceryOrder.fromJson(temp[i]));
              } else {
                if (temp[i]['mainCategoryId'] == 2) {
                  everyOrders.add(HotelOrder.fromJson(temp[i]));
                } else {
                  if (temp[i]['mainCategoryId'] == 3) {
                    everyOrders.add(BakeryOrder.fromJson(temp[i]));
                  }
                }
              }
            }
            flag = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (responseBody != null) {
      presentOrders.clear();
      for (int i = 0; i < everyOrders.length; i++) {
        if (everyOrders[i].orderCurrentStatus != "rejected" &&
            everyOrders[i].orderCurrentStatus != "delivered") {
          presentOrders.add(everyOrders[i]);
        }
      }
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getOrders();
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              getOrders();
            },
          ),
          IconButton(
              icon: Icon(
                Icons.power_settings_new_rounded,
              ),
              onPressed: () {
                Provider.of<DeliveryBoy>(context, listen: false).deleteUserId();
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => LoginScreen()));
              })
        ],
      ),
      body: !flag
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              current = true;
                            });
                          },
                          child: Container(
                            color: current ? Colors.grey : Colors.white,
                            child: Center(
                              child: Text(
                                "Current orders",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              current = false;
                            });
                          },
                          child: Container(
                            color: !current ? Colors.grey : Colors.white,
                            child: Center(
                              child: Text(
                                "All orders",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: current && presentOrders.length == 0
                      ? Center(
                          child: Text("Orders are yet to be assigned"),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return orderCard(
                                current
                                    ? presentOrders[index]
                                    : everyOrders[index],
                                context);
                          },
                          itemCount: current
                              ? presentOrders.length
                              : everyOrders.length,
                        ),
                ),
              ],
            ),
    );
  }

  void getOrder() {
    getOrders();
  }

  Widget orderCard(IOrder order, BuildContext context) {
    Color buttonColor;
    String buttonText;
    Function onTap;
    if (order.orderCurrentStatus == "confirmed") {
      buttonColor = Colors.orange;
      buttonText = "Pending";
      onTap = () {
        pendingStatus(context, order, false);
      };
    } else {
      if (order.orderCurrentStatus == "accepted") {
        buttonText = "Waiting for pickup";
        buttonColor = Colors.amber;
        onTap = () {
          pickedStatus(context, order);
        };
      } else {
        if (order.orderCurrentStatus == "rejected") {
          buttonText = "Rejected";
          buttonColor = Colors.red;
          onTap = () {};
        } else {
          if (order.orderCurrentStatus == "picked") {
            buttonText = "Waiting for delivery";
            buttonColor = Colors.lightGreen;
            onTap = () {
              deliveredStatus(context, order);
            };
          } else {
            if (order.orderCurrentStatus == "delivered") {
              buttonText = "Delivered";
              buttonColor = Colors.green;
              onTap = () {};
            }
          }
        }
      }
    }
    // onTap = () {
    //   pendingStatus(context, order);
    // };
    return Container(
      height: order.mainCategoryId == 1.toString() ? 400 : 516,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          order.mainCategoryId == 1.toString()
              ? SizedBox()
              : Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: 80, child: Image.network(order.image)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Ordered from ${order.locationName}")
                    ],
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Customer name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        order.customerName,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Order ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(order.orderCode)
                  ],
                ),
              )
            ],
          ),
          FlatButton(
            color: kGreen,
            child: Center(
              child: Text(
                "ITEMS",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            onPressed: () {
              listItems(order.items, context);
            },
          ),
          Text(
            "Ordered On",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(order.orderCreatedDate),
          Text(
            "Customer Address",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(order.customerAddress),
          Text(
            "Customer Phone Number",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(order.customerMobileNumber),
          Text(
            "Total Amount",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(order.totalOrderAmount),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: onTap,
                child: Text(
                  buttonText,
                  style: TextStyle(color: Colors.white),
                ),
                color: buttonColor,
              )
            ],
          )
        ],
      ),
    );
  }

  void pendingStatus(BuildContext context, IOrder order, bool flag) {
    String reason;
    showAlertDialog(
      context: context,
      title: "Pending...",
      statement: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !flag
                  ? Text("You are requested to work on this order")
                  : Column(
                      children: [
                        Text("Enter reason if you are rejecting"),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          onChanged: (value) {
                            reason = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter reason here',
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      forText: flag ? "Reject" : "Accept",
      againstText: flag ? "Cancel" : "Reject",
      forFunction: () async {
        if (!flag) {
          Map<String, String> body = {
            "custom_data": "changeorderstatus",
            "orderId": order.orderID,
            "mainCategoryId": order.mainCategoryId,
            "deliveryBoyId": Provider.of<DeliveryBoy>(context, listen: false)
                .deliveryBoy
                .deliveryboyId,
            "changeOrderStatus": "accepted",
            "rejectReason": ""
          };
          responseBody = await postRequest("API/deliveryboy_api.php", body);
          if (responseBody['success'] == null
              ? false
              : responseBody['success']) {
            if (responseBody['appresponse'] == "failed") {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(responseBody['errormessage']),
              ));
            } else {
              getOrders();
            }
          }
        } else {
          Map<String, String> body = {
            "custom_data": "changeorderstatus",
            "orderId": order.orderID,
            "mainCategoryId": order.mainCategoryId,
            "deliveryBoyId": Provider.of<DeliveryBoy>(context, listen: false)
                .deliveryBoy
                .deliveryboyId,
            "changeOrderStatus": "rejected",
            "rejectReason": reason
          };
          responseBody = await postRequest("API/deliveryboy_api.php", body);
          if (responseBody['success'] == null
              ? false
              : responseBody['success']) {
            if (responseBody['appresponse'] == "failed") {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(responseBody['errormessage']),
              ));
            } else {
              getOrders();
            }
          }
        }
      },
      againstFunction: () async {
        if (!flag) {
          Navigator.pop(context);
          pendingStatus(context, order, true);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  void pickedStatus(BuildContext context, IOrder order) async {
    showAlertDialog(
        context: context,
        title: "Picked?",
        statement: Text("Did you pick the order?"),
        forText: "Yes",
        againstText: "No",
        forFunction: () async {
          Map<String, String> body = {
            "custom_data": "changeorderstatus",
            "orderId": order.orderID,
            "mainCategoryId": order.mainCategoryId,
            "deliveryBoyId": Provider.of<DeliveryBoy>(context, listen: false)
                .deliveryBoy
                .deliveryboyId,
            "changeOrderStatus": "picked",
            "rejectReason": ""
          };
          responseBody = await postRequest("API/deliveryboy_api.php", body);
          if (responseBody['success'] == null
              ? false
              : responseBody['success']) {
            if (responseBody['appresponse'] == "failed") {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(responseBody['errormessage']),
              ));
            } else {
              getOrders();
            }
          }
        },
        againstFunction: () {});
  }

  Future<void> deliveredStatus(BuildContext context, IOrder order) async {
    showAlertDialog(
        context: context,
        title: "Delivered?",
        statement: Text("Did you deliver the product?"),
        forText: "Yes",
        againstText: "No",
        forFunction: () async {
          Map<String, String> body = {
            "custom_data": "changeorderstatus",
            "orderId": order.orderID,
            "mainCategoryId": order.mainCategoryId,
            "deliveryBoyId": Provider.of<DeliveryBoy>(context, listen: false)
                .deliveryBoy
                .deliveryboyId,
            "changeOrderStatus": "delivered",
            "rejectReason": ""
          };
          responseBody = await postRequest("API/deliveryboy_api.php", body);
          if (responseBody['success'] == null
              ? false
              : responseBody['success']) {
            if (responseBody['appresponse'] == "failed") {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(responseBody['errormessage']),
              ));
            } else {
              getOrders();
            }
          }
        },
        againstFunction: () {});
  }

  showAlertDialog(
      {BuildContext context,
      Function forFunction,
      Function againstFunction,
      String title,
      Widget statement,
      String forText,
      String againstText}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: statement,
            actions: [
              FlatButton(
                child: Text(againstText),
                onPressed: () {
                  againstFunction();
                },
              ),
              FlatButton(
                child: Text(forText),
                onPressed: () {
                  forFunction();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<dynamic> listItems(List<IItem> items, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Item Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[index].name),
                      Row(
                        children: [
                          Text(
                            "Quantity: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(items[index].quantity),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Total price:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              " Rs.${(double.parse(items[index].quantity)) * double.parse(items[index].price)}"),
                        ],
                      ),
                      Divider(),
                    ],
                  );
                },
                itemCount: items.length,
              ),
            ),
          );
        });
  }
}
