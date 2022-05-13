import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:meuapp/modules/home/pages/feed/feed_controller.dart';
import 'package:meuapp/modules/home/pages/feed/repository/feed_repository_impl.dart';
import 'package:meuapp/modules/home/pages/feed/thumbnail_controller.dart';
import 'package:meuapp/modules/product/product_bottomsheet_edit.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/utils/app_routes.dart';
import 'package:meuapp/shared/widgets/app_list_tile/componentes/background.dart';
import 'package:meuapp/shared/widgets/loading/app_loading.dart';

class AppListTile extends StatefulWidget {
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
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  late final ThumbnailController controllerThumbnail;
  @override
  void initState() {
    controllerThumbnail = ThumbnailController(
        repository: FeedRepositoryImpl(database: AppDatabase.instance));

    setState(() {
      controllerThumbnail.thumbnailUrl(thumbName: widget.order.thumbnail_url!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onChangeModal() async {
      await showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (context) => ProductBottomSheetEdit(
          user: widget.user,
          order: widget.order,
        ),
      );
      // Navigator.of(context)
      //     .pushReplacementNamed(AppRoutes.home, arguments: user);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Column(
        children: [
          Dismissible(
            key: Key(widget.order.id),
            dragStartBehavior: DragStartBehavior.start,
            background: AppBackgroundDimissible(
              icon: Icon(Icons.edit, color: AppTheme.colors.background),
              label: ' Editar',
              color: AppTheme.colors.primary,
              mainAxisAligment: MainAxisAlignment.start,
            ),
            secondaryBackground: AppBackgroundDimissible(
              icon: Icon(Icons.delete, color: AppTheme.colors.background),
              label: 'Excluir',
              color: AppTheme.colors.badColor,
              mainAxisAligment: MainAxisAlignment.end,
            ),
            onDismissed: (direction) {
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
                                          text: widget.order.name,
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
                                          text: widget.order.name,
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
                                widget.controller.delete(
                                    id: widget.order.id,
                                    thumbnail: widget.order.thumbnail_url!);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Deseja desfazer?"),
                                    action: SnackBarAction(
                                      label: "Desfazer",
                                      onPressed: () {
                                        final orderUndo = OrderModel(
                                            id: widget.order.id,
                                            id_user: widget.order.id_user,
                                            name: widget.order.name,
                                            price: widget.order.price,
                                            thumbnail_url:
                                                widget.order.thumbnail_url,
                                            created_at:
                                                widget.order.created_at);
                                        widget.controller.deleteUndo(
                                          id_user: orderUndo.id_user,
                                          name: orderUndo.name,
                                          price: orderUndo.price.toString(),
                                          thumbnail_url:
                                              orderUndo.thumbnail_url,
                                          created_at: orderUndo.created_at,
                                        );
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
            child: InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.showProduct, arguments: widget.order),
              child: Container(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: AppTheme.colors.textEnabled,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: AnimatedBuilder(
                          animation: controllerThumbnail,
                          builder: (_, __) => controllerThumbnail.state.when(
                            loading: () => AppLoading(
                              height: 120,
                              width: 120,
                              message: "carregando...",
                            ),
                            success: (value) => Image.network(value,
                                fit: BoxFit.cover, loadingBuilder:
                                    (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  // backgroundColor: AppTheme.colors.primary,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }),
                            error: (message, e) => Container(
                              color: Colors.red,
                            ),
                            orElse: () {},
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.order.name).label,
                          SizedBox(
                            height: 5,
                          ),
                          Text("R\$ ${widget.order.price.toStringAsFixed(2)}"),
                          SizedBox(height: 10),
                          Text(
                            widget.order.updated_at != null
                                ? DateFormat("dd/MM/y")
                                    .format(DateTime.parse(
                                        widget.order.updated_at!))
                                    .toString()
                                : DateFormat("dd/MM/y")
                                    .format(
                                        DateTime.parse(widget.order.created_at))
                                    .toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
