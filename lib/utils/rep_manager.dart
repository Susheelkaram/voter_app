import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_app/models/representative.dart';
import 'dart:convert';

class RepManager {
  SharedPreferences prefs;
  final String KEY_ISLOGGEDIN = 'isLoggedIn';
  final String KEY_CURRENTREP = 'currentRep';
  Representative _currentRep;

  RepManager() {

  }

  init() async{
    prefs = await SharedPreferences.getInstance();
  }

  login(Representative representative){
    prefs.setBool(KEY_ISLOGGEDIN, true);
    prefs.setString(KEY_CURRENTREP, json.encode(representative.toJson()));
  }

  signOut(){
    prefs.setBool(KEY_ISLOGGEDIN, false);
    prefs.setString(KEY_CURRENTREP, '');
  }

  Future<Representative> getCurrentRep() async{
      Map<String, dynamic> currentRepMap = await json.decode(prefs.getString(KEY_CURRENTREP));
      Representative representative = Representative.fromMap(currentRepMap);
      return representative;
  }

  isLoggedIn(){
    return prefs.getBool(KEY_ISLOGGEDIN);
  }
}
