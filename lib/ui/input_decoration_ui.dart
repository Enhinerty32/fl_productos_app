import 'package:flutter/Material.dart';

class InputDecorations {
  static InputDecoration textStyleFormField(
          {required String labelText,
          required String hintText,
          IconData? icon}) =>
      InputDecoration(
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  color: Colors.deepPurple,
                )
              : null,
          hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.purple),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)));
}
