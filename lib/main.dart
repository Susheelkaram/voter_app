import 'package:flutter/material.dart';
import 'package:voter_app/screens/login_screen.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My voter',
      home: LoginScreen(),
    );
  }
}