import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:fl_producto_app/ui/input_decoration_ui.dart';
import 'package:fl_producto_app/services/-service.dart';

import 'package:fl_producto_app/providers/-provider.dart';
import 'package:fl_producto_app/widgets/-widget.dart';

import '../models/product_model.dart';

class ProductScreen extends StatelessWidget {
  static String routeScreen = 'Product Detail';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceProduct = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(product: serviceProduct.selectProduct),
      child: _ProductScreenBody(serviceProduct: serviceProduct),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductsService serviceProduct;

  const _ProductScreenBody({
    Key? key,
    required this.serviceProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
          /*La opcion de keyboardDismissBehavior hace que al escrollear
        se oculte el teclado automaticamente */
          //  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Stack(
            children: [
              ProductImage(urlImage: serviceProduct.selectProduct.picture),
              Positioned(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45)),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromRGBO(0, 0, 0, 0.6),
                      Color.fromRGBO(10, 10, 10, 0)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    child: IconButton(
                      onPressed: (() => Navigator.of(context).pop()),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(45),
                              bottomLeft: Radius.circular(45)),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Color.fromRGBO(0, 0, 0, 0.6),
                                  Color.fromRGBO(10, 10, 10, 0)
                                ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft)),
                            child: IconButton(
                              onPressed: (() //TODO Camara o galeria
                                  async {
                                final ImagePicker _pickerImg =
                                    new ImagePicker();
                                final XFile? pickedFile =
                                    await _pickerImg.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 100);
                                if (pickedFile == null) {
                                  print('No se lecciono naya');

                                  return;
                                }
                                print(
                                    'Tenemos Imagen familia wiiiii hay Fiesta ${pickedFile.path}');
                                //aqui envio el path
                                //   serviceProduct.myPath = pickedFile.path;
                                serviceProduct.updateSelectedProductImage(
                                    pickedFile.path);
                              }),
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          )))),
            ],
          ),
          ProductForm(),
          const SizedBox(
            height: 100,
          )
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: serviceProduct.isSaving
            ? CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save_outlined),
        onPressed: serviceProduct.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;

                final String? imgUrl = await serviceProduct.uploadImg();
                if (imgUrl != null) productForm.product.picture = imgUrl;
                print(imgUrl);

//Database Cloudinary sdk pack
                // final String? imgUrlCloudinary =
                //     await serviceProduct.postDataBaseCloudinary();

                // if (imgUrlCloudinary != null)
                //   productForm.product.picture = imgUrlCloudinary;

                serviceProduct.saveOrCreateProduct(productForm.product);
                Navigator.pop(context);
              },
      ),
    );
  }
}

class ProductForm extends StatelessWidget {
  const ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    //final bool myBool = productForm.isValidForm();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    initialValue: product.name,
                    onChanged: (value) {
                      product.name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                    },
                    decoration: InputDecorations.textStyleFormField(
                        labelText: 'Nombre:', hintText: 'Nombre del Producto')),
                const SizedBox(height: 25),
                TextFormField(
                    initialValue: product.price.toString(),
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        product.price = 0;
                      } else {
                        product.price = double.parse(value);
                      }
                    },
                    //InputFormatter le dise que hay varios tipos de reglas que tiene que seguir en el formato
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.textStyleFormField(
                        labelText: 'Precio:', hintText: '\$ 0.00')),
                const SizedBox(height: 25),
                SwitchListTile.adaptive(
                    activeColor: Colors.indigo,
                    title: const Text('Disponible'),
                    value: product.available,
                    //updateAvailable se afilia facilmente el value porque es la unica peticion del onChaged
                    onChanged: productForm.updateAvailable),
                const SizedBox(height: 25),
              ],
            )),
        width: double.infinity,
        height: 300,
        decoration: buildBoxDecoration(),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.005),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)));
}
