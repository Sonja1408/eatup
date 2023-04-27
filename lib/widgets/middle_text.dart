import 'package:flutter/material.dart';

class MiddleText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;

  MiddleText({Key? key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 15,
    this.overFlow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
