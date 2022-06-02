import 'package:flutter/material.dart';

import '../models/-model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 350,
        decoration: _cardBorder(),
        child: Stack(alignment: Alignment.bottomLeft, children: [
          _backgroundImage(urlImg: product.picture),
          _ProductDetails(nameProduct: product.name, idProduct: product.id),
          Positioned(
              top: 0, right: 0, child: _PriceTag(priceProduct: product.price)),
          //TODO Mostrar de manera condicional
          if (!product.available)
            Positioned(top: 0, left: 0, child: _NotAvailable())
        ]),
      ),
    );
  }

  BoxDecoration _cardBorder() => BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'No Disponible',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
      ),
      width: 100,
      height: 70,
    );
    ;
  }
}

class _PriceTag extends StatelessWidget {
  final double priceProduct;
  const _PriceTag({
    Key? key,
    required this.priceProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$ $priceProduct',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      width: 100,
      height: 70,
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String nameProduct;
  final idProduct;
  const _ProductDetails({
    Key? key,
    required this.nameProduct,
    required this.idProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nameProduct,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              idProduct,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            )
          ],
        ),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _backgroundImage extends StatelessWidget {
  final String? urlImg;
  const _backgroundImage({
    Key? key,
    this.urlImg,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 350,
        child: urlImg == null
            ? const FadeInImage(
                fit: BoxFit.cover,
                //TOdO Fix Imgage
                image: AssetImage('assets/no-image.png'),
                placeholder: AssetImage('assets/jar-loading.gif'),
              )
            : FadeInImage(
                fit: BoxFit.cover,
                //TOdO Fix Imgage
                image: NetworkImage('$urlImg'),
                placeholder: AssetImage('assets/jar-loading.gif'),
              ),
      ),
    );
  }
}
