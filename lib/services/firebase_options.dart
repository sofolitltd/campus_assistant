// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8aqnai4a3dl7zyUCZcU0Uc2NThxnshKk',
    appId: '1:317190642822:web:14764c505c5cf9085cc507',
    messagingSenderId: '317190642822',
    projectId: 'campus-assistant-bd',
    authDomain: 'campus-assistant-bd.firebaseapp.com',
    storageBucket: 'campus-assistant-bd.appspot.com',
    measurementId: 'G-P8EBG235RN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDB1HyE6TECSrUKp6DR8QUoaKUhy2CLig4',
    appId: '1:317190642822:android:c276161f6bc01e295cc507',
    messagingSenderId: '317190642822',
    projectId: 'campus-assistant-bd',
    storageBucket: 'campus-assistant-bd.appspot.com',
  );
}
