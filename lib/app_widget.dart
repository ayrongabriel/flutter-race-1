import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meuapp/modules/home/home_page.dart';
import 'package:meuapp/modules/home/pages/feed/feed_page.dart';
import 'package:meuapp/modules/login/login_page.dart';
import 'package:meuapp/modules/login/pages/register/register_page.dart';
import 'package:meuapp/modules/login/profile/profile_page.dart';
import 'package:meuapp/modules/splash/splash_page.dart';
import 'package:meuapp/shared/models/user_model.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Race #1",
      theme: ThemeData(primarySwatch: Colors.green),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('pt'),
      ],
      initialRoute: "/splash",
      routes: {
        // "/splash": (context) => const TestData(),
        "/splash": (context) => const SplashPage(),
        "/login": (context) => const LoginPage(),
        "/login/register": (context) => const RegisterPager(),
        "/home": (context) => HomePage(
              pages: [
                FeedPage(
                    user: ModalRoute.of(context)!.settings.arguments
                        as UserModel),
                ProfilePage(
                  user: ModalRoute.of(context)!.settings.arguments as UserModel,
                ),
              ],
              user: ModalRoute.of(context)!.settings.arguments as UserModel,
            ),
      },
    );
  }
}
