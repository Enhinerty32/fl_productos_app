import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/-model.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final cloudinary =
      Cloudinary("314613862276347", "7ZASkMrhZSqAP0OMDm7YhDhoSSo", "dhwnsqtkg");

  final String _baseURL = 'fl-products-default-rtdb.firebaseio.com';
  final String baseURLCloudinary =
      'https://res.cloudinary.com/dhwnsqtkg/image/upload/v1647906711/fl-Products/productsImgSave';
  final List<Product> products = [];
  late Product selectProduct;

  bool isLoadign = true;
  bool isSaving = false;

  File? newPictureFile;

  // String? myPath;

  final storage = new FlutterSecureStorage();

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    this.isLoadign = true;
    notifyListeners();
    //<List<Product>>
    final url = Uri.https(_baseURL, 'products.json',
        {'auth': await storage.read(key: 'myToken') ?? ''});
    final res = await http.get(url);
    final Map<String, dynamic> porductsMap = await json.decode(res.body);
    //Aqui quitaremos el arco del Map y lo haremos listado con el forEach
    porductsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      //products es el listado que tenemos creado y lo mandamos al listado
      products.add(tempProduct);
    });

    this.isLoadign = false;
    notifyListeners();
    return this.products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (products == null) {
      //Esnesesario crear
      return await createProduct(product);
    }
    //Actualizar

    await this.updateProduct(product);

    isSaving = false;
    notifyListeners();
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseURL, 'products.json',
        {'auth': await storage.read(key: 'myToken') ?? ''});
    final res = await http.post(url, body: product.toJson());
    final decodedData = json.decode(res.body);
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  Future<String> updateProduct(Product product) async {
    //Estamos actualizando la base de datos de firebase y
    //actualizando el listado interno de la app

    final url = Uri.https(_baseURL, 'products/${product.id}.json',
        {'auth': await storage.read(key: 'myToken') ?? ''});
    //put es para actualizar
    //Aqui estamos agregandolo en la lista ya mensionando en model
    final res = await http.put(url, body: product.toJson());
    final decodedData = res.body;
    //Actualizar el istado de productos
    print(decodedData);

    //TODO  :Actualizar listado de productos
//Estoy buscando donde esta la misma id de mi producto en la lista y
//hacer que  la copia se vuelva la original.

    final index =
        this.products.indexWhere((element) => element.id == product.id);

    products[index] = product;

    return product.id!;
  }

//--
  void updateSelectedProductImage(String path) async {
    this.selectProduct.picture = path;
    if (selectProduct.picture == null) return print('aqui no hay path');
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImg() async {
    if (this.newPictureFile == null) {
      print('newPicture es null');
      return null;
    }
    print('new picture sera llevado a firebase');

    this.isSaving = true;
    notifyListeners();

//Colgar la imagen con paquete de Cloudinary
    // await cloudinary.uploadResource(CloudinaryUploadResource(
    //     filePath: myPath,
    //     resourceType: CloudinaryResourceType.image,
    //     folder: 'fl-Products/productsImgSave',
    //     fileName: '${selectProduct.id}'));

    // notifyListeners();

    // final urlImg = '$baseURLCloudinary/${selectProduct.id}.jpg';
    // print('$urlImg');

    // notifyListeners();

    // newPictureFile = null;
    // myPath = null;
    // return urlImg;

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dhwnsqtkg/image/upload?upload_preset=kg6oos1q');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);
    final streamRes = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamRes);
    if (res.statusCode != 200 && res.statusCode != 201) {
      print('Algo salio mal');
      print(res.body);
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(res.body);
    return decodedData['secure_url'];
  }
}


//Colgar la imagen con paquete de Cloudinary
    // await cloudinary.uploadResource(CloudinaryUploadResource(
    //     filePath: myPath,
    //     resourceType: CloudinaryResourceType.image,
    //     folder: 'fl-Products/productsImgSave',
    //     fileName: '${selectProduct.id}'));

    // notifyListeners();

    // final urlImg = '$baseURLCloudinary/${selectProduct.id}.jpg';
    // print('$urlImg');

    // notifyListeners();

    // newPictureFile = null;
    // myPath = null;
    // return urlImg;
 



//Colgar imagen con http




  // Future<String?> postDataBaseCloudinary() async {
  //   if (this.newPictureFile == null) return null;

  //   this.isSaving = true;
  //   notifyListeners();
  //   addImgDataBaseCloudinary(selectProduct.id);
  //   final url = await urlImgDataBaseCloudinary(selectProduct.id);
  //   return url;
  // }

  // urlImgDataBaseCloudinary(String? id) {
  //   final urlImg = '$baseURLCloudinary/$id.jpg';
  //   notifyListeners();
  // }

  // addImgDataBaseCloudinary(String? id) async {
  //   await cloudinary.uploadResource(
  //     CloudinaryUploadResource(
  //         filePath: myPath,
  //         resourceType: CloudinaryResourceType.image,
  //         folder: 'fl-Products/productsImgSave',
  //         fileName: '${id}'),
  //   );
  //   notifyListeners();
  // }

  // deleteDataBaseCloudinary(String url) {
  //   cloudinary.deleteFile(
  //       url:
  //           'https://res.cloudinary.com/dhwnsqtkg/image/upload/v1647906711/fl-Products/productsImgSave/EwvMFNXXIAAZxbM_fe22qv.jpg');
  //   notifyListeners();
  // }