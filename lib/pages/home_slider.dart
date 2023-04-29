import 'package:eatup/widgets/big_text.dart';
import 'package:eatup/widgets/home_text.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class HomeSlider extends StatefulWidget {
  const HomeSlider({Key? key}) : super(key: key);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider>{
  List images = [
    "lib/images/homepage-three.png",
    "lib/images/homepage-two.png",
    "lib/images/homepage-one.png",
  ];

  List title = [
    'EatUp',
    'News',
    'Lebensmittelverschwendung',
  ];

  List heading1 = [
    'Rette deine Lebensmittel',
    'Lagerung und Haltbarkeit',
    'Überschrittenes MHD',
  ];

  List text = [
    'EatUp hilft dir dabei, deine übrig gebliebenen Lebensmittel zu verwerten und passende leckere Rezpte zum Kochen zu finden.',
    'Die Lagerung hat großen Einfluss auf die Haltbarkeit von Lebensmitteln. Kartoffeln und Zwiebeln beispielsweise haben es gerne dunkel und nicht zu kalt. Auch Tomaten und Zitrusfrüchte sind kälteempfindlich. Frischwaren wie Salat, Spinat und Milchprodukte gehören den Kühlschrank.',
    'Lebensmittel, die das Mindesthaltbarkeitsdatum (MHD) überschritten haben, werfen wir oft als „abgelaufen“ in den Müll – eine völlig grundlose Lebensmittelverschwendung. Nicht umsonst steht da „Mindestens haltbar bis“. Oft kann man die Waren mehrere Tage bis Wochen über das MHD hinaus problemlos verzehren.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (_, index){
          //show image in background
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    images[index],
                  ),
                  fit: BoxFit.cover,
                )
            ),
            // show text (title, heading and text)
            child: Container(
              margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(text: title[index], size: 30),
                      const SizedBox(height: 2),
                      Container(
                        width: 250,
                        child: HomeText(text: heading1[index], size: 20),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 250,
                        child: HomeText(
                          text: text[index],
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  // show List (dots on the right)
                  Column(
                    children:
                    List.generate(3, (indexDots) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        width: 8,
                        height: index == indexDots?25:8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromRGBO(162, 183, 155, 1),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}