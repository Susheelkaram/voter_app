import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  FirestoreService(this.path) {
    ref = _db.collection(path);
  }

//
//  Future<QuerySnapshot> getDataCollection() {
//    return ref.getDocuments();
//  }
//
//  Stream<QuerySnapshot> streamDataCollection() {
//    return ref.snapshots();
//  }
//
//  Future<DocumentSnapshot> getDocumentById(String id) {
//    return ref.document(id).get();
//  }

  void removeDocument(String id) {
    ref.document(id).delete().then((value) {
      debugPrint("Deleted succesfully");
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  Future<DocumentReference> addDocument(Map data) {
    ref.add(data).then((ref) {
      debugPrint("Deleted succesfully");
      return ref;
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void updateDocument(Map data, String id) {
    ref.document(id).updateData(data).then((value) {
      debugPrint("Deleted succesfully");
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }
}
