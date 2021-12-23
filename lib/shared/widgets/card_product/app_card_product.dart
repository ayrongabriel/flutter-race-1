import 'package:flutter/material.dart';
import 'package:meuapp/shared/models/product_model.dart';
import 'package:meuapp/shared/theme/app_theme.dart';

class AppCardProduct extends StatelessWidget {
  final ProductModel product;

  const AppCardProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 232,
      child: Card(
          elevation: 0,
          margin: EdgeInsets.only(left: 25),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  product.name,
                  style: AppTheme.textStyles.cardTitleProduct,
                ),
                subtitle: Text(
                  "Estava R\$ ${product.last_price}",
                  style: AppTheme.textStyles.cardSubTitleProduct,
                ),
                leading: CircleAvatar(
                  radius: 30,
                  child: product.current_price < product.last_price
                      ? Icon(
                          Icons.thumb_up,
                          color: AppTheme.colors.primary,
                        )
                      : Icon(
                          Icons.thumb_down,
                          color: Colors.red,
                        ),
                  backgroundColor: AppTheme.colors.background,
                ),
              ),
              Text.rich(
                TextSpan(text: "Agora\n", children: [
                  TextSpan(
                      text: "R\$ ${product.current_price}",
                      style: AppTheme.textStyles.cardTitleValueProduct),
                ]),
              )
            ],
          )),
    );
  }
}
