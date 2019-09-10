import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/screens/home.dart';
import 'package:voter_app/utils/firestore_service.dart';

FirestoreService firestoreService;
String _creatorUid;

class AddRepresentative extends StatefulWidget {
  AddRepresentative(String UID){
    _creatorUid = UID;
  }

  @override
  State<StatefulWidget> createState() {
    return AddRepresentativeState();
  }
}

class AddRepresentativeState extends State<AddRepresentative> {
  String verId;
  String smsCode;
  String creatorId = '';
  final COUNTRY_CODE = '+91';
  final EMAIL_DOMAIN = '@susheel.com';
  var _minPadding = 10.0;
  var _formKey = GlobalKey<FormState>();


  TextEditingController _phoneInputController = TextEditingController();
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _passwordInputController = TextEditingController();
  TextEditingController _repeatPasswordInputController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService('representatives');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Representative'),
        ),
        body: Padding(
            padding: EdgeInsets.all(_minPadding),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding:
                    EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: _phoneInputController,
                        decoration: _getInputDecoration(
                            'Phone', '10 digit phone number')),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _nameInputController,
                        decoration: _getInputDecoration('Name', 'Full name')),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _passwordInputController,
                        decoration:
                        _getInputDecoration('Password', 'Password')),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _repeatPasswordInputController,
                        decoration: _getInputDecoration(
                            'Re-enter Password', 'Re-enter Password')),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minPadding, bottom: _minPadding),
                      child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Colors.white,
                          child: Text('Add Representative'),
                          onPressed: () {
                            // Representative Create account action
                            _saveRepresentative();
                          })),

                ],
              ),
            )));
  }

  Representative _getRepresentative(){
    Representative representative =  Representative();
    representative.name = _nameInputController.text;
    representative.phone = _phoneInputController.text;
    representative.password = _passwordInputController.text;
    representative.creatorId = _creatorUid;

    return representative;
  }

  void _saveRepresentative() {
    Representative representative = _getRepresentative();
    firestoreService.addDocument(representative.toJson());
    Navigator.pop(context);

  }
}

InputDecoration _getInputDecoration(String labelText, String hintText) {
  return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2.0),
      ));
}

