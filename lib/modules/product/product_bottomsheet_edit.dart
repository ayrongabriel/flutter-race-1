import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:meuapp/modules/product/product_controller.dart';
import 'package:meuapp/modules/product/repositories/product_repository_impl.dart';
import 'package:meuapp/shared/models/order_model.dart';
import 'package:meuapp/shared/models/user_model.dart';
import 'package:meuapp/shared/services/app_database.dart';
import 'package:meuapp/shared/theme/app_theme.dart';
import 'package:meuapp/shared/utils/app_routes.dart';
import 'package:meuapp/shared/widgets/button/button_widget.dart';
import 'package:meuapp/shared/widgets/input_text/input_text.dart';
import 'package:meuapp/shared/widgets/modal/app_modal_image_picker.dart';

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
  // link apenas para o estudo
  final bucket =
      "https://fkwjfmvabkxlhmvyiaec.supabase.in/storage/v1/object/public/products/";
  late final ProductController controller;
  TextEditingController _textEditingControllerName = TextEditingController();
  TextEditingController _textEditingControllerPrice = TextEditingController();
  TextEditingController _textEditingControllerDescription =
      TextEditingController();
  var _selectedDate;
  var _bytesImage;
  var _filePath;
  var _imgTemp;
  bool _isLoading = false;

  @override
  void initState() {
    controller = ProductController(
      repository: ProductRepositoryImpl(database: AppDatabase.instance),
    );
    controller.addListener(() {
      controller.state.when(
        success: (_) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.home, arguments: widget.user);
          setState(() {});
        },
        orElse: () {},
      );
    });

    setState(() {
      _selectedDate = DateTime.parse(widget.order.updated_at != null
          ? widget.order.updated_at.toString()
          : widget.order.created_at.toString());
      _textEditingControllerName.text = widget.order.name;
      _textEditingControllerDescription.text = widget.order.description ?? "";
      _textEditingControllerPrice.text = "R\$ " + widget.order.price.toString();
      controller.onChange(name: widget.order.name);
      controller.onChange(description: widget.order.description);
      controller.onChange(price: "R\$ " + widget.order.price.toString());
      controller.onChange(updated_at: _selectedDate.toString());
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future imagePicker({required ImageSource source, int? quality}) async {
    try {
      final imageFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: quality,
        maxHeight: 480,
        maxWidth: 640,
      );
      if (imageFile == null) return;

      setState(() => _isLoading = true);

      _bytesImage = await imageFile.readAsBytes();
      final fileExt = imageFile.name.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      _filePath = fileName;

      setState(() {
        _imgTemp = File(imageFile.path);
      });

      setState(() => false);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future _showModalImagePicker() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return AppModalImagePicker(
            souceCamera: () =>
                imagePicker(source: ImageSource.camera, quality: 30),
            souceGalery: () =>
                imagePicker(source: ImageSource.gallery, quality: 30),
          );
        });
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
        controller.onChange(updated_at: _selectedDate.toString());
      });
    });
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
              FadeInDown(
                delay: Duration(milliseconds: (500 * (1.2 + 1) / 4).round()),
                child: InputText(
                  controller: _textEditingControllerName,
                  label: "Produto",
                  hint: "Digite um nome",
                  onChanged: (value) => controller.onChange(name: value),
                  validator: (value) => value.isNotEmpty
                      ? null
                      : "Favor digite o nome do produto",
                ),
              ),
              SizedBox(height: 8),
              FadeInDown(
                delay: Duration(milliseconds: (500 * (1.2 + 2) / 4).round()),
                child: InputText(
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
                  validator: (value) => value.isNotEmpty
                      ? null
                      : "Favor digite o valor do produto",
                ),
              ),
              SizedBox(height: 8),
              FadeInDown(
                delay: Duration(milliseconds: (500 * (1.2 + 3) / 4).round()),
                child: InputText(
                  controller: _textEditingControllerDescription,
                  label: "Descrição",
                  hint: "Descrição da compra...",
                  maxLines: 5,
                  onChanged: (value) => controller.onChange(description: value),
                ),
              ),
              SizedBox(height: 8),
              FadeInDown(
                delay: Duration(milliseconds: (500 * (1.2 + 4) / 4).round()),
                child: Row(
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
              ),
              SizedBox(height: 8),
              SizedBox(height: 8),
              _isLoading != false
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: FileImage(_imgTemp), fit: BoxFit.cover),
                        ),
                        child: Center(
                          child: ClipOval(
                            child: Container(
                              color:
                                  AppTheme.colors.background.withOpacity(0.6),
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Icons.delete_outline,
                                  color: AppTheme.colors.badColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : FadeInUp(
                      delay:
                          Duration(milliseconds: (500 * (1.2 + 5) / 4).round()),
                      child: GestureDetector(
                        onTap: _showModalImagePicker,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: widget.order.thumbnail_url == null
                                    ? NetworkImage('${bucket}default.png')
                                    : NetworkImage(
                                        "${bucket}${widget.order.thumbnail_url}"),
                                fit: BoxFit.cover),
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Container(
                                color:
                                    AppTheme.colors.background.withOpacity(0.6),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: AppTheme.colors.badColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 28),
              FadeInUp(
                delay: Duration(milliseconds: (500 * (1.2 + 6) / 4).round()),
                child: AnimatedBuilder(
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
                            controller.updateOrders(
                                orderId: widget.order.id,
                                path: _filePath,
                                bytesImage: _bytesImage,
                                thumbnailOld: widget.order.thumbnail_url!);
                          },
                        )
                      ],
                    ),
                    orElse: () => Button(
                      label: "Alterar",
                      onTap: () {
                        controller.updateOrders(
                            orderId: widget.order.id,
                            path: _filePath,
                            bytesImage: _bytesImage,
                            thumbnailOld: widget.order.thumbnail_url!);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
