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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBSqNDa3sPfVv2MgxKd3veQ5qwDCAAgxVw',
    appId: '1:239404326768:web:892c66b6297baccd5cb9b5',
    messagingSenderId: '239404326768',
    projectId: 'nutripeek-81a9b',
    authDomain: 'nutripeek-81a9b.firebaseapp.com',
    storageBucket: 'nutripeek-81a9b.appspot.com',
    measurementId: 'G-3ZEPW4L836',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDa2aELDTFuOvaAjFAoWmwjr77KoGW4ufM',
    appId: '1:239404326768:android:c6d3c3c23e5ecd625cb9b5',
    messagingSenderId: '239404326768',
    projectId: 'nutripeek-81a9b',
    storageBucket: 'nutripeek-81a9b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCalWduG0DPuNTdlfqjf2Zs7ZW-py9_zew',
    appId: '1:239404326768:ios:3d42390f526642245cb9b5',
    messagingSenderId: '239404326768',
    projectId: 'nutripeek-81a9b',
    storageBucket: 'nutripeek-81a9b.appspot.com',
    iosClientId: '239404326768-cqankbabanmpratk3uu3m6k0dje2vp5v.apps.googleusercontent.com',
    iosBundleId: 'com.nutripeek.soon.nutripeek',
  );
}
