import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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
    apiKey: 'AIzaSyD7FWJM-fILTQAZNanUE1Q_al3rCxEeQjk',
    appId: '1:1013992985642:web:e1052bdfca97217e0fdf53',
    messagingSenderId: '1013992985642',
    projectId: 'epic-nz-962c4',
    authDomain: 'epic-nz-962c4.firebaseapp.com',
    databaseURL: 'https://epic-nz-962c4-default-rtdb.firebaseio.com',
    storageBucket: 'epic-nz-962c4.firebasestorage.app',
    measurementId: 'G-TTXTLY4CQ0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuFImFFNgEGTZbRHE2YmlSCka4FSrxzTo',
    appId: '1:1013992985642:android:c9d586c1e259525e0fdf53',
    messagingSenderId: '1013992985642',
    projectId: 'epic-nz-962c4',
    databaseURL: 'https://epic-nz-962c4-default-rtdb.firebaseio.com',
    storageBucket: 'epic-nz-962c4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzVphsvP2gGEA_qYQc6YtHdvPt3aIBnqA',
    appId: '1:1013992985642:ios:067587faac8fbc1b0fdf53',
    messagingSenderId: '1013992985642',
    projectId: 'epic-nz-962c4',
    databaseURL: 'https://epic-nz-962c4-default-rtdb.firebaseio.com',
    storageBucket: 'epic-nz-962c4.firebasestorage.app',
    iosClientId:
        '1013992985642-uh5hjivrp0e8m2grffh4jjuan8prku6q.apps.googleusercontent.com',
    iosBundleId: 'com.example.epicNz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzVphsvP2gGEA_qYQc6YtHdvPt3aIBnqA',
    appId: '1:1013992985642:ios:067587faac8fbc1b0fdf53',
    messagingSenderId: '1013992985642',
    projectId: 'epic-nz-962c4',
    databaseURL: 'https://epic-nz-962c4-default-rtdb.firebaseio.com',
    storageBucket: 'epic-nz-962c4.firebasestorage.app',
    iosClientId:
        '1013992985642-uh5hjivrp0e8m2grffh4jjuan8prku6q.apps.googleusercontent.com',
    iosBundleId: 'com.example.epicNz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7FWJM-fILTQAZNanUE1Q_al3rCxEeQjk',
    appId: '1:1013992985642:web:c94ac50927a1dd6a0fdf53',
    messagingSenderId: '1013992985642',
    projectId: 'epic-nz-962c4',
    authDomain: 'epic-nz-962c4.firebaseapp.com',
    databaseURL: 'https://epic-nz-962c4-default-rtdb.firebaseio.com',
    storageBucket: 'epic-nz-962c4.firebasestorage.app',
    measurementId: 'G-88CKV7T9J6',
  );
}
