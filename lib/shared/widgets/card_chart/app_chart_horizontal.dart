import 'package:flutter/material.dart';
import 'package:meuapp/shared/theme/app_theme.dart';

class AppChartHorizontal extends StatelessWidget {
  final double percent;
  const AppChartHorizontal({
    Key? key,
    required this.percent,
  }) : super(key: key);

  mainAxisAlignment(double value) {
    if (value == 0 || value == 1) return MainAxisAlignment.center;
    return MainAxisAlignment.spaceBetween;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 30,
      width: width,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            AppTheme.colors.badColor,
            AppTheme.colors.primary,
          ], stops: [
            percent,
            0
          ])),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: mainAxisAlignment(percent),
          children: [
            if (percent > 0 && percent <= 1)
              Text(
                "${(percent * 100).ceil()}%",
                style: AppTheme.textStyles.buttonBackgroundColor,
              ),
            if ((1 - percent) > 0)
              Text(
                "${((1 - percent) * 100).ceil()}%",
                style: AppTheme.textStyles.buttonBackgroundColor,
              ),
          ],
        ),
      ),
    );
  }
}
