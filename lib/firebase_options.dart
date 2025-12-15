import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
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

  static FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArghi0zVSaB7upidAGAc9rjfbd4KMhFUU',
    appId: '1:748393946180:android:b9e1424519e2a758287011',
    messagingSenderId: '748393946180',
    projectId: 'final-project-b4430',
    storageBucket: 'final-project-b4430.firebasestorage.app',
  );

  // TODO: Replace the placeholder values with the actual Windows config from Firebase.
  static FirebaseOptions windows = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WINDOWS_API_KEY',
    appId: 'REPLACE_WITH_WINDOWS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_WINDOWS_MESSAGING_SENDER_ID',
    projectId: 'final-project-b4430',
    storageBucket: 'final-project-b4430.appspot.com',
  );
}