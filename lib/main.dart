import 'package:delivery_boy/pages/login/LoginScreen.dart';
import 'package:delivery_boy/provider/DeliveryBoy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DeliveryBoy(),
        )
      ],
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
