import 'package:flutter/foundation.dart';

class EmailProvider with ChangeNotifier {
  String _email = '';

  String get email => _email;

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
}
