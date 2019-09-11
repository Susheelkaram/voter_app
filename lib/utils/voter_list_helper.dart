

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/models/voter.dart';
import 'package:voter_app/screens/voter_details.dart';

class VoterListHelper {
  bool _isAdmin = true;
  Representative currentRep;
  String uid;

  VoterListHelper(bool isAdmin,{Representative representative, String UID}){
    _isAdmin = isAdmin;
    currentRep = representative;
    debugPrint("Current Admin ID - $UID");
    uid = UID;
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildVoterList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildVoterList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    debugPrint("Rep stream size: ${snapshot.length}");
    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children:
      snapshot.map((data) => _buildVoterListItem(context, data)).toList(),
    );
  }

  Widget _buildVoterListItem(BuildContext context, DocumentSnapshot data) {
    Voter voter = Voter.fromSnapshot(data);
    voter.docId = data.documentID;

    return Padding(
        key: ValueKey(voter.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text('${voter.name} (Age: ${voter.age.toString()})'),
              subtitle: Text(voter.phone),
              trailing: Text(voter.pollingBoothNo.toString()),
              onTap: () {
                _openVoterDetails(context, voter);
              },
            )));
  }

  Stream<QuerySnapshot> _getStream() {

    // Admin mode
    if (_isAdmin) {
      debugPrint("Fetching voters under Admin ID - $uid");
      return Firestore.instance.collection('voters').where('admin_id', isEqualTo: uid).snapshots();
    }

    // Representative mode
    if(!_isAdmin && currentRep != null){
      return Firestore.instance
          .collection('voters')
          .where('creator_id', isEqualTo: currentRep.phone)
          .snapshots();
    }
  }

  void _openVoterDetails(BuildContext context, Voter voter) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return VoterDetails(voter, _isAdmin, representative: currentRep);
    }));
  }
}



