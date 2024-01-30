import 'package:flutter/widgets.dart';

enum UserType {
  student,
  faculty,
  admin,
}

class UserProvider extends ChangeNotifier {
  String? _userType;
  String? _userEmail;
  String? _userToken;

  String? get userType => _userType;
  String? get userEmail => _userEmail;
  String? get userToken => _userToken;

  void setUserType(String? userType) {
    _userType = userType;
    notifyListeners();
  }

  void setUserEmail(String? userEmail) {
    _userEmail = userEmail;
    notifyListeners();
  }

  void setUserToken(String? userToken) {
    _userToken = userToken;
    notifyListeners();
  }
}
