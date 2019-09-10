

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/models/voter.dart';
import 'package:voter_app/screens/voter_details.dart';

class RepresentativeListHelper {
  String uid = '';

  RepresentativeListHelper(String _uid){
    uid = _uid;
  }

  Widget buildBody(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _getStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildRepresentativeList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildRepresentativeList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children: snapshot.map((data) => _buildVoterListItem(context, data)).toList(),
    );
  }

  Widget _buildVoterListItem(BuildContext context, DocumentSnapshot data) {
    Representative representative = Representative.fromSnapshot(data);
    representative.docId = data.documentID;

    return Padding(
        key: ValueKey(representative.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text('${representative.name}'),
              subtitle: Text(representative.phone),
              onTap: () {
                // On tapping Representative item
              },
            )));
  }

  Stream<QuerySnapshot> _getStream() {
//    if (_isAdmin) {
      return Firestore.instance.collection('representatives').where('creator_id', isEqualTo: uid).snapshots();
//    }
//    if(currentRep != null){
//      return Firestore.instance
//          .collection('voters')
//          .where('creator_id', isEqualTo: currentRep.phone)
//          .snapshots();
//    }
  }


}



