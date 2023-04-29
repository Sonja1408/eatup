import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatup/models/api_response.dart';
import 'package:eatup/pages/recipe_page.dart';
import 'package:eatup/widgets/big_text.dart';
import 'package:eatup/widgets/checkbox.dart';
import 'package:eatup/widgets/icon_and_text.dart';
import 'package:eatup/widgets/middle_text.dart';
import 'package:eatup/widgets/small_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {

  // functions and variables camera
  File? _image;
  final imagePicker = ImagePicker();

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  //functions and variables assignedFood
  late Future<APIResponse> futureResponse;
  final TextEditingController _textController = TextEditingController();
  final List<String> addedFoodList = [];
  final List<String> foodlist = [];

  @override
  void initState() {
    super.initState();
    futureResponse = fetchAlbum();
  }

  Widget buildListView(){
    return ListView.builder(
      itemCount: foodlist.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            foodlist.removeAt(index);
          },
          background: deleteBgItem(),
          child: Card(
            child: ListTile(
              title: Text(foodlist[index]),
            ),
          ),
        );
      },
    );
  }

  void addFood() {
    String newFood = _textController.text.trim();
    if (newFood.isNotEmpty) {
      setState(() {
        foodlist.add(newFood);
        addedFoodList.add(newFood);
        _textController.clear();
        newFood = "";
      });
    }
  }

  Widget deleteBgItem() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.redAccent,
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  removeFood(index) {
    setState(() {
      foodlist.remove(index);
    });
  }

  // functions and variables scan
  // list of food from checkboxes
  List selectedFood = [];
  List fittingRecipes = [];
  List food = [
    ['Paprika', false],
    ['Karotte', false],
    ['Tomate', false],
    ['Milch', false],
    ['Zucker', false],
    ['Kokosmilch', false],
    ['Tomatenmark', false],
    ['Tomaten stückig', false],
    ['Reispapier', false],
    ['Linsen', false],
    ['Kichererbsen', false],
    ['Bohnen', false],
    ['Salz', false],
    ['Pfeffer', false],
    ['Paprika edelsüß', false],
    ['Kreuzkümmel', false],
    ['Kurkuma', false],
    ['Basilikum', false],
    ['Rosmarin', false],
    ['Thymian', false],
    ['Muskatnuss', false],
    ['Curry', false],
    ['Paprika scharf', false],
    ['Oregano', false],
    ['Olivenöl', false],
    ['Rapsöl', false],
    ['Essig hell', false],
    ['Essig dunkel', false],
    ['Sonnenblumenöl', false],
    ['Balsamico', false],
  ];
  // list of food from checkboxes and camera
  List collectedList = [];

  // functions and variables toggle pages
  int choosingItems = 1;
  int cameraPage = 0;
  int assignedFood = 0;
  int recipes = 0;

  @override
  Widget build(BuildContext context) {
    void toggleChoosingItemsBool(String page) {
      setState(() {
        if (page == "checkboxes") {
          choosingItems = 0;
          cameraPage = 1;
        } else if (page == "camera") {
          cameraPage = 0;
          assignedFood = 1;
        } else if (page == "assignedFood"){
          assignedFood = 0;
          recipes = 1;
        }
      });
    }

    for (var i = 0; i < food.length; i++) {
      if (food[i][1] == true) {
        selectedFood.add(food[i][0]);
      }
    }

    Future<void> searchIngredients(List selectedFood) async {
      for (int i = 0; i< selectedFood.length; i++) {
        collectedList.add(selectedFood[i]);
      }
      for (int i = 0; i< foodlist.length; i++) {
        collectedList.add(foodlist[i]);
      }
      final recipesRef = FirebaseFirestore.instance.collection('rezepte');
      final recipesSnapshot = await recipesRef.get();
      for (final doc in recipesSnapshot.docs) {
        final ingredients = Map<String, dynamic>.from(doc.data()['Zutaten']);
        ingredients.forEach((key, value) {
          for (var i = 0; i <= collectedList.length - 1; i++) {
            if (collectedList[i] == key) {
              var recipeName = doc.data()['Name'];
              var existingRecipe = fittingRecipes.firstWhere(
                    (recipe) => recipe[0] == recipeName,
                orElse: () => null,
              );
              if (existingRecipe == null) {
                fittingRecipes.add([
                  recipeName,
                  doc.data()['Zubereitungszeit'],
                  doc.data()['Level'],
                  doc.data()['Bild'],
                  doc.data()['Zutaten'],
                  doc.data()['Zubereitung'],
                ]);
              }
            }
          }
        });
      }
    }

    if (choosingItems == 1) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: MiddleText(text: 'Wähle hier deine Lebensmittel aus der Speisekammer aus:', color: Colors.white),
            backgroundColor: const  Color.fromRGBO(162, 183, 155, 1),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12.0),
                      BigText(text: 'Grundnahrungsmittel'),
                      const SizedBox(height: 12.0),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CheckboxText('Kartoffeln', food),
                                CheckboxText('Mehl', food),
                                CheckboxText('Nudeln', food),
                                CheckboxText('Reis', food),
                                CheckboxText('Zucker', food),
                                CheckboxText('Kokosmilch', food),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CheckboxText('Reispapier', food),
                                CheckboxText('Linsen', food),
                                CheckboxText('Kichererbsen', food),
                                CheckboxText('Bohnen', food),
                                CheckboxText('Tomatenmark', food),
                                CheckboxText('Tomaten stückig', food),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 12.0),
                      BigText(text: 'Gewürze'),
                      const SizedBox(height: 12.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CheckboxText('Salz', food),
                                CheckboxText('Pfeffer', food),
                                CheckboxText('Paprika edelsüß', food),
                                CheckboxText('Kreuzkümmel', food),
                                CheckboxText('Kurkuma', food),
                                CheckboxText('Basilikum', food),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CheckboxText('Muskatnuss', food),
                                CheckboxText('Curry', food),
                                CheckboxText('Paprika scharf', food),
                                CheckboxText('Oregano', food),
                                CheckboxText('Rosmarin', food),
                                CheckboxText('Thymian', food),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 12.0),
                      BigText(text: 'Essig und Öl'),
                      const SizedBox(height: 12.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CheckboxText('Olivenöl', food),
                                CheckboxText('Rapsöl', food),
                                CheckboxText('Essig hell', food),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CheckboxText('Essig dunkel', food),
                                CheckboxText('Sonnenblumenöl', food),
                                CheckboxText('Balsamico', food),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              toggleChoosingItemsBool("checkboxes");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(162, 183, 155, 1),
                              side: BorderSide.none,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                              ),
                              minimumSize: const Size(300, 60),
                            ),
                            child: const Text('Bestätigen und Kühlschrank scannen',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                          const SizedBox(height: 16)
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
          )
      );
    } else if (cameraPage == 1) {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  pickAndUploadImage(context);
                  toggleChoosingItemsBool("camera");
                },
                child: Image.asset(
                    "lib/images/kuehlschrank.jpg", width: 400, height: 400),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  pickAndUploadImage(context);
                  toggleChoosingItemsBool("camera");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(162, 183, 155, 1),
                  side: BorderSide.none,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  minimumSize: const Size(300, 60),
                ),
                child: const Text('Bild auswählen',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      );
    } else if (assignedFood == 1) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: MiddleText(text: 'Füge zu den erkannten Lebensmitteln weitere hinzu:', color: Colors.white),
          backgroundColor: const  Color.fromRGBO(162, 183, 155, 1),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<APIResponse>(
                future: futureResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color.fromRGBO(162, 183, 155, 1)));
                  }
                  if (snapshot.hasData && foodlist.isEmpty) {
                    for (int i =0; i < snapshot.data!.result.length; i++) {
                      var item = snapshot.data!.result[i];
                      if (!foodlist.contains(item)) {
                        foodlist.add(item);
                      }
                    }
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return  buildListView();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Lebensmittel hinzufügen',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(162, 183, 155, 1),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(162, 183, 155, 1),
                  onPressed: () {
                    addFood();
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 8)
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                toggleChoosingItemsBool("assignedFood");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(162, 183, 155, 1),
                side: BorderSide.none,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                minimumSize: const Size(300, 60),
              ),
              child: const Text('Bestätigen',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    }else {
      return SingleChildScrollView(
        child: FutureBuilder(
          future: searchIngredients(selectedFood.toSet().toList()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Column(
              children: [
                // Titel: Passende Rezepte
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BigText(text: 'Passende Rezepte'),
                      const SizedBox(width: 12),
                      SmallText(text: '.'),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                Container(
                  height: 700,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: fittingRecipes.length,
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
                                    image: AssetImage(fittingRecipes[i][3]),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RecipePage(title: fittingRecipes[i][0], time: fittingRecipes[i][1], level: fittingRecipes[i][2], image: fittingRecipes[i][3], ingredients: fittingRecipes[i][4], steps: fittingRecipes[i][5])),
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
                                        BigText(text: fittingRecipes[i][0]),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconAndText(icon: Icons.check_circle, text: fittingRecipes[i][2], color: Colors.black45, iconColor: Colors.lightGreen),
                                            IconAndText(icon: Icons.access_time_rounded, text: fittingRecipes[i][1], color: Colors.black45, iconColor: Colors.redAccent),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RecipePage(title: fittingRecipes[i][0], time: fittingRecipes[i][1], level: fittingRecipes[i][2], image: fittingRecipes[i][3], ingredients: fittingRecipes[i][4], steps: fittingRecipes[i][5])),
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
            );
          },
        ),
      );
    }
  }
}


// functions camera
Future<void> pickAndUploadImage(BuildContext context) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final fileBytes = await pickedFile.readAsBytes();
    const fileName = 'myImage.jpg';

    // create reference
    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('images/$fileName');

    // start upload
    final UploadTask uploadTask =
    firebaseStorageRef.putData(fileBytes, SettableMetadata(contentType: 'image/jpeg'));
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    // print URL to console if image has been uploaaded
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print('image uploaded: $downloadUrl');
  } else {
    print('No image selected.');
  }
}

// functions assignedFood
Future<APIResponse> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://eatup-hy5jt23ota-uc.a.run.app'),
      headers: {
        HttpHeaders.accessControlAllowOriginHeader: "*",
      });
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> jsonMap = json.decode(response.body);
    APIResponse apiResponse = APIResponse.fromJson(jsonMap);
    return apiResponse;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}