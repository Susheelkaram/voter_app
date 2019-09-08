import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/screens/admin_signup.dart';
import 'package:voter_app/screens/voter_list.dart';

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
  var _isAdmin = false;
  var _formKey = GlobalKey<FormState>();
  TextEditingController _phoneInputController = TextEditingController();
  TextEditingController _passwordInputController = TextEditingController();

  @override
  void initState() {
    _selectedLoginType = _loginTypes[0];
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
          child: Padding(
            padding: EdgeInsets.all(_minPadding),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                  child: DropdownButton(
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
                  padding:
                      EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _phoneInputController,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText: '10 digit phone number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0))),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: _minPadding, bottom: _minPadding),
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
                  padding:
                      EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Colors.white,
                      child: Text('Login'),
                      onPressed: () {
                        _signIn();
                      }),
                ),
                if (_isAdmin)
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
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
          ),
        ));
  }

  void _signIn() {
    String phone = _phoneInputController.text;
    String password = _passwordInputController.text;
    String email = COUNTRY_CODE + phone + EMAIL_DOMAIN;

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((AuthResult result) {
      if (result.user != null) {
        _gotoHome(context);
      }
    });
  }
}

void _openSignupForm(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return AdminSignup();
  }));
}

void _gotoHome(BuildContext context) {
//  Navigator.pop(context);
//  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
//    return VoterList();
//  }));
  Navigator.pushReplacementNamed(context, '/home');
}
