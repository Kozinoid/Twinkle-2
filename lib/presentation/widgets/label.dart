import 'package:flutter/material.dart';
import 'package:twinkle/presentation/style/styles.dart';

class TwinkleLabel extends StatelessWidget {
  const TwinkleLabel({Key? key, required this.data, required this.size, required this.width, this.align = TextAlign.center}) : super(key: key);
  final double size;
  final String data;
  final double width;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        data,
        textAlign: align,
        style: Utils.getDarkStyle(size: size, fontWeight: FontWeight.bold),
      ),
    );
  }
}
