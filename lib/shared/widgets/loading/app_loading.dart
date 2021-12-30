import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    Key? key,
    this.height = 15,
    this.width = 15,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("carregando..."),
          ),
        ],
      ),
    );
  }
}
