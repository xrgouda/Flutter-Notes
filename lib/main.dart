import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/Main_Page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

