import 'package:flutter/material.dart';

class PSuccessSeal extends StatelessWidget {
  const PSuccessSeal({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/checkmark.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
