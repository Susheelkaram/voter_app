import 'package:flutter/material.dart';
import 'package:voter_app/models/voter.dart';

Voter _voter;

class VoterDetails extends StatefulWidget {
  VoterDetails(Voter voter) {
    _voter = voter;
  }

  @override
  State<StatefulWidget> createState() {
    return VoterDetailsState();
  }
}

class VoterDetailsState extends State<VoterDetails> {
  var _minPadding = 8.0;

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
              child: Text('Booth No.: ${_voter.pollingBoothNo}',
                  style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Address: ${_voter.address}',
                  style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('District: ${_voter.district}',
                  style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Village/Town: ${_voter.village}',
                  style: textStyle),
            ),
            Padding(
              padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
              child: Text('Mandal: ${_voter.mandal}',
                  style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
