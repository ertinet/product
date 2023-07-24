import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trainear/AlbumPage.dart';
import 'package:trainear/MainNavigator.dart';
import 'package:trainear/TestSongsPage.dart';

import 'SongsPage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
                onSaved: (value) {
                  _password = value!;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Use the _email and _password for actual sign in.
                    try {
                      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                          email: _email,
                          password: _password
                      );

                      MainNavigator.goToAlbumPage(context);
                      // Successful login. Navigate to next page or show a success message.
                    } on FirebaseAuthException catch (e) {
                      // Handle error. Show error message or handle it appropriately.
                      print(e.message);
                    }
                  }
                },
                child: Text('Sign In'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Sign in with google
                  try {
                    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

                    final AuthCredential credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );

                    UserCredential userCredential = await _auth.signInWithCredential(credential);
                    MainNavigator.goToAlbumPage(context);

                    // Successful login. Navigate to next page or show a success message.
                  } on FirebaseAuthException catch (e) {
                    // Handle error. Show error message or handle it appropriately.
                    print(e.message);
                  }
                },
                child: Text('Sign In with Google'),
              ),
              ElevatedButton(onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestSongsPage(),
                  ),
                );
              }, child: Text('Just songs page TEST'))
            ],
          ),
        ),
      ),
    );
  }
}
