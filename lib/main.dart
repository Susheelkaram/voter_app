import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/screens/login_screen.dart';
import 'package:voter_app/screens/splash_screen.dart';

import 'screens/voter_list.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My voter',
      routes: {
        '/home': (BuildContext context) => VoterList(),
        '/login': (BuildContext context) => LoginScreen(),
      },
      home: SplashScreen(),
    );

//    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
//      if(user != null){
//        Navigator.pushReplacementNamed(context, '/home');
//      }
//    });
  }
}
