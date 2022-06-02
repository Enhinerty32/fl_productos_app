import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCzcO2TkHgLxO_SqLFP22BohbGO7FrOySg';

  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
//encode sirve para codificarla y mandarla para el post que me solicita
    final res = await http.post(url, body: json.encode(authData));
//decoded sirve para descodificarlos y podramos observar los resultados
    final deacodedRes = json.decode(res.body);

    if (deacodedRes.containsKey('idToken')) {
      await storage.write(key: 'myToken', value: deacodedRes['idToken']);
      //Guardar token lugar seguro
      //deacodedRes['idToken'];
      return null;
    } else {
      return deacodedRes['error']['message'];
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});
//encode sirve para codificarla y mandarla para el post que me solicita
    final res = await http.post(url, body: json.encode(authData));
//decoded sirve para descodificarlos y podramos observar los resultados
    final deacodedRes = json.decode(res.body);
    print(deacodedRes);

    if (deacodedRes.containsKey('idToken')) {
      //Guardar token lugar seguro
      //deacodedRes['idToken'];

      await storage.write(key: 'myToken', value: deacodedRes['idToken']);
      return null;
    } else {
      print(deacodedRes);
      return deacodedRes['error']['message'];
    }
  }

  Future loguot() async {
    print(await storage.read(key: 'myToken') ?? '');
    await storage.delete(key: 'myToken');
    return;
  }

  Future<String> readToken() async {
    print(await storage.read(key: 'myToken') ?? '');
    return await storage.read(key: 'myToken') ?? '';
  }
}
