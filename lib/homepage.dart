import 'package:eatup/pages/home_slider.dart';
import 'package:eatup/pages/profile.dart';
import 'package:eatup/pages/scan.dart';
import 'package:eatup/pages/show_recipes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeSlider(),
    const Scan(),
    const ShowRecipes(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/eatup.png',
                fit: BoxFit.contain,
                height: 32,
              ),
            ]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(162, 183, 155, 0.9),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera), label: 'Kamera'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Rezepte'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}