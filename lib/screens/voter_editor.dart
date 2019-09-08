import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/models/voter.dart';
import 'package:voter_app/utils/firestore_service.dart';

class VoterEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoterEditorState();
  }
}

class VoterEditorState extends State<VoterEditor> {
  var _minPadding = 8.0;
  var _formKey = GlobalKey<FormState>();
  var _uid = '';
  FirestoreService firestoreService = FirestoreService('voters');

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _boothNoController = TextEditingController();
  TextEditingController _constituencyController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _villageController = TextEditingController();
  TextEditingController _mandalController = TextEditingController();
  TextEditingController _districtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      _uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add/Edit Voter'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Name *', 'Full Name *'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: _getInputDecoration('Phone *', 'Phone no. *'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: _getInputDecoration('Age *', 'in yrs *'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _boothNoController,
                  keyboardType: TextInputType.number,
                  decoration: _getInputDecoration('Booth no. *', 'Polling booth number *'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _constituencyController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Constituency *', 'Assembly constituency *'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _addressController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Address', 'H.no & Locality'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _villageController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Village/ Town', 'Village/Town'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _mandalController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Mandal', 'Mandal'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _districtController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('District', 'District'),
                ),
              ),

              ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Colors.white,
                  child: Text('Add Voter'),
                    onPressed: (){
                      // Add voter logic
                      _addVoter();
                    }
                ),
              ),
            ],
          ),
        ));
  }

  Voter _getVoter(){
    Voter voter = Voter();
    voter.name = _nameController.text;
    voter.phone = _phoneController.text;
    voter.age = int.parse(_ageController.text);
    voter.pollingBoothNo = int.parse(_boothNoController.text);
    voter.constituency = _constituencyController.text;
    voter.address = _addressController.text;
    voter.village = _villageController.text;
    voter.mandal = _mandalController.text;
    voter.district = _districtController.text;
    voter.creatorId = _uid;

    return voter;
  }
  void _addVoter(){
    Voter voter = _getVoter();
    firestoreService.addDocument(voter.toJson()).then((val) {
      Navigator.pop(context);
    });
  }
}

InputDecoration _getInputDecoration(String labelText, String hintText) {
  return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
      )
  );
}





