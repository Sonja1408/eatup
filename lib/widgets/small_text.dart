import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;

  SmallText({Key? key,
    this.color = Colors.black45,
    required this.text,
    this.size = 16,
    this.height = 1.6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
