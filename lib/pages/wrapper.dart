import 'package:provider/provider.dart';
import 'package:eatup/homepage.dart';
import 'package:eatup/models/user_model.dart';
import 'package:eatup/pages/login.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel?>(context);

    //return either home of authenticate widget
    if (user == null) {
      return LoginPage(onTap: () {  },);
    } else {
      return const HomePage();
    }
  }
}