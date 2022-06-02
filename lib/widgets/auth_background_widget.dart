import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [_PurpelBox(), const _IconPerson(), child]),
    );
  }
}

class _IconPerson extends StatelessWidget {
  const _IconPerson({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        height: 100,
        child: const Icon(Icons.person_pin, size: 90, color: Colors.white),
      ),
    );
  }
}

class _PurpelBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _gradienBoxPurple(),
      child: Stack(
        children: const [
          Positioned(
            top: 90,
            left: 30,
            child: _Bubble(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          Positioned(
            top: -40,
            left: -30,
            child: _Bubble(
              begin: Alignment.bottomRight,
              end: Alignment.centerLeft,
            ),
          ),
          Positioned(
            top: -50,
            right: -20,
            child: _Bubble(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          Positioned(
            bottom: -50,
            left: 10,
            child: _Bubble(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            top: 10,
            left: 150,
            child:
                _Bubble(begin: Alignment.topLeft, end: Alignment.bottomCenter),
          ),
          Positioned(
            bottom: 120,
            right: 20,
            child: _Bubble(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _gradienBoxPurple() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]));
}

class _Bubble extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const _Bubble({required this.begin, required this.end});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(begin: begin, end: end, colors: const [
            Color.fromRGBO(255, 255, 255, 0.25),
            Color.fromRGBO(1, 1, 1, 0.009)
          ])),
    );
  }
}
