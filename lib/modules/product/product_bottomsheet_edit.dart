import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

import 'package:meuapp/modules/product/product_controller.dart';
import 'package:meuapp/modules/product/repositories/product_repository_impl.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/widgets/button/button_widget.dart';
import 'package:meuapp/shared/widgets/input_text/input_text.dart';

class ProductBottomSheetEdit extends StatefulWidget {
  final UserModel user;
  final OrderModel order;
  const ProductBottomSheetEdit({
    Key? key,
    required this.user,
    required this.order,
  }) : super(key: key);

  @override
  State<ProductBottomSheetEdit> createState() => _ProductBottomSheetEditState();
}

class _ProductBottomSheetEditState extends State<ProductBottomSheetEdit> {
  late final ProductController controller;
  TextEditingController _textEditingControllerName = TextEditingController();
  TextEditingController _textEditingControllerPrice = TextEditingController();
  var _selectedDate;

  @override
  void initState() {
    controller = ProductController(
        repository: ProductRepositoryImpl(database: AppDatabase.instance),
        user: widget.user,
        order: widget.order);
    controller.addListener(() {
      controller.state.when(
        success: (_) {
          Navigator.of(context)
              .popAndPushNamed("/home", arguments: widget.user);
        },
        orElse: () {},
      );
    });
    setState(() {
      _selectedDate = DateTime.parse(widget.order.created_at.toString());
      _textEditingControllerName.text = widget.order.name;
      _textEditingControllerPrice.text = "R\$ " + widget.order.price.toString();
      controller.onChange(name: widget.order.name);
      controller.onChange(price: "R\$ " + widget.order.price.toString());
      controller.onChange(created_at: _selectedDate.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _showDatePiker() async {
    _selectedDate = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((datePiker) {
      if (datePiker == null) return;
      setState(() {
        _selectedDate = datePiker;
        controller.onChange(created_at: _selectedDate.toString());
      });
    });
    print("Print chamado.");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            right: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 25),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              SizedBox(height: 32),
              InputText(
                controller: _textEditingControllerName,
                label: "Produto",
                hint: "Digite um nome",
                onChanged: (value) => controller.onChange(name: value),
                validator: (value) =>
                    value.isNotEmpty ? null : "Favor digite o nome do produto",
              ),
              SizedBox(height: 8),
              InputText(
                controller: _textEditingControllerPrice,
                label: "Preço",
                hint: "Digite o valor",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MoneyInputFormatter(
                    leadingSymbol: "R\$",
                    useSymbolPadding: true,
                    // mantissaLength: 4 // the length of the fractional side
                  )
                ],
                onChanged: (value) => controller.onChange(price: value),
                validator: (value) =>
                    value.isNotEmpty ? null : "Favor digite o valor do produto",
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'Data da compra'
                        : "Data selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}"),
                  ),
                  TextButton(
                    onPressed: _showDatePiker,
                    child: Text("Selecionar data"),
                  ),
                ],
              ),
              SizedBox(height: 28),
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) => controller.state.when(
                  loading: () => Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text("atualizando..."),
                        )
                      ],
                    ),
                  ),
                  error: (message, e) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        style: AppTheme.textStyles.msgError,
                      ),
                      SizedBox(height: 28),
                      Button(
                        label: "Alterar",
                        onTap: () {
                          controller.updateOrders();
                        },
                      )
                    ],
                  ),
                  orElse: () => Button(
                    label: "Alterar",
                    onTap: () {
                      controller.updateOrders();
                    },
                  ),
                ),
              ),
              SizedBox(height: 25)
            ],
          ),
        ),
      ),
    );
  }
}
