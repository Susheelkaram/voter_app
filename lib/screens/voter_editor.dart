import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_app/models/representative.dart';
import 'package:voter_app/models/voter.dart';
import 'package:voter_app/utils/firestore_service.dart';

Voter voterDetails;
bool _isEditMode = false;
Representative _representative;
var _creatorId = '';
var _adminId = 'blank';
var _docId = '';
TextEditingController _nameController;
TextEditingController _phoneController;
TextEditingController _ageController;
TextEditingController _boothNoController;
TextEditingController _constituencyController;
TextEditingController _addressController;
TextEditingController _villageController;
TextEditingController _mandalController;
TextEditingController _districtController;

class VoterEditor extends StatefulWidget {
  VoterEditor(String mode, Representative representative, {Voter voter}) {
    _representative = representative;

    if (mode == 'edit') {
      voterDetails = voter;
      _isEditMode = true;
    } else {
      _isEditMode = false;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return VoterEditorState();
  }
}

class VoterEditorState extends State<VoterEditor> {
  var _minPadding = 8.0;

//  var _formKey = GlobalKey<FormState>();
  FirestoreService firestoreService = FirestoreService('voters');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
    _boothNoController = TextEditingController();
    _constituencyController = TextEditingController();
    _addressController = TextEditingController();
    _villageController = TextEditingController();
    _mandalController = TextEditingController();
    _districtController = TextEditingController();

    if (_isEditMode) {
      _setFormData(voterDetails);
    } else {
      _resetForm();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add/Edit Voter'),
        ),
        body: Form(
//          key: _formKey,
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
                  decoration: _getInputDecoration(
                      'Booth no. *', 'Polling booth number *'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _constituencyController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration(
                      'Constituency *', 'Assembly constituency *'),
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
                  decoration:
                      _getInputDecoration('Village/ Town', 'Village/Town'),
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
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Colors.white,
                        child: Text('Save Voter'),
                        onPressed: () {
                          // Add voter logic
                          _saveVoter();
                        }),
                  )),
            ],
          ),
        ));
  }

  Voter _getVoter() {
    _creatorId = _representative.phone;
   _adminId = _representative.creatorId;
   var createdBy = _representative.name + '(' + _representative.phone + ')';

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
    voter.creatorId = _creatorId;
    voter.createdBy = createdBy;
    voter.adminId = _adminId;

    return voter;
  }

  void _saveVoter() {
    Voter voter = _getVoter();
    debugPrint('Creator: ${voter.creatorId} : $_creatorId');

    if (_isEditMode) {
      firestoreService.updateDocument(voter.toJson(), _docId);
      Navigator.pop(context);
      return;
    }
    firestoreService.addDocument(voter.toJson());
    Navigator.pop(context);
  }
}

InputDecoration _getInputDecoration(String labelText, String hintText) {
  return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2.0),
      ));
}

void _setFormData(Voter voter) {
  _ageController.text = voter.age.toString();
  _boothNoController.text = voter.pollingBoothNo.toString();
  _nameController.text = voter.name;
  _phoneController.text = voter.phone;
  _constituencyController.text = voter.constituency;
  _addressController.text = voter.address;
  _villageController.text = voter.village;
  _mandalController.text = voter.mandal;
  _districtController.text = voter.district;
  _docId = voter.docId;
  _creatorId = voter.creatorId;

  debugPrint('Document id edit: ${voter.docId}');
}

void _resetForm() {
  _ageController.clear();
  _ageController.clear();
  _boothNoController.clear();
  _nameController.clear();
  _phoneController.clear();
  _constituencyController.clear();
  _addressController.clear();
  _villageController.clear();
  _mandalController.clear();
  _districtController.clear();
  _docId = '';
  _creatorId = '';
  _adminId = '';
}
