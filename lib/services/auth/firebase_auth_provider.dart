import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProviderForNotes {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser?> logIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      log(userCredential.user!.uid);

      return userCredential.user!.emailVerified
          ? AuthUser.fromFirebase(userCredential.user!)
          : null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<void> logOut() {
    try {
      FirebaseAuth.instance.signOut();
      GoogleSignIn().signOut();
      return Future.value();
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to log out');
    }
  }
}
