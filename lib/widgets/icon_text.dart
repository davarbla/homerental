import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final Icon icon;
  final String text;

  IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          this.icon,
          SizedBox(width: 5),
          Text(
            "$text",
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
