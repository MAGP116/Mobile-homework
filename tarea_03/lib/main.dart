import 'package:flutter/material.dart';
import 'package:donativos/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.purple,
            textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
                bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                bodyText2: TextStyle(color: Colors.black54))),
        title: 'Donaciones',
        home: HomePage());
  }
}
