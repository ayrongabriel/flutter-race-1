import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/button/button_widget.dart';
import 'package:meuapp/shared/widgets/divider/app_divider_horizontal.dart';
import 'package:meuapp/shared/widgets/input_text/input_text.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  TextEditingController _textEditingController = TextEditingController();

  Future _imagePicker({required ImageSource source, int? quality}) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: quality);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this._image = imageTemp;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future _showModalImagePicker() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Inserir da galeria"),
                  leading: Icon(Icons.image_outlined),
                  onTap: () {
                    _imagePicker(source: ImageSource.gallery);
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
                    _imagePicker(source: ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future _showModalEdit() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.only(
                  right: 25,
                  top: 25,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputText(
                    controller: _textEditingController,
                    label: "Alterar o nome",
                    hint: widget.user.name,
                  ),
                  SizedBox(height: 28),
                  Button(
                    label: "Alterar",
                    onTap: () {
                      // controller.create();
                      print("Clicou em alterar nome de exibição");
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(height: 28),
                ],
              ),
            ));
  }

  @override
  void initState() {
    _textEditingController.text = widget.user.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Perfil",
                style: AppTheme.textStyles.title,
              ),
              SizedBox(height: 50),
              Center(
                child: Container(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      _showModalImagePicker();
                    },
                    child: Stack(
                      children: [
                        ClipOval(
                          child: _image == null
                              ? Container(
                                  color: AppTheme.colors.textEnabled,
                                  height: 120,
                                  width: 120,
                                  child: Center(child: Text("Foto")),
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: 120,
                                ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: ClipOval(
                            child: Container(
                              height: 40,
                              width: 40,
                              color: AppTheme.colors.primary,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: AppTheme.colors.textEnabled,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text("Nome:"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${widget.user.name}"),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios_rounded, size: 15),
                  ],
                ),
                onTap: _showModalEdit,
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text("Email: "),
                trailing: Text("${widget.user.email}"),
              ),
              AppDividerHorizontal(height: 1, padding: 15),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.colors.textEnabled,
                    // border: Border.fromBorderSide(
                    //     BorderSide(color: AppTheme.colors.primary)),
                  ),
                  child: Center(
                    child: Text(
                      "Sair do app",
                      style: AppTheme.textStyles.buttonBoldTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
