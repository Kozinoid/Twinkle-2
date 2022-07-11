import 'package:flutter/material.dart';
import 'package:twinkle/presentation/style/styles.dart';

class TwinkleButton extends StatelessWidget {
  const TwinkleButton({Key? key, required this.text, required this.selected, this.width, required this.size, required this.onPressed}) : super(key: key);
  final String text;
  final bool selected;
  final double? width;
  final double size;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
          selected
              ? MaterialStateProperty.all<Color>(Utils.DARK_BLUE_COLOR)
              : MaterialStateProperty.all<Color>(Utils.YELLOW_COLOR),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0)
          ),),),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:
          selected
              ? Utils.getLightStyle(size: size, fontWeight: FontWeight.bold)
              : Utils.getDarkStyle(size: size, fontWeight: FontWeight.w900),),
      ),
    );
  }
}

