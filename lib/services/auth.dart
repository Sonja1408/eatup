import 'package:eatup/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create User Object based on FirebaseUser (User?)
  UserModel? _userFromFirebaseUser(User user) {
    //if user is not null return user
    if (user != null) {
      return UserModel(uid: user.uid);
    } else {
      return null;
    }
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}