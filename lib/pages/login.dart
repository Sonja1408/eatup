import 'package:eatup/homepage.dart';
import 'package:eatup/pages/register.dart';
import 'package:eatup/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // function to log in a user
  void loginUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the loading circle
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const HomePage()));
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error message
      showErrorMessage("Falsches Passwort oder ungültige E-Mail");
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
                  color: Colors.white,
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
                // icon lock
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                //heading
                const Text(
                  'Jetzt anmelden',
                  style: TextStyle(color: Colors.black38, fontSize: 16),
                ),
                const SizedBox(height: 25),
                // email field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
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
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: 'Passwort',
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                // sign in button
                Button(
                  buttonText: 'Einloggen',
                  onTap: loginUser,
                ),
                const SizedBox(height: 50),
                // "Noch nicht registriert?" section
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
                        child: Text('Noch nicht registriert?'),
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
                // "Melde dich jetzt an" section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  RegisterPage(onTap: () {  },)));
                      },
                      child: const Text(
                        'Registriere dich',
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
