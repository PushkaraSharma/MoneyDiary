import 'package:flutter/material.dart';
import 'package:money_diary/starting_views/first_view.dart';
import 'package:money_diary/home.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Money Diary",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FirstView(),
      routes: <String,WidgetBuilder>{
        '/signUp':(BuildContext context)=>Home(),
      }
    );
  }
}
