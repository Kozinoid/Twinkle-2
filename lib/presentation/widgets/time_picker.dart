import 'package:flutter/material.dart';
import 'package:twinkle/domain/models/time_class.dart';
import 'package:twinkle/presentation/widgets/button.dart';

import '../style/styles.dart';

class TwinkleTimePicker extends StatefulWidget {
  const TwinkleTimePicker({Key? key, required this.time}) : super(key: key);
  final DayTime time;

  @override
  State<TwinkleTimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TwinkleTimePicker> {
  final hourList = getItems(24);
  final minuteList = getItems(60);
  late int timeHours;
  late int timeMinutes;

  @override
  void initState() {
    timeHours = widget.time.hours;
    timeMinutes = widget.time.minutes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Navigator.of(context).pop(widget.time);
        return false;
      },
      child: Scaffold(
        backgroundColor: Utils.YELLOW_COLOR,
        body: Center(
            child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //-----------------  Hours Dropdown  --------------------
                  DropdownButton<int>(
                      dropdownColor: Utils.YELLOW_COLOR,
                      focusColor: Colors.red,
                      value: timeHours,
                      items: hourList,
                      onChanged: (value) {
                        setState(() {
                          timeHours = value ?? 0;
                        });
                      }),

                  const SizedBox(
                    width: 10,
                  ),

                  Text(':',
                      style: Utils.getDarkStyle(
                          size: 40, fontWeight: FontWeight.bold)),

                  const SizedBox(
                    width: 10,
                  ),

                  //-----------------  Minutes Dropdown  --------------------
                  DropdownButton<int>(
                      dropdownColor: Utils.YELLOW_COLOR,
                      focusColor: Colors.red,
                      value: timeMinutes,
                      items: minuteList,
                      onChanged: (value) {
                        setState(() {
                          timeMinutes = value ?? 0;
                        });
                      }),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //----------------  Button 'Ok'  ---------------------
                  TwinkleButton(
                    text: 'Ok',
                    selected: true,
                    size: 30,
                    onPressed: () {
                      Navigator.of(context).pop(DayTime(hours: timeHours, minutes: timeMinutes));
                    },
                  ),

                  const SizedBox(
                    width: 20,
                  ),
                  //----------------  Button 'Cancel'  ---------------------
                  TwinkleButton(
                    text: 'Cancel',
                    selected: true,
                    size: 30,
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}

List<DropdownMenuItem<int>> getItems(int count) {
  List<DropdownMenuItem<int>> result = <DropdownMenuItem<int>>[];
  for (int i = 0; i < count; i++) {
    result.add(DropdownMenuItem<int>(
      value: i,
      child: Text('$i'.padLeft(2, '0'),
          style: Utils.getDarkStyle(size: 40, fontWeight: FontWeight.bold)),
    ));
  }
  return result;
}
