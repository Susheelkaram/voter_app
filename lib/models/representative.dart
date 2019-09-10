import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Representative {

  String _name;
  String _phone;
  String _password;
  String _creatorId;
  String docId;
  DocumentReference reference;

  Representative(){
  }

  Representative.fromMap(Map<String, dynamic> map, {this.reference})
      : _phone = map['phone'],
        _name = map['name'],
        _password = map['password'],
        _creatorId = map['creator_id'];

  Representative.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // To JSON
  Map<String, dynamic> toJson() => _itemToJson(this);

  Map<String, dynamic> _itemToJson(Representative instance) {
    return <String, dynamic>{
      'name': _name,
      'phone': _phone,
      'password' : _password,
      'creator_id' : _creatorId,
    };
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get creatorId => _creatorId;

  set creatorId(String value) {
    _creatorId = value;
  }

}
