import 'package:discoveryapp/View/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Flutter book discovery',
      debugShowCheckedModeBanner: false,
      home: BookScreen(),
    );
  }
}

