import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/button/button_widget.dart';
import 'package:share_plus/share_plus.dart';

class ShowProductPage extends StatelessWidget {
  final OrderModel product;
  const ShowProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const bucket =
        "https://fkwjfmvabkxlhmvyiaec.supabase.in/storage/v1/object/public/products/";
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.6,
            backgroundColor: AppTheme.colors.background,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              background: Image.network(
                bucket + product.thumbnail_url!,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, loading) {
                  if (loading == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: AppTheme.colors.primary,
                        value: loading.expectedTotalBytes != null
                            ? loading.cumulativeBytesLoaded /
                                loading.expectedTotalBytes!
                            : null),
                  );
                },
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(45),
              child: Transform.translate(
                offset: Offset(0, 1),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.textEnabled,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: size.height * 0.6,
                color: AppTheme.colors.textEnabled,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name.toUpperCase(),
                              style: AppTheme.textStyles.titleDetails,
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                        Text(
                          "R\$ ${product.price.toStringAsFixed(2)}",
                          style: AppTheme.textStyles.titleDetailsPrice,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppTheme.colors.border.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text.rich(
                        TextSpan(
                          text: "Data de compra: ",
                          style: AppTheme.textStyles.hintBold,
                          children: [
                            TextSpan(
                              text: DateFormat('d/MM/yyyy')
                                  .format(DateTime.parse(product.created_at)),
                              style: AppTheme.textStyles.hint,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Divider(height: 1),
                    const SizedBox(height: 30),
                    Text(
                      product.description!,
                      maxLines: 5,
                      style: AppTheme.textStyles.content,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    const SizedBox(height: 20),
                    FadeInUp(
                      delay: Duration(milliseconds: 380),
                      duration: Duration(milliseconds: 900),
                      child: Button(
                        label: "Compartilhar",
                        type: ButtonType.outline,
                        onTap: () {
                          Share.share(
                              "Confira meu site https://www.airongabriel.com.br");
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
