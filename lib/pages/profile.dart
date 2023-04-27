import 'package:eatup/pages/login.dart';
import 'package:eatup/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  final AuthService _auth = AuthService();
  Profile({Key? key}) : super(key: key);

  // read out the current user
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // avatar image
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100), child: Image.asset('lib/images/Avatar.png'),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Du bist angemeldet mit: "),
            Text(user.email.toString(), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            // show logout list tile
            Profilmenue(
              title: 'Logout',
              icon: Icons.logout,
              textColor: Colors.redAccent,
              onPress: () async{
                await _auth.signOut();
                // open login page after logout
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage(onTap: () {  },)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Profilmenue extends StatelessWidget {
  const Profilmenue({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      onTap: onPress, // execute logout
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(162, 183, 155, 0.1),
        ),
        child: Icon(icon, color: const Color.fromRGBO(162, 183, 155, 0.9)),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor)),
    );
  }
}