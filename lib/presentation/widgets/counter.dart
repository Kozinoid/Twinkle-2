import 'package:flutter/material.dart';
import 'package:twinkle/presentation/style/styles.dart';

import 'button.dart';

class TwinkleCounter extends StatelessWidget {
  const TwinkleCounter({Key? key, this.size = 20.0, this.min = 0, this.max = 100, this.value = 0, this.width = 200, required this.onChange}) : super(key: key);

  final double size;
  final int min;
  final int max;
  final int value;
  final double width;
  final void Function(int change) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Utils.YELLOW_COLOR,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //-------------------------- 'Minus' - button ----------------------------
          TwinkleButton(
            text: '-',
            size: size * 1.2,
            width: size * 2.5,
            selected: true,
            onPressed: (){if (value > min) onChange(-1);},
          ),

          //----------------------------- Value field ------------------------------
          SizedBox(
              width: size * 3,
              child: Text('$value',
                style: Utils.getDarkStyle(size: size + 3, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),

          //--------------------------- 'Plus' - button ----------------------------
          TwinkleButton(
            text: '+',
            size: size * 1.2,
            width: size * 2.5,
            selected: true,
            onPressed: (){if (value < max) onChange(1);},
          ),
        ],
      ),
    );
  }
}
