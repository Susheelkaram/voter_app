import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoterList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return VoterListState();
  }
}

class VoterListState extends State<VoterList> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Voters'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
        builder: (context, sn)
    );
  }
}