import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatup/pages/recipe_page.dart';
import 'package:eatup/widgets/big_text.dart';
import 'package:eatup/widgets/icon_and_text.dart';
import 'package:eatup/widgets/middle_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final user = FirebaseAuth.instance.currentUser;

class ShowRecipes extends StatefulWidget {
  const ShowRecipes({ super.key });
  @override
  State<ShowRecipes> createState() => _ShowRecipesState();
}

class _ShowRecipesState extends State<ShowRecipes> with SingleTickerProviderStateMixin {

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Alle Rezepte'),
    Tab(text: 'Gespeicherte Rezepte'),
  ];

  late TabController _tabController;

  List recipes = [];
  List<String> savedrecipesString = [];
  List savedrecipes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    getAllRecipes();
  }


  Future<void> getAllRecipes() async {
    final recipesRef = FirebaseFirestore.instance.collection('rezepte');
    final recipesSnapshot = await recipesRef.get();
    for (final doc in recipesSnapshot.docs) {
      List infosRecipe= [];
      infosRecipe.add(doc.data()['Name']);
      infosRecipe.add(doc.data()['Zubereitungszeit']);
      infosRecipe.add(doc.data()['Level']);
      infosRecipe.add(doc.data()['Bild']);
      infosRecipe.add(doc.data()['Zutaten']);
      infosRecipe.add(doc.data()['Zubereitung']);
      recipes.add(infosRecipe);
    }
    setState(() { });

    final savedrecipesRef = FirebaseFirestore.instance.collection('users').doc(user?.uid).get().then((docSnapshot) {
      savedrecipesString = List<String>.from(docSnapshot.data()?['savedRecipes'] ?? []);
    });
    await savedrecipesRef;
    for (int i = 0; i < recipes.length; i++) {
      for (int j = 0; j < savedrecipesString.length; j++) {
        if (recipes[i][0] == savedrecipesString[j]) {
          savedrecipes.add(recipes[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MiddleText(text: 'Lasse dir deine Rezepte anzeigen', color: Colors.white),
        backgroundColor: const  Color.fromRGBO(162, 183, 155, 1),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String label = tab.text!.toLowerCase();
          if (label == "alle rezepte") {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: 700,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipes.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                          child: Row(
                            children: [
                              //image section
                              InkWell(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(recipes[i][3]),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RecipePage(title: recipes[i][0], time: recipes[i][1], level: recipes[i][2], image: recipes[i][3], ingredients: recipes[i][4], steps: recipes[i][5])),
                                  );
                                },
                              ),
                              // text section
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          BigText(text: recipes[i][0]),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconAndText(icon: Icons.check_circle, text: recipes[i][2], color: Colors.black45, iconColor: Colors.lightGreen),
                                              IconAndText(icon: Icons.access_time_rounded, text: recipes[i][1], color: Colors.black45, iconColor: Colors.redAccent),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RecipePage(title: recipes[i][0], time: recipes[i][1], level: recipes[i][2], image: recipes[i][3], ingredients: recipes[i][4], steps: recipes[i][5])),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: 700,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: savedrecipes.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                          child: Row(
                            children: [
                              //image section
                              InkWell(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(savedrecipes[i][3]),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RecipePage(title: savedrecipes[i][0], time: savedrecipes[i][1], level: savedrecipes[i][2], image: savedrecipes[i][3], ingredients: savedrecipes[i][4], steps: savedrecipes[i][5])),
                                  );
                                },
                              ),
                              // text section
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          BigText(text: savedrecipes[i][0]),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconAndText(icon: Icons.check_circle, text: savedrecipes[i][2], color: Colors.black45, iconColor: Colors.lightGreen),
                                              IconAndText(icon: Icons.access_time_rounded, text: savedrecipes[i][1], color: Colors.black45, iconColor: Colors.redAccent),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RecipePage(title: savedrecipes[i][0], time: savedrecipes[i][1], level: savedrecipes[i][2], image: savedrecipes[i][3], ingredients: savedrecipes[i][4], steps: savedrecipes[i][5])),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}