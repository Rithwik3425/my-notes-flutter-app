import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mynotes/_screens/home_screen.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthUser? user;
  Future<AuthUser?> _signInWithGoogle() async {
    user = await FirebaseAuthProvider().logIn();
    log('from the sign in screen: ${user?.user}');
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // This makes the column height just enough to contain its children.
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 12,
                shadowColor: const Color.fromARGB(255, 0, 140, 255),
              ),
              onPressed: () async {
                final AuthUser? user = await _signInWithGoogle();
                if (user != null) {
                  // Navigate to the home screen
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.g_mobiledata_outlined),
                  Text('Sign in with Google'),
                ],
              ),
            ),
            // Add another component here. For example, a Text widget:
            const Padding(
              padding: EdgeInsets.only(
                  top: 20), // Add some spacing between the button and the text
              child: Text(
                'Welcome to the app!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
