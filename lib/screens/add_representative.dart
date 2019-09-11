import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/screens/home.dart';
import 'package:voter_app/utils/firestore_service.dart';
import 'package:voter_app/utils/utils.dart';

FirestoreService firestoreService;
String _creatorUid;

class AddRepresentative extends StatefulWidget {
  AddRepresentative(String UID) {
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
                        validator: (value) {
                          if (value.length != 10) {
                            return 'Enter valid phone number';
                          }
                          return null;
                        },
                        decoration: _getInputDecoration(
                            'Phone', '10 digit phone number')),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nameInputController,
                      decoration: _getInputDecoration('Name', 'Full name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter valid name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _passwordInputController,
                      decoration: _getInputDecoration('Password', 'Password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Enter valid password (atleast 4 characters)';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _repeatPasswordInputController,
                      decoration: _getInputDecoration(
                          'Re-enter Password', 'Re-enter Password'),
                      validator: (value) {
                        if (value.isEmpty || value != _passwordInputController.text) {
                          return 'Passwords should match';
                        }
                        return null;
                      },
                    ),
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
                            if (_formKey.currentState.validate()) {
                              _saveRepresentative();
                            }
                          })),
                ],
              ),
            )));
  }

  Representative _getRepresentative() {
    Representative representative = Representative();
    representative.name = _nameInputController.text;
    representative.phone = _phoneInputController.text;
    representative.password = _passwordInputController.text;
    representative.creatorId = _creatorUid;

    return representative;
  }

  void _saveRepresentative() async {
    Representative representative = _getRepresentative();
    QuerySnapshot reps = await firestoreService
        .getRepresentativeByPhone(representative.phone)
        .first;

    if (reps.documents.length == 0) {
      firestoreService.addDocument(representative.toJson());
      Utils.displayToast('Representative created successfully');
      Navigator.pop(context);
      return;
    }

    // Representative with same phone exists
    Utils.displayToast('Representative already exists');
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
