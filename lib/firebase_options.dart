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
    apiKey: 'AIzaSyD2JEbNX8lEZ-qDbVOhn5vq9-nCUMQka-8',
    appId: '1:542340777204:web:4501831daed3aeaed98aa1',
    messagingSenderId: '542340777204',
    projectId: 'iggys-point-ba1c9',
    authDomain: 'iggys-point-ba1c9.firebaseapp.com',
    storageBucket: 'iggys-point-ba1c9.firebasestorage.app',
    measurementId: 'G-HK5FPFLHM5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWUuqK-hh330AXefacu27VWeTebb07pm8',
    appId: '1:542340777204:android:dbd21fb1e94c5a45d98aa1',
    messagingSenderId: '542340777204',
    projectId: 'iggys-point-ba1c9',
    storageBucket: 'iggys-point-ba1c9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgXLxurNS3rVhnn_3TClhJKRnZo5iAUT0',
    appId: '1:542340777204:ios:3ca2dc8fd0283e71d98aa1',
    messagingSenderId: '542340777204',
    projectId: 'iggys-point-ba1c9',
    storageBucket: 'iggys-point-ba1c9.firebasestorage.app',
    iosBundleId: 'com.soogil.iggys.point',
  );

}