import 'package:fluttertoast/fluttertoast.dart';

class Utils {

  static void displayToast(String message) {
    Fluttertoast.showToast(msg: message);
  }
}