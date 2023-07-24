// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDrDRIh1-3-mWGhJh35UbcnHKOqCFrtfDk',
    appId: '1:1072835744078:web:c4ef4d65ab4a4f6d07ce1f',
    messagingSenderId: '1072835744078',
    projectId: 'trainear-22fe6',
    authDomain: 'trainear-22fe6.firebaseapp.com',
    storageBucket: 'trainear-22fe6.appspot.com',
    measurementId: 'G-KHTJ7TZDX9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRyvyqJ1Ur5af9WjEbs3xCEbwD18YU95Q',
    appId: '1:1072835744078:android:d22aa13c67dc505a07ce1f',
    messagingSenderId: '1072835744078',
    projectId: 'trainear-22fe6',
    storageBucket: 'trainear-22fe6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBJndc-_lzsZfGYyg_Abn8Vxahabp1X40',
    appId: '1:1072835744078:ios:f490f570ae71de1607ce1f',
    messagingSenderId: '1072835744078',
    projectId: 'trainear-22fe6',
    storageBucket: 'trainear-22fe6.appspot.com',
    iosClientId: '1072835744078-d94arhausi9c2i0lcgt1cir3hfec5vhr.apps.googleusercontent.com',
    iosBundleId: 'com.naamani.trainear',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCBJndc-_lzsZfGYyg_Abn8Vxahabp1X40',
    appId: '1:1072835744078:ios:63ad6ae268968bba07ce1f',
    messagingSenderId: '1072835744078',
    projectId: 'trainear-22fe6',
    storageBucket: 'trainear-22fe6.appspot.com',
    iosClientId: '1072835744078-pa0ooqc7i8a3m3svj3jjn06snkng1m13.apps.googleusercontent.com',
    iosBundleId: 'com.naamani.trainear.RunnerTests',
  );
}
