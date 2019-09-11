import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voter_app/screens/home.dart';

class AdminSignup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdminSignupState();
  }
}

class AdminSignupState extends State<AdminSignup> {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  String verId;
  String smsCode;
  final COUNTRY_CODE = '+91';
  final EMAIL_DOMAIN = '@susheel.com';
  var _minPadding = 10.0;
  var _formKey = GlobalKey<FormState>();
  TextEditingController _phoneInputController = TextEditingController();
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _passwordInputController = TextEditingController();
  TextEditingController _repeatPasswordInputController =
      TextEditingController();
  TextEditingController _otpInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Sign Up'),
        ),
        body: Padding(
            padding: EdgeInsets.all(_minPadding),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      controller: _phoneInputController,
                      decoration:
                          _getInputDecoration('Phone', '10 digit phone number'),
                      validator: (value) {
                        if (value.isEmpty || value.length != 10) {
                          return 'Enter valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nameInputController,
                      decoration: _getInputDecoration('Name', 'Full name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter valid name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _passwordInputController,
                        validator: (value) {
                          if (value.length < 4) {
                            return 'Enter valid password (atleasr 4 Characters)';
                          }
                          return null;
                        },
                        decoration:
                            _getInputDecoration('Password', 'Password')),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _repeatPasswordInputController,
                      decoration: _getInputDecoration(
                          'Re-enter Password', 'Re-enter Password'),
                      validator: (value) {
                        if (value != _passwordInputController.text) {
                          return 'Passwords should match';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minPadding, bottom: _minPadding),
                      child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Colors.white,
                          child: Text('Sign Up'),
                          onPressed: () {
                            // Admin Sign up action
                            if(_formKey.currentState.validate()){
                              _verifyPhone();
                            }
                          })),
                  Padding(
                    padding:
                        EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _otpInputController,
                        decoration: _getInputDecoration('OTP', 'Enter OTP')),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minPadding, bottom: _minPadding),
                      child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Colors.white,
                          child: Text('Confirm OTP'),
                          onPressed: () {
                            // Manual OTP confirm
                            _signInWithOtp();
                          })),
                ],
              ),
            )));
  }

  // Phone Verification & Sign in
  Future<void> _verifyPhone() async {
    String phone = COUNTRY_CODE + _phoneInputController.text;

    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout =
        (String verificationId) {
      verId = verificationId;
    };
    PhoneCodeSent onCodeSent = (String verificationId, [int forceResendToken]) {
      verId = verificationId;
      debugPrint("Sms Code sent");
    };

    PhoneVerificationCompleted verifySuccess =
        (AuthCredential phoneAuthCredential) {
      // On OTP Auto verified
      _signInWithCredential(phoneAuthCredential);
    };
    PhoneVerificationFailed verifyFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 20),
        verificationCompleted: verifySuccess,
        verificationFailed: verifyFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  void _signInWithOtp() {
    String code = _otpInputController.text;
    FirebaseAuth mAuth = FirebaseAuth.instance;
    AuthCredential phoneCredential =
        PhoneAuthProvider.getCredential(verificationId: verId, smsCode: code);
    _signInWithCredential(phoneCredential);
  }

  // Signing in with Phone credential
  void _signInWithCredential(AuthCredential phoneCredential) {
    mAuth.signInWithCredential(phoneCredential).then((AuthResult result) {
      if (result.user != null) {
        debugPrint("Signed in with PhoneAuth succesfully.");
        _linkEmailCredential();
      }
    }).catchError((error) {
      debugPrint('ERROR: ${error}');
    });
  }

  // Links Phone and Email credentials
  void _linkEmailCredential() {
    FirebaseAuth mAuth = FirebaseAuth.instance;

    String phone = _phoneInputController.text;
    String password = _passwordInputController.text;
    String email = COUNTRY_CODE + phone + EMAIL_DOMAIN;

    AuthCredential emailCredential =
        EmailAuthProvider.getCredential(email: email, password: password);

    mAuth.currentUser().then((user) {
      user.linkWithCredential(emailCredential).then((AuthResult result) {
        if (result.user != null) {
          debugPrint("Credentials linked succesfully.");
          _updateDisplayName();
        }
      }).catchError((error) {
        debugPrint('ERROR: ${error}');
      });
    });
  }

  void _updateDisplayName() {
    mAuth.currentUser().then((user) {
      String displayName = _nameInputController.text;
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = displayName;

      user.updateProfile(userUpdateInfo).then((dynamic) {
        _gotoHome(context);
      });
    });
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

void _gotoHome(BuildContext context) {
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) {
    return VoterList(true);
  }));
}
