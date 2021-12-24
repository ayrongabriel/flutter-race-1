import 'package:flutter/material.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/divider/app_divider_horizontal.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              Text(
                "Perfil",
                style: AppTheme.textStyles.title,
              ),
              SizedBox(
                height: 25,
              ),
              Text("Nome: ${widget.user.name}"),
              AppDividerHorizontal(height: 1, padding: 15),
              Text("Email: ${widget.user.email}"),
              AppDividerHorizontal(height: 1, padding: 15),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.colors.textEnabled,
                  ),
                  child: Center(
                    child: Text("Sair do app").label,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
