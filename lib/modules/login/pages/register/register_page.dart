import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:meuapp/modules/login/pages/register/register_controller.dart';
import 'package:meuapp/modules/login/repositories/login_repository_impl.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/button/button_widget.dart';
import 'package:meuapp/shared/widgets/input_text/input_text.dart';
import 'package:validators/validators.dart';

class RegisterPager extends StatefulWidget {
  const RegisterPager({Key? key}) : super(key: key);

  @override
  State<RegisterPager> createState() => _RegisterPagerState();
}

class _RegisterPagerState extends State<RegisterPager> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final RegisterController controller;

  @override
  void initState() {
    controller = RegisterController(
        repository: LoginRepositoryImpl(database: AppDatabase.instance));

    controller.addListener(() {
      controller.state.when(
        success: (value) => Navigator.popAndPushNamed(context, "/login"),
        error: (message, _) => scaffoldKey.currentState!.showBottomSheet(
          (context) => BottomSheet(
            onClosing: () {},
            builder: (context) => Container(
              child: Text(message),
            ),
          ),
        ),
        loading: () => print("loading..."),
        orElse: () {},
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.colors.background,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 10),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  delay: Duration(milliseconds: 300),
                  duration: Duration(milliseconds: 600),
                  child: Text.rich(
                    TextSpan(
                      text: "Criando uma conta",
                      style: AppTheme.textStyles.title,
                      children: [
                        TextSpan(
                          text: "\nMantenha seus gastos em dia",
                          style: AppTheme.textStyles.subTitle,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 38),
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) => controller.state.when(
                    loading: () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 150),
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Cadastrando usuário..."),
                        ],
                      ),
                    ),
                    orElse: () => Column(
                      children: [
                        FadeInUp(
                            delay: Duration(milliseconds: 400),
                            duration: Duration(milliseconds: 700),
                            child: InputText(
                              label: "Nome",
                              hint: "Digite seu nome",
                              onChanged: (value) =>
                                  controller.onChange(name: value),
                              validator: (value) => value.isNotEmpty
                                  ? null
                                  : "Digite seu nome completo",
                            )),
                        SizedBox(height: 18),
                        FadeInUp(
                            delay: Duration(milliseconds: 500),
                            duration: Duration(milliseconds: 800),
                            child: InputText(
                                label: "Email",
                                hint: "Digite seu email",
                                onChanged: (value) =>
                                    controller.onChange(email: value),
                                validator: (value) => isEmail(value)
                                    ? null
                                    : "Digite um email válido")),
                        SizedBox(height: 18),
                        FadeInUp(
                          delay: Duration(milliseconds: 600),
                          duration: Duration(milliseconds: 900),
                          child: InputText(
                            label: "Senha",
                            hint: "Digite sua senha",
                            obscure: true,
                            onChanged: (value) =>
                                controller.onChange(password: value),
                            validator: (value) => value.length >= 6
                                ? null
                                : "Digite uma senha acima de 5 caracteres",
                          ),
                        ),
                        SizedBox(height: 18),
                        FadeInUp(
                          delay: Duration(milliseconds: 700),
                          duration: Duration(milliseconds: 1000),
                          child: Button(
                              label: "Criar conta",
                              onTap: () {
                                controller.register();
                              }),
                        ),
                        SizedBox(height: 18),
                        FadeInUp(
                          delay: Duration(milliseconds: 800),
                          duration: Duration(milliseconds: 1100),
                          child: Button(
                            label: "Já tem uma conta? Faça login",
                            onTap: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            type: ButtonType.none,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
