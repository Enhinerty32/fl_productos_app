import 'package:fl_producto_app/screens/-screen.dart';
import 'package:fl_producto_app/screens/check_auth_screen.dart';
import 'package:fl_producto_app/services/-service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ProductsService(),
          ),
          ChangeNotifierProvider(
            create: (_) => AuthService(),
          )
        ],
        child: const MyApp(),
      );
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationsServices.messengerKey,
      initialRoute: CheckAuthScreen.routeScreen,
      routes: {
        HomeScreen.routeScreen: (_) => const HomeScreen(),
        LoginScreen.routeScreen: (_) => const LoginScreen(),
        ProductScreen.routeScreen: (_) => const ProductScreen(),
        CheckAuthScreen.routeScreen: (_) => const CheckAuthScreen(),
        RegisterScreen.routeScreen: (_) => const RegisterScreen()
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
