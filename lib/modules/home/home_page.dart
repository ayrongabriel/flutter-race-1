import 'package:flutter/material.dart';

import 'package:meuapp/modules/product/product_bottomsheet.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/bottom_navigation/app_bottom_navigation.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  final List<Widget> pages;
  const HomePage({
    Key? key,
    required this.user,
    required this.pages,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;
  late final List<Widget> pages = widget.pages;

  void onChange(int index) async {
    if (index == 3) {
      await showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
          isScrollControlled: true,
          context: context,
          builder: (context) => ProductBottomSheet(
                user: widget.user,
              ));
    } else {
      currentIndex = index;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.background,
        elevation: 0,
        leadingWidth: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.account_box,
                  color: AppTheme.colors.textDisabled,
                ),
                backgroundColor: AppTheme.colors.textEnabled,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text.rich(TextSpan(
                    text: "Olá,",
                    style: AppTheme.textStyles.hint,
                    children: [
                      TextSpan(
                          text: "${widget.user.name}".toUpperCase(),
                          style: AppTheme.textStyles.hintBold)
                    ])),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppTheme.colors.background,
      // ignore: avoid_unnecessary_containers
      body: Container(
        key: UniqueKey(),
        child: List.from(pages)[currentIndex],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onChange: onChange,
        user: widget.user,
      ),
    );
  }
}
