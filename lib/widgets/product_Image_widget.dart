import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImage extends StatelessWidget {
  final String? urlImage;
  const ProductImage({Key? key, this.urlImage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(urlImage);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        child: Container(
            decoration: _buildBoxDecoration(),
            width: double.infinity,
            height: 450,
            child: getImage(urlImage)),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]);
  Widget getImage(String? img) {
    if (img == null) {
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    }

    if (img.startsWith('http')) {
      return FadeInImage(
        image: NetworkImage('$img'),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(img),
      fit: BoxFit.cover,
    );
  }
}
