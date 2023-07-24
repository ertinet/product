import 'package:flutter/material.dart';
import 'package:trainear/SignInPage.dart';
import 'AlbumPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AudioUtils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioUtils.initAudioService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AudioUtils.clearAudioDir(); //temp
  runApp(MaterialApp(home: SignInPage()));
}