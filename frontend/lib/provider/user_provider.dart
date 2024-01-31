import 'package:flutter/widgets.dart';

enum UserType {
  student,
  faculty,
  admin,
}

class UserProvider extends ChangeNotifier {
  String? _userType;
  String? _userEmail;

  String? get userType => _userType;
  String? get userEmail => _userEmail;

  void setUserType(String? userType) {
    _userType = userType;
    notifyListeners();
  }

  void setUserEmail(String? userEmail) {
    _userEmail = userEmail;
    notifyListeners();
  }
}
