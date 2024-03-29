import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:voter_app/utils/utils.dart';

class FirestoreService {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  FirestoreService(this.path) {
    ref = _db.collection(path);
  }

  Stream<QuerySnapshot> getCollectionWhere(String key, String value) {
    return ref.where(key, isEqualTo: value).snapshots();
  }

  Stream<QuerySnapshot> getAll() {
    return ref.snapshots();
  }

  Stream<DocumentSnapshot> getDocById(String id) {
    return ref.document(id).snapshots();
  }

  Stream<QuerySnapshot> getRepresentativeByPhone(String phone) {
    return ref.where('phone', isEqualTo: phone).snapshots();
  }

  void removeDocument(String id) {
    ref.document(id).delete().then((value) {
      debugPrint("Deleted succesfully");
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  Future<DocumentReference> addDocument(Map data) {
    ref.add(data).then((ref) {
      debugPrint("Document added successfully");
      return ref;
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void updateDocument(Map data, String id) {
    ref.document(id).updateData(data).then((value) {
      debugPrint("Updated succesfully");
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }
}
