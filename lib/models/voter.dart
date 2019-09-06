import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Voter {
  String _name;
  String _phone;
  int _age;
  String _address;
  int _pollingBoothNo;
  String _village;
  String _mandal;
  String _district;
  String _constituency;
  String _creatorId;
  DocumentReference reference;

  Voter.fromMap(Map<String, dynamic> map, {this.reference})
      : _name = map['name'],
        _phone = map['mobile'],
        _age = map['age'],
        _address = map['address'],
        _pollingBoothNo = map['polling_booth_no'],
        _village = map['village'],
        _mandal = map['mandal'],
        _district = map['district'],
        _constituency = map['constituency'],
        _creatorId = map['creator_id'];

  Voter.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get mobile => _phone;

  set mobile(String valueint) {
    _phone = valueint;
  }

  get age => _age;

  set age(int value) {
    _age = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  int get pollingBoothNo => _pollingBoothNo;

  set pollingBoothNo(int value) {
    _pollingBoothNo = value;
  }

  String get village => _village;

  set village(String value) {
    _village = value;
  }

  String get mandal => _mandal;

  set mandal(String value) {
    _mandal = value;
  }

  String get district => _district;

  set district(String value) {
    _district = value;
  }

  String get constituency => _constituency;

  set constituency(String value) {
    _constituency = value;
  }

  String get creatorId => _creatorId;

  set creatorId(String value) {
    _creatorId = value;
  }
}
