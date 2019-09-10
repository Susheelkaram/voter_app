import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/screens/admin_signup.dart';
import 'package:voter_app/screens/home.dart';
import 'package:voter_app/utils/firestore_service.dart';
import 'package:voter_app/utils/rep_manager.dart';

var _isAdmin = false;
RepManager repManager;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final COUNTRY_CODE = '+91';
  final EMAIL_DOMAIN = '@susheel.com';
  var _loginTypes = ['Representative', 'Admin'];
  var _selectedLoginType = '';
  var _minPadding = 10.0;
  var _formKey = GlobalKey<FormState>();
  TextEditingController _phoneInputController = TextEditingController();
  TextEditingController _passwordInputController = TextEditingController();

  FirestoreService repsFirestoreService = FirestoreService('representatives');

  @override
  void initState() {
    _selectedLoginType = _loginTypes[0];
    repManager = RepManager();
    repManager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          key: _formKey,
          child: Center(
              child: Card(
                  margin: EdgeInsets.all(10.0),
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: ListView(
                      children: <Widget>[
                        Icon(
                          Icons.people_outline,
                          color: Theme.of(context).primaryColorDark,
                          size: 100.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: _minPadding, bottom: _minPadding),
                          child: DropdownButton(
                              isExpanded: true,
                              value: _selectedLoginType,
                              items: _loginTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  _selectedLoginType = newValue;
                                  if (newValue == 'Admin') {
                                    _isAdmin = true;
                                  } else {
                                    _isAdmin = false;
                                  }
                                });
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: _minPadding, bottom: _minPadding),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _phoneInputController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                labelText: 'Phone',
                                hintText: '10 digit phone number',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: _minPadding, bottom: _minPadding),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _passwordInputController,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: _minPadding, bottom: _minPadding),
                          child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Colors.white,
                              child: Text('Login'),
                              onPressed: () {
                                debugPrint('login clicked');
                                _signIn();
                              }),
                        ),
                        if (_isAdmin)
                          Padding(
                            padding: EdgeInsets.only(
                                top: _minPadding, bottom: _minPadding),
                            child: MaterialButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Colors.white,
                                child: Text('Create Account'),
                                onPressed: () {
                                  _openSignupForm(context);
                                }),
                          )
                      ],
                    ),
                  ))),
        ));
  }

  void _signIn() async {
    String phone = _phoneInputController.text;
    String password = _passwordInputController.text;
    String email = COUNTRY_CODE + phone + EMAIL_DOMAIN;

    if (_isAdmin) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((AuthResult result) {
        if (result.user != null) {
          _gotoHome(context);
        }
      });
      return;
    }

    // Representative Login
    debugPrint('Representative : rep login');
    QuerySnapshot snapshot =
        await repsFirestoreService.getRepresentativeByPhone(phone).first;
    DocumentSnapshot docSnapshot = snapshot.documents[0];
    Representative representative = Representative.fromSnapshot(docSnapshot);

    debugPrint('Representative : ${representative.phone}');
    debugPrint('Representative pass: ${representative.password} : $password');

    if (password == representative.password) {
      repManager.login(representative);
      _gotoHome(context);
    }
  }
}

void _openSignupForm(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return AdminSignup();
  }));
}

void _gotoHome(BuildContext context) {
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) {
    return VoterList(_isAdmin);
  }));
}
