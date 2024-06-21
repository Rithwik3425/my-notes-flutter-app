import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final User? user;

  const AuthUser({
    this.user,
  });

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(user: user);
  }
}
