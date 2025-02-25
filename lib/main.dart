import 'package:_3gx_application/backend/get_branches.dart';
import 'package:_3gx_application/main_screens/item_page.dart';
import 'package:_3gx_application/main_screens/side_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: BottomNavBar(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

// Let me know if you want any adjustments! 🚀
