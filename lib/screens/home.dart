import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/models/voter.dart';
import 'package:voter_app/screens/add_representative.dart';
import 'package:voter_app/screens/voter_details.dart';
import 'package:voter_app/screens/voter_editor.dart';
import 'package:voter_app/utils/rep_list_helper.dart';
import 'package:voter_app/utils/rep_manager.dart';
import 'package:voter_app/utils/voter_list_helper.dart';

import 'login_screen.dart';

bool _isAdminMode = false;
bool _showVoters = true;
bool _showFab = true;
String _uid = '';
Representative currentRep;
RepManager representativeManager;
VoterListHelper _voterListHelper;
RepresentativeListHelper _representativeListHelper;

class VoterList extends StatefulWidget {
  VoterList(bool isAdminMode) {
    _isAdminMode = isAdminMode;
  }

  @override
  State<StatefulWidget> createState() {
    return VoterListState();
  }
}

class VoterListState extends State<VoterList> {
  var count = 0;
  var displayName = '';
  var _lists = ['Voters', 'Representatives'];
  var _listDropdownValue;

  @override
  void initState() {
    super.initState();
    _listDropdownValue = _lists[0];
    _showVoters = true;
    _representativeListHelper = RepresentativeListHelper(_uid);
    _voterListHelper = VoterListHelper(_isAdminMode);

    // Admin Mode
    if (_isAdminMode) {
      FirebaseAuth.instance.currentUser().then((user) {
        setState(() {
          if (user != null) {
            _uid = user.uid;
            _showFab = false;
            displayName =
                'Admin: Logged in as ${user.displayName} (${user.phoneNumber})';
            debugPrint("Logged in as $displayName (Admin)");
            _representativeListHelper.uid = _uid;
            _voterListHelper.uid = _uid;
          }
        });
      });
      return;
    }

    // Representative Mode
    _getCurrentRepresentative().then((val) {
      setState(() {
        _showFab = true;
        displayName =
            'Representative: Logged in as ${currentRep.name} (${currentRep.phone})';
        _voterListHelper.currentRep = currentRep;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Visibility(
            visible: _showFab,
            child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  if (_isAdminMode) {
                    _openAddRepresentative(context);
                    return;
                  }
                  _openVoterEditor(context);
                })),
        appBar: AppBar(
          title: Text('My Voters'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () {
                  _signOut(context);
                })
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(displayName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    )
                  ],
                )),
            if (_isAdminMode)
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton(
                          value: _listDropdownValue,
                          isExpanded: true,
                          items: _lists.map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (item) {
                            setState(() {
                              _onListDropDownChanged(item);
                            });
                          }),
                    ),
                  ],
                ),
              ),
            if (_isAdminMode && !_showVoters)
              Expanded(
                child: _representativeListHelper.buildBody(context),
              ),
            if (_showVoters)
              Expanded(
                child: _voterListHelper.buildBody(context),
              ),
          ],
        ));
  }

  void _onListDropDownChanged(String val) {
    _listDropdownValue = val;
    if (val == 'Voters') {
      _showFab = false;
      _showVoters = true;
      return;
    }
    _showFab = true;
    _showVoters = false;
  }
}


void _openVoterDetails(BuildContext context, Voter voter) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return VoterDetails(voter, _isAdminMode);
  }));
}

void _openVoterEditor(BuildContext context, {Voter voter}) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return VoterEditor('new', currentRep);
  }));
}

void _openAddRepresentative(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return AddRepresentative(_uid);
  }));
}

// Sign out for Both Admin and Representative
void _signOut(BuildContext context) {
  if (_isAdminMode) {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, '/login');
    });
    return;
  }
  representativeManager.signOut();
  Navigator.pushReplacementNamed(context, '/login');
}

Future<void> _getCurrentRepresentative() async {
  representativeManager = RepManager();
  await representativeManager.init();
  currentRep = await representativeManager.getCurrentRep();
}
