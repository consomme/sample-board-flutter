import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sampleboard/ui/timeline.dart';

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
        child: new FlatButton(
          child: const Text('Sign in'),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            _signIn()
            .then((user) {
              Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) => new TimelineScreen()
              ));
            })
            .catchError((e) => Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text(e.toString()),
            )));
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