import 'package:fl_producto_app/screens/-screen.dart';
import 'package:fl_producto_app/services/-service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  static String routeScreen = 'CheckAuth';

  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authToken = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: authToken.readToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) return Text('');

              if (snapshot.data == '') {
                Future.microtask(
                  () {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (
                              _,
                              __,
                              ___,
                            ) =>
                                LoginScreen(),
                            transitionDuration: Duration(seconds: 0)));

                    //  Navigator.of(context).pushReplacementNamed(LoginScreen.routeScreen);
                  },
                );
              } else {
                Future.microtask(() {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (
                            _,
                            __,
                            ___,
                          ) =>
                              HomeScreen(),
                          transitionDuration: Duration(seconds: 0)));
                });
              }

              return Container();
            }),
      ),
    );
  }
}
