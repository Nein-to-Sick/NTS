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
    apiKey: 'AIzaSyBrHv3izMi5Yvvz0VI-nnAZLhz82M-1O8E',
    appId: '1:92614011032:web:575e55ce1b5ccb405348ed',
    messagingSenderId: '92614011032',
    projectId: 'ntss-4d415',
    authDomain: 'ntss-4d415.firebaseapp.com',
    storageBucket: 'ntss-4d415.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYOmvbpqZ3qkkxtNFez5H1YLoqKyFtLHw',
    appId: '1:92614011032:android:c9602a42d59e48985348ed',
    messagingSenderId: '92614011032',
    projectId: 'ntss-4d415',
    storageBucket: 'ntss-4d415.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCac6P0fgtqojIT2amODxBd43ugJuzMd_8',
    appId: '1:92614011032:ios:7a7c367e1faff3755348ed',
    messagingSenderId: '92614011032',
    projectId: 'ntss-4d415',
    storageBucket: 'ntss-4d415.appspot.com',
    iosClientId: '92614011032-kpa101i670c36c2usftp9qa338svr9ih.apps.googleusercontent.com',
    iosBundleId: 'com.example.nts',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCac6P0fgtqojIT2amODxBd43ugJuzMd_8',
    appId: '1:92614011032:ios:b6a016af66fb4c6e5348ed',
    messagingSenderId: '92614011032',
    projectId: 'ntss-4d415',
    storageBucket: 'ntss-4d415.appspot.com',
    iosClientId: '92614011032-vv73tf1f76g0792nalhphdg180jio51q.apps.googleusercontent.com',
    iosBundleId: 'com.example.nts.RunnerTests',
  );
}