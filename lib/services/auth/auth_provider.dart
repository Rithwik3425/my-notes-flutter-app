import 'package:mynotes/services/auth/auth_user.dart';

abstract class AuthProviderForNotes {
  AuthUser? get currentUser;
  Future<AuthUser?> logIn();
  Future<void> logOut();
}
