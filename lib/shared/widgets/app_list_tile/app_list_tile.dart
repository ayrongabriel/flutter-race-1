import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:meuapp/modules/home/pages/feed/feed_controller.dart';
import 'package:meuapp/modules/product/product_bottomsheet_edit.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/theme/app_theme.dart';

class AppListTile extends StatelessWidget {
  final OrderModel order;
  final UserModel user;
  final FeedController controller;
  const AppListTile({
    Key? key,
    required this.user,
    required this.order,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeModal() async {
      await showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
        context: context,
        builder: (context) => ProductBottomSheetEdit(
          user: user,
          order: order,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Dismissible(
            key: Key(order.id),
            dragStartBehavior: DragStartBehavior.start,
            background: Container(
              decoration: BoxDecoration(
                  color: AppTheme.colors.primary,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit, color: AppTheme.colors.background),
                    Text(' Editar', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            secondaryBackground: Container(
              decoration: BoxDecoration(
                  color: AppTheme.colors.badColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: AppTheme.colors.background),
                    Text('Excluir', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                print("Editar");
              } else {
                print("excluir");
              }

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Deseja desfazer?")));
            },
            confirmDismiss: (direction) async {
              direction == DismissDirection.startToEnd
                  ? onChangeModal()
                  : await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Confirme"),
                          content: direction == DismissDirection.startToEnd
                              ? Text.rich(
                                  TextSpan(
                                      text: "Deseja editar o produto ",
                                      children: [
                                        TextSpan(
                                          text: order.name,
                                          style: AppTheme
                                              .textStyles.buttonBoldTextColor,
                                        )
                                      ]),
                                )
                              : Text.rich(
                                  TextSpan(
                                      text: "Deseja excluir o produto ",
                                      children: [
                                        TextSpan(
                                          text: order.name,
                                          style: AppTheme
                                              .textStyles.buttonBoldTextColor,
                                        )
                                      ]),
                                ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Cancelar".toString()),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppTheme.colors.background),
                                  foregroundColor: MaterialStateProperty.all(
                                      AppTheme.colors.textColor)),
                            ),
                            SizedBox(width: 3),
                            TextButton(
                              onPressed: () {
                                controller.delete(id: order.id);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Deseja desfazer?"),
                                    action: SnackBarAction(
                                      label: "Desfazer",
                                      onPressed: () {
                                        final orderUndo = OrderModel(
                                            id: order.id,
                                            id_user: order.id_user,
                                            name: order.name,
                                            price: order.price,
                                            created_at: order.created_at);
                                        controller.deleteUndo(
                                            id_user: orderUndo.id_user,
                                            name: orderUndo.name,
                                            price: orderUndo.price.toString(),
                                            created_at: orderUndo.created_at);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: direction == DismissDirection.startToEnd
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Editar".toUpperCase()),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Excluir".toUpperCase()),
                                    ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      direction == DismissDirection.startToEnd
                                          ? MaterialStateProperty.all(
                                              AppTheme.colors.primary)
                                          : MaterialStateProperty.all(
                                              AppTheme.colors.badColor),
                                  foregroundColor: MaterialStateProperty.all(
                                      AppTheme.colors.background)),
                            ),
                            SizedBox(width: 3),
                          ],
                        );
                      });
            },
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
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
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}
