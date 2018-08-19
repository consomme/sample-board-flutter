import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email'
    ]
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: const Text('Sign in'),
          onPressed: () {
            _signIn()
            .then((user) => print("signed in " + user.displayName))
            .catchError((e) => print(e));
          },
        )
      )
    );
  }

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    return user;
  }
}