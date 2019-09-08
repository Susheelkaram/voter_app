import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/models/voter.dart';
import 'package:voter_app/screens/voter_details.dart';
import 'package:voter_app/screens/voter_editor.dart';

import 'login_screen.dart';

class VoterList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoterListState();
  }
}

class VoterListState extends State<VoterList> {
  var count = 0;
  var displayName = '';

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        displayName = user.displayName + user.email;
        debugPrint("Logged in: $displayName");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
//      if (user == null) {
//        Navigator.pushReplacement(context,
//            MaterialPageRoute(builder: (BuildContext context) {
//          return LoginScreen();
//        }));
//      }
//    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _openVoterEditor(context);
          }),
      appBar: AppBar(
        title: Text('My Voters ($displayName)'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                _signOut(context);
              })
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('voters').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildVoterList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildVoterList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildVoterListItem(context, data)).toList(),
    );
  }

  Widget _buildVoterListItem(BuildContext context, DocumentSnapshot data) {
    final voter = Voter.fromSnapshot(data);
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
}

void _openVoterDetails(BuildContext context, Voter voter) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return VoterDetails(voter);
  }));
}

void _openVoterEditor(BuildContext context, {Voter voter}) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return VoterEditor();
  }));
}

void _signOut(BuildContext context) {
  FirebaseAuth.instance.signOut().then((value) {
    Navigator.pushReplacementNamed(context, '/login');
  });
}
