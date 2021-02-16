import 'package:delivery_boy/provider/DeliveryBoy.dart';
import 'package:delivery_boy/request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static bool _initialized = false;

  static Future<void> init(BuildContext context) async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      registerToken(token, context);

      _initialized = true;
    }
  }
}

var responseBody;
Future<void> registerToken(String token, BuildContext context) async {
  Map<String, String> body = {
    "deliveryboyId": Provider.of<DeliveryBoy>(context, listen: false)
        .deliveryBoy
        .deliveryboyId,
    "deviceToken": token,
    "custom_data": "updatedevicetoken"
  };
  responseBody = await postRequest("API/register_api.php", body);
  if (responseBody['success'] == null ? false : responseBody['success']) {
    if (responseBody['appresponse'] == "failed") {
      print(responseBody['errormessage']);
    } else {
      print("Token registered!");
    }
  }
}
