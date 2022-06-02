import 'package:fl_producto_app/screens/-screen.dart';
import 'package:fl_producto_app/screens/check_auth_screen.dart';
import 'package:fl_producto_app/services/-service.dart';
import 'package:fl_producto_app/widgets/-widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeScreen = 'Home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  authService.loguot();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeScreen);
                },
                icon: Icon(Icons.login))
          ],
        ),
        body: productsService.isLoadign
            ? const LoadingScreen()
            : ListView.builder(
                itemCount: productsService.products.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                      onTap: (() async {
                        //TODO revisar de cerca
                        productsService.selectProduct =
                            productsService.products[i].copy();
                        //reparado :D el model no tenia el this. y por eso no se afiliaba con el copy()
                        Navigator.pushNamed(context, ProductScreen.routeScreen);
                      }),
                      child: ProductCard(product: productsService.products[i]));
                }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add)));
  }
}
