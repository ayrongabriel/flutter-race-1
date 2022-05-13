import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meuapp/modules/home/home_page.dart';
import 'package:meuapp/modules/home/pages/feed/feed_page.dart';
import 'package:meuapp/modules/login/login_page.dart';
import 'package:meuapp/modules/login/pages/register/register_page.dart';
import 'package:meuapp/modules/product/pages/show_product_page.dart';
import 'package:meuapp/modules/product/product_bottomsheet_edit.dart';
import 'package:meuapp/modules/profile/profile_page.dart';
import 'package:meuapp/modules/splash/splash_page.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/utils/app_routes.dart';

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
      supportedLocales: [Locale('pt')],
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.loginRegister: (context) => const RegisterPager(),
        AppRoutes.home: (context) => HomePage(
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
        AppRoutes.showProduct: (context) => ShowProductPage(
            product: ModalRoute.of(context)!.settings.arguments as OrderModel),
        AppRoutes.editProduct: (context) => ProductBottomSheetEdit(
              user: ModalRoute.of(context)!.settings.arguments as UserModel,
              order: ModalRoute.of(context)!.settings.arguments as OrderModel,
            ),
      },
    );
  }
}
