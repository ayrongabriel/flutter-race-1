import 'package:flutter/material.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:animate_do/animate_do.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacementNamed(context, "/login");
    });

    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      body: Center(
        child: FadeInUp(
          delay: Duration(milliseconds: 800),
          duration: Duration(milliseconds: 1500),
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
