import 'package:flutter/material.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/card_chart/app_chart_horizontal.dart';

class AppCardChart extends StatelessWidget {
  final double value;
  final double percent;
  const AppCardChart({
    Key? key,
    required this.value,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 208,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppTheme.colors.textEnabled,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gasto mensal",
                style: AppTheme.textStyles.titleHome,
              ),
              SizedBox(height: 18),
              Text.rich(TextSpan(
                  text: "R\$ ",
                  style: AppTheme.textStyles.cardSubTitleValueChart,
                  children: [
                    TextSpan(
                        text: value.toStringAsFixed(2).replaceAll(".", ","),
                        style: AppTheme.textStyles.cardTitleValueChart),
                  ])),
              SizedBox(height: 10),
              AppChartHorizontal(
                percent: percent,
              ),
              SizedBox(height: 5),
              Center(
                  child: Text(
                "Relacao de compras caras e boas compras",
                style: AppTheme.textStyles.cardHintChart,
              )),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: AppTheme.colors.badColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Pagou Caro".toUpperCase(),
                        style: AppTheme.textStyles.cardInputChart,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: AppTheme.colors.primary,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Boas compras".toUpperCase(),
                        style: AppTheme.textStyles.cardInputChart,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
