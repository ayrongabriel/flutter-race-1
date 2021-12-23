import 'package:flutter/material.dart';

class AppDividerHorizontal extends StatelessWidget {
  final double height;
  final double padding;
  const AppDividerHorizontal({
    Key? key,
    required this.height,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Divider(height: height),
    );
  }
}
