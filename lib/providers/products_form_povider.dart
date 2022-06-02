import 'package:flutter/material.dart';

import '../models/-model.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  ProductFormProvider({required this.product});

  updateAvailable(value) {
    print(value);
    product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.id);
    print(product.name);
    print(product.price);
    print(product.available);
    print(product.picture);
    print(formKey);

    notifyListeners();
    final myBool = formKey.currentState?.validate();
    return myBool ?? false;
  }
}
