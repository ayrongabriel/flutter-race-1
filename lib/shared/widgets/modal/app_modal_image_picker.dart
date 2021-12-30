import 'package:flutter/material.dart';

import 'package:meuapp/shared/theme/app_theme.dart';

class AppModalImagePicker extends StatelessWidget {
  final Function() souceGalery;
  final Function() souceCamera;
  const AppModalImagePicker({
    Key? key,
    required this.souceGalery,
    required this.souceCamera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Inserir da galeria"),
            leading: Icon(Icons.image_outlined),
            onTap: () {
              souceGalery();
              Navigator.of(context).pop();
            },
          ),
          Divider(
            height: 2,
            color: AppTheme.colors.primary,
          ),
          ListTile(
            title: Text("Abrir a câmara"),
            leading: Icon(Icons.camera_alt_outlined),
            onTap: () {
              souceCamera();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
