import 'package:fl_producto_app/providers/loginForm_provider.dart';
import 'package:fl_producto_app/screens/-screen.dart';
import 'package:fl_producto_app/services/-service.dart';
import 'package:fl_producto_app/ui/input_decoration_ui.dart';
import 'package:fl_producto_app/widgets/-widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static String routeScreen = 'Register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              CardContainer(
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Crear Cuenta',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => LoginFormProvider(),
                    child: _LoginForm(),
                  )
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1))),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeScreen);
                  },
                  child: const Text(
                    'Ya tienes cuenta?',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child:
          //TODO Mantener:La referencia KEY
          Form(
              key: loginForm.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [
                TextFormField(
                  onChanged: ((value) {
                    loginForm.email = value;
                  }),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.textStyleFormField(
                      hintText: 'correo@correo.com',
                      icon: Icons.alternate_email,
                      labelText: 'Correo Electronico'),
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(pattern);

                    return regExp.hasMatch(value ?? '')
                        ? null
                        : 'El correo no es correcto';
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    loginForm.password = value;
                  },
                  obscureText: true,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.textStyleFormField(
                      hintText: 'Contra****',
                      icon: Icons.lock,
                      labelText: 'Contraseña'),
                  validator: (value) {
                    return (value != null && value.length >= 6)
                        ? null
                        : 'La contrasena debe de ser de 6 caracteres';
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      child: Text(
                        loginForm.isLoading ? 'Espere...' : 'Ingresar',
                        style: const TextStyle(color: Colors.white),
                      )),
                  elevation: 0,
                  color: Colors.deepPurple,
                  disabledColor: Colors.grey,
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          //TODO Validar si el Login es correcto
                          final String? token = await authService.createUser(
                              loginForm.email, loginForm.password);
                          if (token == null) {
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.routeScreen);
                          } else {
                            print(token);
                            loginForm.isLoading = false;
                          }
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                )
              ])),
    );
  }
}
