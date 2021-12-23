import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:meuapp/modules/login/login_controller.dart';
import 'package:meuapp/modules/login/repositories/login_repository_impl.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/widgets/button/button_widget.dart';
import 'package:meuapp/shared/widgets/input_text/input_text.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = LoginController(
        repository: LoginRepositoryImpl(database: AppDatabase.instance));

    controller.addListener(() {
      controller.state.when(
          success: (value) =>
              Navigator.popAndPushNamed(context, "/home", arguments: value),
          error: (message, _) => scaffoldKey.currentState!
              .showBottomSheet((context) => BottomSheet(
                    onClosing: () {},
                    builder: (context) => Container(
                      child: Text(message),
                    ),
                  )),
          loading: () => print("loding..."),
          orElse: () {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 56),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInUp(
                  delay: Duration(milliseconds: 300),
                  duration: Duration(milliseconds: 600),
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 225,
                    ),
                  ),
                ),
                FadeInUp(
                  delay: Duration(milliseconds: 400),
                  duration: Duration(milliseconds: 600),
                  child: InputText(
                    label: "Email",
                    hint: "Digite seu email",
                    onChanged: (value) => controller.onChange(email: value),
                    validator: (value) =>
                        isEmail(value) ? null : "Digite um email válido",
                  ),
                ),
                SizedBox(height: 18),
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 700),
                  child: InputText(
                    label: "Senha",
                    hint: "Digite sua senha",
                    obscure: true,
                    onChanged: (value) => controller.onChange(password: value),
                    validator: (value) =>
                        value.length >= 6 ? null : "Senha inválida",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) => controller.state.when(
                          loading: () => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CircularProgressIndicator(),
                          ),
                          orElse: () => Column(
                            children: [
                              FadeInUp(
                                  delay: Duration(milliseconds: 600),
                                  duration: Duration(milliseconds: 800),
                                  child: Button(
                                    label: "Entrar",
                                    onTap: () {
                                      controller.login();
                                    },
                                  )),
                              SizedBox(
                                height: 58,
                              ),
                              FadeInUp(
                                delay: Duration(milliseconds: 380),
                                duration: Duration(milliseconds: 900),
                                child: Button(
                                  label: "Criar uma conta",
                                  type: ButtonType.outline,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/login/register");
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
