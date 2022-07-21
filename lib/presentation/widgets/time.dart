import 'package:flutter/material.dart';
import 'package:twinkle/presentation/widgets/counter.dart';
import 'package:twinkle/presentation/widgets/label.dart';

import '../../domain/models/day_time_class.dart';
import '../style/styles.dart';

class TwinkleTime extends StatelessWidget {
  const TwinkleTime(
      {Key? key,
      required this.value,
      required this.size,
      required this.width,
      required this.onChange})
      : super(key: key);

  final DayTime value;
  final double size;
  final double width;
  final void Function(DayTime change) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Utils.YELLOW_COLOR,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              TwinkleLabel(data: 'Hours', size: size, width: width * 0.4),
              TwinkleCounter(
                  value: value.hours,
                  min: 0,
                  max: 23,
                  size: size,
                  width: width * 0.6,
                  onChange: (differance){onChange(DayTime(hours: value.hours + differance, minutes: value.minutes));},
              )
            ],
          ),
          Row(
            children: [
              TwinkleLabel(data: 'Minutes', size: size, width: width * 0.4),
              TwinkleCounter(
                  value: value.minutes,
                  min: 0,
                  max: 59,
                  size: size,
                  width: width * 0.6,
                  onChange: (differance){onChange(DayTime(hours: value.hours, minutes: value.minutes + differance));},
              )
            ],
          ),
        ],
      ),
    );
  }
}
