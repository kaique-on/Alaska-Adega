// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBGhSy4rKhz3TOrBbFQntgCDyt7yVr4HtM',
    appId: '1:666897230277:web:32ae14bad87969495743ac',
    messagingSenderId: '666897230277',
    projectId: 'alaska-adega',
    authDomain: 'alaska-adega.firebaseapp.com',
    storageBucket: 'alaska-adega.appspot.com',
    measurementId: 'G-PKS4G0HVYW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBi6_Isa9Ue8ZAKYTSHvaR_ZqqIfo5poqQ',
    appId: '1:666897230277:android:89bf2722f6492fe65743ac',
    messagingSenderId: '666897230277',
    projectId: 'alaska-adega',
    storageBucket: 'alaska-adega.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDq8CDu-WCEjOiUH0PhznBWNIgtjrmYSng',
    appId: '1:666897230277:ios:8b97ce89f91a585c5743ac',
    messagingSenderId: '666897230277',
    projectId: 'alaska-adega',
    storageBucket: 'alaska-adega.appspot.com',
    iosBundleId: 'com.example.alaskaEstoque',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDq8CDu-WCEjOiUH0PhznBWNIgtjrmYSng',
    appId: '1:666897230277:ios:8b97ce89f91a585c5743ac',
    messagingSenderId: '666897230277',
    projectId: 'alaska-adega',
    storageBucket: 'alaska-adega.appspot.com',
    iosBundleId: 'com.example.alaskaEstoque',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBGhSy4rKhz3TOrBbFQntgCDyt7yVr4HtM',
    appId: '1:666897230277:web:89a760f2f3b43e1d5743ac',
    messagingSenderId: '666897230277',
    projectId: 'alaska-adega',
    authDomain: 'alaska-adega.firebaseapp.com',
    storageBucket: 'alaska-adega.appspot.com',
    measurementId: 'G-V2JYFD9J1S',
  );
}
