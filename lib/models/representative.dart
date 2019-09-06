import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Representative {
  String _uid;
  String _name;
  String _phone;
  String _email;
  DocumentReference reference;

  Representative.fromMap(Map<String, dynamic> map, {this.reference})
      : _uid = map['uid'],
        _phone = map['phone'],
        _name = map['name'],
        _email = map['email'];

  Representative.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }
}
