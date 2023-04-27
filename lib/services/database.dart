import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final db = FirebaseFirestore.instance;
  final String? uid;
  DatabaseService({ this.uid});

  //collection reference
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName, String mail) async {
    return await users.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': mail,
    });
  }

  //get user streams
  Stream<QuerySnapshot> get userStream {
    return users.snapshots();
  }
}