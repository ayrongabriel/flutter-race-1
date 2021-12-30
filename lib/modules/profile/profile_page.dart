import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meuapp/modules/profile/profileAvatar_controller.dart';
import 'package:meuapp/modules/profile/profile_controller.dart';
import 'package:meuapp/modules/profile/repository/profile_repository_impl.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/divider/app_divider_horizontal.dart';
import 'package:meuapp/shared/utils/constants_error.dart';
import 'package:meuapp/shared/widgets/loading/app_loading.dart';
import 'package:meuapp/shared/widgets/modal/app_modal_image_picker.dart';
import 'package:meuapp/shared/widgets/modal/app_modal_profile.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _textEditingController = TextEditingController();
  late final ProfileController controller;
  late final ProfileAvatarController controllerAvatar;

  Future imagePicker({required ImageSource source, int? quality}) async {
    try {
      final imageFile =
          await ImagePicker().pickImage(source: source, imageQuality: quality);
      if (imageFile == null) return;

      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.name.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      controllerAvatar.updateStorage(path: filePath, bytes: bytes);
      setState(() {});
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future _showModalImagePicker() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return AppModalImagePicker(
            souceCamera: () => imagePicker(source: ImageSource.camera),
            souceGalery: () => imagePicker(source: ImageSource.gallery),
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
        builder: (context) => AppModalProfile(
            controller: controller,
            textEditingController: _textEditingController,
            widget: widget));
  }

  @override
  void initState() {
    _textEditingController.text = widget.user.name;

    controllerAvatar = ProfileAvatarController(
      repository: ProfileRepositoryImpl(database: AppDatabase.instance),
    );
    controllerAvatar.addListener(() {
      controllerAvatar.state.when(
        error: (message, e) => context.showErrorSnackBar(message: message),
        orElse: () {},
      );
    });

    setState(() {
      controllerAvatar.urlAvatar();
    });

    controller = ProfileController(
        repository: ProfileRepositoryImpl(database: AppDatabase.instance),
        userModel: widget.user);
    controller.addListener(() {
      controller.state.when(
        success: (value) {
          _textEditingController.text = value.name;
        },
        orElse: () {},
      );
    });
    controller.getProfile();

    super.initState();
  }

  @override
  void dispose() {
    // _textEditingController.dispose();
    controllerAvatar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: UniqueKey(),
      backgroundColor: AppTheme.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
          child: Container(
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
                            child: widget.user.avatar_url == null
                                ? Container(
                                    color: AppTheme.colors.textEnabled,
                                    height: 120,
                                    width: 120,
                                    child: Center(child: Text("Foto")),
                                  )
                                : Container(
                                    color: AppTheme.colors.textEnabled,
                                    height: 120,
                                    width: 120,
                                    child: Center(
                                      child: AnimatedBuilder(
                                        animation: controllerAvatar,
                                        builder: (_, __) =>
                                            controllerAvatar.state.when(
                                          loading: () => AppLoading(
                                              height: 120,
                                              width: 120,
                                              message: "carregando..."),
                                          success: (value) => value != null
                                              ? Image.network(
                                                  value,
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                )
                                              : Text("Foto"),
                                          error: (message, e) =>
                                              context.showErrorSnackBar(
                                                  message: message),
                                          orElse: () {},
                                        ),
                                      ),
                                    ),
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
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) => controller.state.when(
                    loading: () => AppLoading(
                      message: "carregando...",
                      width: size.width,
                      height: size.height / 3.5,
                    ),
                    success: (value) {
                      final profile = value;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            title: Text("Nome:"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${profile.name}"),
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
                        ],
                      );
                    },
                    orElse: () => Container(
                      color: Colors.red,
                    ),
                  ),
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
      ),
    );
  }
}
