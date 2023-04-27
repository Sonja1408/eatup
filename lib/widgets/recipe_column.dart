import 'package:eatup/widgets/big_text.dart';
import 'package:eatup/widgets/icon_and_text.dart';
import 'package:flutter/material.dart';

class RecipeColumn extends StatelessWidget {
  final String title;
  final String time;
  final String level;
  const RecipeColumn({Key? key,
    required this.title,
    required this.time,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: title),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconAndText(icon: Icons.check_circle, text: level, color: Colors.black45, iconColor: Colors.lightGreen),
            const SizedBox(width: 40),
            IconAndText(icon: Icons.access_time_rounded, text: time, color: Colors.black45, iconColor: Colors.redAccent),
          ],
        ),
      ],
    );
  }
}