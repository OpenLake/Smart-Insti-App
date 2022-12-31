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
    apiKey: 'AIzaSyBkvNXbZ25SJsrOjcd20mpyw6scVJjD-Lc',
    appId: '1:764436491502:web:5e76c8aebc4e39180c57ff',
    messagingSenderId: '764436491502',
    projectId: 'smart-insti-app',
    authDomain: 'smart-insti-app.firebaseapp.com',
    databaseURL: 'https://smart-insti-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-insti-app.appspot.com',
    measurementId: 'G-WCDM8RSKRT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-mNMpkwzi7UMbcIGnL5NWLN1uPRgUtbg',
    appId: '1:764436491502:android:feeff862f602d77b0c57ff',
    messagingSenderId: '764436491502',
    projectId: 'smart-insti-app',
    databaseURL: 'https://smart-insti-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-insti-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5jGJ1oUwbaokvkxwuPnTR0v3yCP63gUA',
    appId: '1:764436491502:ios:d8db05af5ceeddcf0c57ff',
    messagingSenderId: '764436491502',
    projectId: 'smart-insti-app',
    databaseURL: 'https://smart-insti-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-insti-app.appspot.com',
    iosClientId: '764436491502-qv0k2anm5o6shgq6vnjdsr5148a7bgmi.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartInstiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5jGJ1oUwbaokvkxwuPnTR0v3yCP63gUA',
    appId: '1:764436491502:ios:d8db05af5ceeddcf0c57ff',
    messagingSenderId: '764436491502',
    projectId: 'smart-insti-app',
    databaseURL: 'https://smart-insti-app-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'smart-insti-app.appspot.com',
    iosClientId: '764436491502-qv0k2anm5o6shgq6vnjdsr5148a7bgmi.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartInstiApp',
  );
}
