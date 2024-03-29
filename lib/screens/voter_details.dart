import 'package:flutter/material.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/models/voter.dart';
import 'package:voter_app/screens/voter_editor.dart';
import 'package:voter_app/utils/firestore_service.dart';

Voter _voter;
FirestoreService firestoreService;
bool _isAdmin;
Representative _representative;

class VoterDetails extends StatefulWidget {
  VoterDetails(Voter voter, bool isAdmin, {Representative representative}) {
    _voter = voter;
    _isAdmin = isAdmin;
    _representative = representative;
  }

  @override
  State<StatefulWidget> createState() {
    return VoterDetailsState();
  }
}

class VoterDetailsState extends State<VoterDetails> {
  var _minPadding = 8.0;

  @override
  void initState() {
    firestoreService = FirestoreService('voters');
    firestoreService.getDocById(_voter.docId).listen(
        (snapshot){
          setState(() {
            String docId = _voter.docId;
            _voter = Voter.fromSnapshot(snapshot);
            _voter.docId = docId;
          });
        }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Voter details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Center(
                  child: Text(
                '${_voter.name}',
                style: Theme.of(context).textTheme.display1,
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Age: ${_voter.age}', style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Phone: ${_voter.phone}', style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Constituency: ${_voter.constituency}',
                  style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child:
                  Text('Booth No.: ${_voter.pollingBoothNo}', style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Address: ${_voter.address}', style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('District: ${_voter.district}', style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Village/Town: ${_voter.village}', style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Mandal: ${_voter.mandal}', style: textStyle),
            ),

            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Created by: ${_voter.createdBy}', style: textStyle),
            ),

            // Delete/ Edit Voters option only for Representatives
            if (!_isAdmin)
              Padding(
                padding:
                    EdgeInsets.only(top: _minPadding * 5, bottom: _minPadding),
                child: Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: MaterialButton(
                                child: Text('Delete'),
                                color: Colors.red,
                                textColor: Colors.white,
                                onPressed: () {
                                  _deleteVoter();
                                })),
                        Container(
                          width: _minPadding,
                        ),
                        Expanded(
                            child: MaterialButton(
                                child: Text('Edit'),
                                color: Theme.of(context).primaryColorDark,
                                textColor: Colors.white,
                                onPressed: () {
                                  // Edit action
                                  _launchEditVoter(context, _voter);
                                })),
                      ],
                    )),
              )
          ],
        ),
      ),
    );
  }

  void _deleteVoter() {
    String docId = _voter.docId;
    firestoreService.removeDocument(docId);
    Navigator.pop(context);
  }

  void _launchEditVoter(BuildContext context, Voter voter) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VoterEditor('edit', _representative, voter: _voter);
    }));
  }
}
