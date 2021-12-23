import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meuapp/shared/models/order_model.dart';

import 'package:meuapp/shared/theme/app_theme.dart';

class AppListTile extends StatelessWidget {
  final OrderModel order;
  AppListTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 0, right: 25, bottom: 18, left: 25),
      child: ListTile(
        title: Text(
          order.name,
        ).label,
        subtitle: Text("R\$ ${order.price.toStringAsFixed(2)}"),
        leading: CircleAvatar(
          radius: 30,
          child: Text(
            DateFormat("dd/MM")
                .format(DateTime.parse(order.created_at))
                .toString(),
            style: AppTheme.textStyles.buttonBoldTextColor,
          ),
          backgroundColor: AppTheme.colors.background,
        ),
        trailing: PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Text(" Editar"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        Text(" Excluir"),
                      ],
                    ),
                  ),
                ]),
      ),
    );
  }
}
