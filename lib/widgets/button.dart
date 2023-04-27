import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final Function()? onTap;
  final String buttonText;

  const Button({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(162, 183, 155, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}


