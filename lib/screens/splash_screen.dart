import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voter_app/screens/home.dart';
import 'package:voter_app/utils/rep_manager.dart';

RepManager repManager;
bool _isAdmin = false;

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    repManager = RepManager();
    repManager.init();

    Future.delayed(const Duration(seconds: 1), () {
      FirebaseAuth.instance.currentUser().then((currentUser) {
        if (currentUser == null) {


          var repLoginStatus = repManager.isLoggedIn();
          if (repLoginStatus != null && repLoginStatus == true) {
            _gotoHome(context);
            return;
          }
          Navigator.pushReplacementNamed(context, "/login");
        }
        else {
          _isAdmin = true;
          _gotoHome(context);
        }
      }).catchError((err) => print(err));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.people_outline,
                  size: 150.0,
                  color: Theme.of(context).primaryColorDark,
                ),
                Text(
                  "My Voters",
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: LinearProgressIndicator(),
                )
              ],
            )),
      ),
    );
  }
}

void _gotoHome(BuildContext context) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
    return VoterList(_isAdmin);
  }));
}
