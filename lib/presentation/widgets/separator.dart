import 'package:flutter/material.dart';
import 'package:twinkle/presentation/style/styles.dart';

class TwinkleSeparator extends StatelessWidget {
  const TwinkleSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.YELLOW_COLOR,
      width: MediaQuery.of(context).size.width,
      height: 10,
      child: CustomPaint(
        painter: SeparatorPainter(width: MediaQuery.of(context).size.width),
      ),
    );
  }
}

class SeparatorPainter extends CustomPainter{
  const SeparatorPainter({required this.width}) : super();

  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    Offset p1 = Offset(width * 0.1, 5);
    Offset p2 = Offset(width  * 0.9, 5);
    Paint paint = Paint()
    ..color = Utils.DARK_BLUE_COLOR
    ..strokeWidth = 3;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}