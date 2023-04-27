import 'package:eatup/firebase_options.dart';
import 'package:eatup/models/user_model.dart';
import 'package:eatup/pages/wrapper.dart';
import 'package:eatup/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
      catchError: (_, __) => null,
    );
  }}
