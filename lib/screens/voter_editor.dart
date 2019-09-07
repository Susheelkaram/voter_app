import 'package:flutter/material.dart';

class VoterEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoterEditorState();
  }
}

class VoterEditorState extends State<VoterEditor> {
  var _minPadding = 8.0;
  var _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();

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
                  controller: _nameController,
                  keyboardType: TextInputType.number,
                  decoration: _getInputDecoration('Phone *', 'Phone no. *'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.number,
                  decoration: _getInputDecoration('Age *', 'in yrs *'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.number,
                  decoration: _getInputDecoration('Booth no. *', 'Polling booth number *'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Constituency *', 'Assembly constituency *'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Address', 'H.no & Locality'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Village/ Town', 'Village/Town'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: _getInputDecoration('Mandal', 'Mandal'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                child: TextFormField(
                  controller: _nameController,
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
                    }
                ),
              ),
            ],
          ),
        ));
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
