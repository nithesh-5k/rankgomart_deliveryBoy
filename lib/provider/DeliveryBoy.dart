import 'package:delivery_boy/model/DeliveryBoyModel.dart';
import 'package:delivery_boy/request.dart';
import 'package:delivery_boy/services/PushNotificationManager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryBoy extends ChangeNotifier {
  DeliveryBoyModel deliveryBoy;
  String pass, phno;

  Future<void> storeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("phno", phno);
    await prefs.setString("pass", pass);
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phno = (prefs.getString("phno") ?? null);
    pass = (prefs.getString("pass") ?? null);
  }

  Future<void> deleteUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("phno", null);
    await prefs.setString("pass", null);
    phno = null;
    pass = null;
  }

  Future<bool> checkLogin(BuildContext context) async {
    await fetchUserId();
    if (pass != null && phno != null) {
      getUserDetails(phno, pass, context);
    }
    return pass == null || phno == null;
  }

  var responseBody;
  Future<String> getUserDetails(
      String phno, String pass, BuildContext context) async {
    this.phno = phno;
    this.pass = pass;
    Map<String, String> body = {
      "custom_data": "checkdeliveryboylogin",
      "userName": phno,
      "userPassword": pass
    };
    responseBody = await postRequest("API/deliveryboy_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        return responseBody['errormessage'];
      } else {
        deliveryBoy = DeliveryBoyModel.fromJson(responseBody);
        PushNotificationsManager.init(context);
        storeUserId();
        return "Login done!";
      }
    }
  }
}
