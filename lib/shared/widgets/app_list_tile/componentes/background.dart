import 'package:flutter/material.dart';

class AppBackgroundDimissible extends StatelessWidget {
  final Icon icon;
  final String label;
  final Color color;
  final MainAxisAlignment mainAxisAligment;
  const AppBackgroundDimissible({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.mainAxisAligment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: mainAxisAligment,
          children: [
            icon,
            Text(label, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
