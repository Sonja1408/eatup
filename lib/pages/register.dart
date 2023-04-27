import 'package:eatup/homepage.dart';
import 'package:eatup/pages/login.dart';
import 'package:eatup/services/database.dart';
import 'package:eatup/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future userSignUp() async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      User? user1 = result.user;
      _auth.currentUser?.updateDisplayName(firstnameController.toString());
      await DatabaseService(uid: user1?.uid).updateUserData(firstnameController.text, lastnameController.text, emailController.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const HomePage()));
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid);
      await userDocRef.update({
        'savedRecipes': [] // an empty list to start with
      });
      return result.user;
    }catch(e){
      print(e.toString());
      showErrorMessage("Passwort zu kurz (mind. 6 Zeichen) oder E-Mail ungültig.");
      return null;
    }
  }

  //error message to user
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            title: Center(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // icon lock section
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
                const SizedBox(height: 50),
                //heading section
                const Text(
                  'Jetzt registrieren!',
                  style: TextStyle(color: Colors.black38, fontSize: 16),
                ),
                const SizedBox(height: 25),
                // first name field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: firstnameController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: 'Vorname',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // last name field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: lastnameController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: 'Nachname',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // email field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: 'E-Mail',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // password field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: 'Passwort',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // confirm password field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: 'Passwort bestätigen',
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // sign up button
                Button(
                  buttonText: 'Registrieren',
                  onTap: userSignUp,
                ),
                const SizedBox(height: 50),
                // "Hast du bereits ein Konto?" section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Hast du bereits ein Konto?'),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // "Logge dich jetzt ein" section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage(onTap: () {  },)));
                      },
                      child: const Text(
                        'Logge dich jetzt ein',
                        style: TextStyle(
                          color: Color.fromRGBO(162, 183, 155, 1), fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}