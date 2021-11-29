import 'package:flut_news/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutNews',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primaryColor: Colors.blue,
          ),
      home: LoginScreen(),
    );
  }
}
