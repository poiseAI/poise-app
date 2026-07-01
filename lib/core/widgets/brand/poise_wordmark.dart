import 'package:flutter/widgets.dart';

class PoiseWordmark extends StatelessWidget {
  const PoiseWordmark({super.key});

  static const width = 98.58332824707031;
  static const height = 28.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Poise',
      image: true,
      child: Image.asset(
        'assets/images/poise-wordmark-blue.png',
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }
}
