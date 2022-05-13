import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    Key? key,
    this.height = 50,
    this.width = 50,
    required this.message,
  }) : super(key: key);

  final double? height;
  final double? width;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(message),
          ),
        ],
      ),
    );
  }
}
