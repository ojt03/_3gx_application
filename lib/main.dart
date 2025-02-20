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
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SideBar(),
      );
    }
  }
