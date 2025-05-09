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
    apiKey: 'AIzaSyCVTE4mOjpwNlyXLpgKtT6YiKJCJhexHgQ',
    appId: '1:34278195385:web:023c08e8400e63249d5b68',
    messagingSenderId: '34278195385',
    projectId: 'learnpro-ea360',
    authDomain: 'learnpro-ea360.firebaseapp.com',
    storageBucket: 'learnpro-ea360.appspot.com',
    measurementId: 'G-XXDS9EFB3H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOFmETO8vDKof2nf43mPbfqesdpb1Z3WM',
    appId: '1:34278195385:android:1f8e3e0bb8dd0fd69d5b68',
    messagingSenderId: '34278195385',
    projectId: 'learnpro-ea360',
    storageBucket: 'learnpro-ea360.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXvSTItdeuzbEAFImm4t5G0vMahe6rwK0',
    appId: '1:34278195385:ios:555f66a28e1427ae9d5b68',
    messagingSenderId: '34278195385',
    projectId: 'learnpro-ea360',
    storageBucket: 'learnpro-ea360.appspot.com',
    iosBundleId: 'com.example.basic',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXvSTItdeuzbEAFImm4t5G0vMahe6rwK0',
    appId: '1:34278195385:ios:c94423fdc65c3b079d5b68',
    messagingSenderId: '34278195385',
    projectId: 'learnpro-ea360',
    storageBucket: 'learnpro-ea360.appspot.com',
    iosBundleId: 'com.example.basic.RunnerTests',
  );


}
