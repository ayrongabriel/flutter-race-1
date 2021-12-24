import 'package:flutter/material.dart';

import 'package:meuapp/modules/home/pages/feed/feed_controller.dart';
import 'package:meuapp/modules/home/pages/feed/repository/feed_repository_impl.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/app_list_tile/app_list_tile.dart';
import 'package:meuapp/shared/widgets/card_chart/app_card_chart.dart';
import 'package:meuapp/shared/widgets/card_product/app_card_product.dart';

class FeedPage extends StatefulWidget {
  final UserModel user;
  const FeedPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final FeedController controller;

  @override
  void initState() {
    controller = FeedController(
        repository: FeedRepositoryImpl(database: AppDatabase.instance),
        user: widget.user);
    // controller.all();
    controller.allByUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      top: true,
      bottom: false,
      child: SingleChildScrollView(
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) => controller.state.when(
            loading: () => Container(
              height: height - 76,
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
            ),
            success: (value) {
              final orders = value as List<OrderModel>;
              final products = controller.products;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  AppCardChart(
                    value: controller.sum,
                    percent: controller.calcChart(products),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, right: 25, bottom: 14, left: 25),
                    child: Text("Preço dos produtos",
                        style: AppTheme.textStyles.titleHome),
                  ),
                  SizedBox(
                    height: 126,
                    width: width,
                    child: ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => AppCardProduct(
                        product: products[index],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, right: 25, bottom: 14, left: 25),
                    child: Text("Suas últimas compras",
                        style: AppTheme.textStyles.titleHome),
                  ),
                  for (var order in orders)
                    AppListTile(
                      controller: controller,
                      order: order,
                      user: widget.user,
                    ),
                ],
              );
            },
            error: (message, e) => Container(
              child: Center(
                child: Text(message),
              ),
            ),
            orElse: () => Container(),
          ),
        ),
      ),
    );
  }
}
