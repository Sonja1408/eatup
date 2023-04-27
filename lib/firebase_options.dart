import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCK3HjMCKMcgQj8OvRvqXC-ARz-Jlwu_DA',
    appId: '1:201693563782:web:784b2fb523c6fc51e37a07',
    messagingSenderId: '201693563782',
    projectId: 'fridge-ae5f2',
    authDomain: 'fridge-ae5f2.firebaseapp.com',
    storageBucket: 'fridge-ae5f2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBN-FTmsDc-y6sXO5Ic7Wp1XwjkxxvxelU',
    appId: '1:201693563782:android:ed55a579332f5294e37a07',
    messagingSenderId: '201693563782',
    projectId: 'fridge-ae5f2',
    storageBucket: 'fridge-ae5f2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD49qv045cSJg2uCirY3E4G6zvev6T1q2k',
    appId: '1:201693563782:ios:f7cc15cdb32da517e37a07',
    messagingSenderId: '201693563782',
    projectId: 'fridge-ae5f2',
    storageBucket: 'fridge-ae5f2.appspot.com',
    iosClientId: '201693563782-e63c8agc24v826bgtsgst9t17ajkikt3.apps.googleusercontent.com',
    iosBundleId: 'com.wastenomore.wastenomore',
  );
}