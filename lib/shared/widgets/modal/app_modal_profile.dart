import 'package:flutter/material.dart';
import 'package:meuapp/modules/profile/profile_controller.dart';
import 'package:meuapp/modules/profile/profile_page.dart';
import 'package:meuapp/shared/utils/constants_error.dart';
import 'package:meuapp/shared/widgets/button/button_widget.dart';
import 'package:meuapp/shared/widgets/input_text/input_text.dart';
import 'package:meuapp/shared/widgets/loading/app_loading.dart';

class AppModalProfile extends StatelessWidget {
  const AppModalProfile({
    Key? key,
    required this.controller,
    required TextEditingController textEditingController,
    required this.widget,
  })  : _textEditingController = textEditingController,
        super(key: key);

  final ProfileController controller;
  final TextEditingController _textEditingController;
  final ProfilePage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          right: 25,
          top: 25,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputText(
              controller: _textEditingController,
              label: "Alterar o nome",
              hint: widget.user.name,
              onChanged: (value) => controller.onChange(name: value),
            ),
            SizedBox(height: 28),
            AnimatedBuilder(
                animation: controller,
                builder: (_, __) => controller.state.when(
                      loading: () => AppLoading(
                          height: 100,
                          // width: ,
                          message: "atualizando..."),
                      error: (message, e) =>
                          context.showErrorSnackBar(message: message),
                      orElse: () => Button(
                        label: "Alterar",
                        onTap: () {
                          controller.updateProfile();
                          Navigator.of(context).pop();
                          // setState(() {});
                        },
                      ),
                    )),
            SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
