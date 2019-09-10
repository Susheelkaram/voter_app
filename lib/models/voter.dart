import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voter_app/utils/Constants.dart';

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
  String _createdBy;
  String _adminId;
  DocumentReference reference;
  String docId;

  Voter() {}

  Voter.fromMap(Map<String, dynamic> map, {this.reference})
      : _name = map['name'],
        _phone = map['phone'],
        _age = map['age'],
        _address = map['address'],
        _pollingBoothNo = map['polling_booth_no'],
        _village = map['village'],
        _mandal = map['mandal'],
        _district = map['district'],
        _constituency = map['constituency'],
        _creatorId = map['creator_id'],
        _createdBy = map['created_by'],
        _adminId = map['admin_id'];

  Voter.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // To JSON
  Map<String, dynamic> toJson() => _itemToJson(this);

  Map<String, dynamic> _itemToJson(Voter instance) {
    return <String, dynamic>{
      'name': _name,
      'phone': _phone,
      'age': _age,
      'address': _address,
      'polling_booth_no': _pollingBoothNo,
      'village': _village,
      'mandal': _mandal,
      'district': _district,
      'constituency': _constituency,
      'creator_id': _creatorId,
      'created_by': _createdBy,
      'admin_id': _adminId
    };
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get phone => _phone;

  set phone(String valueint) {
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

  String get adminId => _adminId;

  set adminId(String value) {
    _adminId = value;
  }

  String get createdBy => _createdBy;

  set createdBy(String value) {
    _createdBy = value;
  }


}
