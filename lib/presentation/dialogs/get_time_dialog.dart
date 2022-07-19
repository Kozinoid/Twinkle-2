import 'package:flutter/material.dart';

import '../../domain/models/time_class.dart';
import '../widgets/time_picker.dart';

Future<DayTime?> getDayTime(BuildContext context, {required DayTime time}) {
  return showDialog<DayTime?>(
      context: context,
      builder: (context) => TwinkleTimePicker(time: time,)
  );
}