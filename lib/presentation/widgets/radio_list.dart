import 'package:flutter/material.dart';
import 'package:twinkle/presentation/widgets/button.dart';
import 'package:twinkle/presentation/style/styles.dart';

class TwinkleRadioList extends StatelessWidget {
  const TwinkleRadioList({Key? key, this.values = const ['yes', 'no'], this.value = 0, this.width = 250, this.size = 20, required this.onChange}) : super(key: key);

  final List<String> values;
  final int value;
  final double width;
  final double size;
  final void Function(int value) onChange;

  @override
  Widget build(BuildContext context) {
    final itemWidth = width / values.length;
    return Container(
      width: width,
      height: size * 2.2,
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Utils.YELLOW_COLOR,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: values.length,
          itemBuilder: (context, index){
            return SizedBox(
              width: itemWidth,
              height: size * 1.8,
              child: TwinkleButton(
                text: values[index],
                size: size,
                selected: (index == value),
                onPressed: (){onChange(index);},
              ),
            );
          }
      ),
    );
  }
}
