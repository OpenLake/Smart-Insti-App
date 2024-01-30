import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum UserType { faculty, student, admin }

class User {
  String email;
  String otp;
  UserType userType;
  final storage = FlutterSecureStorage();
  User({required this.email, required this.otp, required this.userType});

  Future<void> storeJwt(String jwt) async {
    await storage.write(key: 'jwt', value: jwt);
  }

  Future<String?> getJwt() async {
    return await storage.read(key: 'jwt');
  }
}
