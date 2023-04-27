import 'package:eatup/widgets/app_icon.dart';
import 'package:eatup/widgets/big_text.dart';
import 'package:eatup/widgets/home_text.dart';
import 'package:eatup/widgets/like_button.dart';
import 'package:eatup/widgets/recipe_column.dart';
import 'package:eatup/widgets/small_text.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  final String title;
  final String time;
  final String level;
  final String image;
  final Map ingredients;
  final String steps;

  RecipePage({Key? key,
    required this.title,
    required this.time,
    required this.level,
    required this.image,
    required this.ingredients,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List ingredientsTolist = [];
    ingredients.forEach((key, value) {
      ingredientsTolist.add(value + ' ' + key);
    });
    return Scaffold(
      body: Stack(
        children: [
          // background image
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      image,
                    ),
                  ),
                ),
              )),
          // icon to go back on the top widgets
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const AppIcon(icon: Icons.arrow_back_ios),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                LikeButton(title: title),
              ],
            ),
          ),
          // description, level, time, ingredients and steps section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 350 - 20,
            //Dimensions.recipepageImgSize
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecipeColumn(title: title, level: level, time: time),
                      const SizedBox(height: 20),
                      // ingredients section
                      BigText(text: 'Zutaten'),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (String ingredient in ingredientsTolist)
                            SmallText(text: ingredient),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // steps section
                      BigText(text: 'Zubereitung'),
                      const SizedBox(height: 4),
                      Container(
                        width: double.maxFinite,
                        child: HomeText(
                          text: steps,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}