import 'package:flutter/material.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/theme/app_theme.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChange;
  final UserModel user;
  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onChange,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, right: 23, bottom: 14, left: 23),
      child: Container(
        height: 75,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconBottomNavigation(
              onTap: () {
                onChange(0);
                // Navigator.pushReplacementNamed(context, "/home",
                //     arguments: user);
              },
              enable: currentIndex == 0,
              icon: Icons.home,
            ),
            IconBottomNavigation(
              onTap: () {
                onChange(3);
                // Navigator.pushNamed(context, "/home");
              },
              enable: currentIndex == 3,
              icon: Icons.add,
            ),
            IconBottomNavigation(
                onTap: () {
                  onChange(1);
                  // Navigator.pushNamed(context, "/perfil", arguments: user);
                },
                enable: currentIndex == 1,
                icon: Icons.supervisor_account_outlined),
          ],
        ),
      ),
    );
  }
}

class IconBottomNavigation extends StatelessWidget {
  final Function() onTap;
  final bool enable;
  final IconData icon;

  const IconBottomNavigation({
    Key? key,
    required this.onTap,
    required this.enable,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.5,
        width: 40.5,
        decoration: BoxDecoration(
          color: enable ? AppTheme.colors.primary : AppTheme.colors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: enable
              ? AppTheme.colors.textEnabled
              : AppTheme.colors.iconInactive,
        ),
      ),
    );
  }
}
