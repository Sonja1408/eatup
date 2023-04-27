import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser;

class LikeButton extends StatefulWidget {
  final String title;

  LikeButton({Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLikedButtonClicked = false;
  List<String> savedrecipes = [];

  @override
  void initState() {
    super.initState();
    // Firestore-Dokument abrufen und prüfen, ob das aktuelle Rezept gespeichert ist
    FirebaseFirestore.instance.collection('users').doc(user?.uid).get().then((docSnapshot) {
      setState(() {
        savedrecipes = List<String>.from(docSnapshot.data()?['savedRecipes'] ?? []);
        _isLikedButtonClicked = savedrecipes.contains(widget.title);
      });
    }).catchError((error) {
      print('Fehler beim Lesen von savedRecipes: $error');
    });
  }


  Widget build(BuildContext context) {
    final userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
    print(user?.email);
    /*userRef.set({
      "savedRecipes": []
    }, SetOptions(merge: true));*/


    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: IconButton(
          icon: _isLikedButtonClicked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          color: _isLikedButtonClicked ? Colors.redAccent: Colors.black,
          onPressed: (){
            setState((){
              _isLikedButtonClicked = !_isLikedButtonClicked;
              //print(widget.savedrecipes.toString());

              if (_isLikedButtonClicked == false) {
                savedrecipes.remove(widget.title);
                userRef.update({
                  'savedRecipes': FieldValue.arrayRemove([widget.title]),
                });setState(() {});
                //print(widget.savedrecipes.toString());
              } else {
                savedrecipes.add(widget.title);
                userRef.update({
                  'savedRecipes': FieldValue.arrayUnion(savedrecipes),
                });
                //print(widget.savedrecipes.toString());
              }
              //print(savedrecipes);

              // Firestore-Dokument abrufen und "savedRecipes" Feldwert lesen
              userRef.get().then((docSnapshot) {
                setState((){
                  print(List<String>.from(docSnapshot.data()!['savedRecipes'] ?? []));
                  print("lokal:");
                  print(savedrecipes);});
              }).catchError((error) {
                print('Fehler beim Lesen von savedRecipes: $error');
              });
            });//setstate
          } //onpressed
      ),
    );
  }
}