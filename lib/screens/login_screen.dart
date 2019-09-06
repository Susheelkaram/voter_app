import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  var _loginTypes = ['Admin', 'Representative'];
  var _selectedLoginType = '';
  var _minPadding = 10.0;
  var _formKey = GlobalKey<FormState>();
  TextEditingController _phoneInputController = TextEditingController();
  TextEditingController _passwordInputController = TextEditingController();

  @override
  void initState() {
    _selectedLoginType = _loginTypes[0];
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
                      items: _loginTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedLoginType = newValue;
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
                    keyboardType: TextInputType.number,
                    controller: _passwordInputController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                  child: Expanded(
                      child: RaisedButton(
                          child: Text('Login'),
                          onPressed: (){
                            // Login action
                          }
                      )
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
