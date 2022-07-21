import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/presentation/widgets/button.dart';
import 'package:twinkle/presentation/widgets/counter.dart';
import 'package:twinkle/presentation/widgets/label.dart';
import 'package:twinkle/presentation/widgets/radio_list.dart';
import 'package:twinkle/presentation/dialogs/confirm_dialog.dart';
import 'package:twinkle/presentation/style/styles.dart';

import '../../domain/models/day_time_class.dart';
import '../dialogs/get_time_dialog.dart';

class TwinkleSettings extends StatelessWidget {
  const TwinkleSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit bloc =
        context.read<ModeCubit>(); //BlocProvider.of<ModeBloc>(context);
    return Consumer<TwinkleDataModel>(builder: (context, data, child) {
      return WillPopScope(
        onWillPop: () async {
          bloc.toMainScreen();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Utils.WHITE_COLOR,
              onPressed: () {
                bloc.toMainScreen();
              },
            ),
            backgroundColor: Utils.DARK_BLUE_COLOR,
            title: Text(
              'settings',
              style: Utils.getStyle(
                size: 20,
                fontWeight: FontWeight.bold,
                textColor: Utils.WHITE_COLOR,
                backColor: Utils.DARK_BLUE_COLOR,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: Utils.YELLOW_COLOR,
          body: Center(
              child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(0.4),
                    1: FlexColumnWidth(0.6)
                  },
                  children: [
                    //........................ Gender ..........................
                    getTableRow(
                        const TwinkleLabel(
                          data: 'Gender:',
                          size: 20,
                          width: 150,
                          align: TextAlign.end,
                        ),
                        TwinkleLabel(
                          data: data.gender.values[data.gender.index],
                          size: 20,
                          width: 150,
                          align: TextAlign.center,
                        )),
                    //......................... Age ............................
                    getTableRow(
                      const TwinkleLabel(
                        data: 'Age:',
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      TwinkleCounter(
                        size: 20,
                        width: 100,
                        min: data.age.min,
                        max: data.age.max,
                        value: data.age.value,
                        onChange: (differance) {
                          data.age.value += differance;
                        },
                      ),
                    ),
                    //........................ Price ...........................
                    getTableRow(
                      const TwinkleLabel(
                        data: 'Price:',
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      TwinkleCounter(
                        size: 20,
                        width: 160,
                        min: data.price.min,
                        max: data.price.max,
                        value: data.price.value,
                        onChange: (differance) {
                          data.price.value += differance;
                        },
                      ),
                    ),
                    //....................... Per day ..........................
                    getTableRow(
                      const TwinkleLabel(
                        data: 'Per day at start:',
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      TwinkleCounter(
                        size: 20,
                        width: 160,
                        min: data.maxPerDay.min,
                        max: data.maxPerDay.max,
                        value: data.maxPerDay.value,
                        onChange: (differance) {
                          data.maxPerDay.value += differance;
                        },
                      ),
                    ),
                    //...................... Total days ........................
                    getTableRow(
                      const TwinkleLabel(
                        data: 'Total days:',
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      TwinkleCounter(
                        size: 20,
                        width: 160,
                        min: data.daysToSmokeBreak.min,
                        max: data.daysToSmokeBreak.max,
                        value: data.daysToSmokeBreak.value,
                        onChange: (differance) {
                          data.daysToSmokeBreak.value += differance;
                        },
                      ),
                    ),
                    //..................... WakeUp time ........................
                    getTableRow(
                      const TwinkleLabel(
                        data: 'Wake up time:',
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      TwinkleButton(
                          text: '${data.wakeUpTime}',
                          selected: true,
                          size: 30,
                          onPressed: () async {
                            // Dialog:  Get Wake up time
                            var value =
                            await getDayTime(context, time: data.wakeUpTime);
                            //--------- Validate time ---------
                            if (value != null) {
                              // If dialog result = ok (null - cancel)
                              // Wake up time must be < 23:00, min differance between wake up and good night - 1 hour
                              if (value >= DayTime(hours: 23, minutes: 0)) {
                                value = DayTime(
                                    hours: 22, minutes: 59); // max wake up time
                              }
                              DayTime time = data.goodNightTime;
                              data.wakeUpTime = value;
                              if (time - value < DayTime.oneHour()) {
                                //... min differance between wake up and good night - 1 hour
                                time = value + DayTime.oneHour();
                              }
                              data.goodNightTime = time;
                            }
                          }),
                    ),
                    //..................... GoodNight Time .....................
                    getTableRow(
                      const TwinkleLabel(
                        data: 'Good night time:',
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      TwinkleButton(
                          text: '${data.goodNightTime}',
                          selected: true,
                          size: 30,
                          onPressed: () async {
                            // Dialog:  Get Wake up time
                            var value = await getDayTime(context,
                                time: data.goodNightTime);
                            //--------- Validate time ---------
                            if (value != null) {
                              // Good night time must be > 01:00, min differance between wake up and good night - 1 hour
                              if (value < DayTime(hours: 1, minutes: 0)) {
                                value = DayTime(
                                    hours: 1, minutes: 0); // min good night time
                              }
                              DayTime time = data.wakeUpTime;
                              data.goodNightTime = value;
                              if (value - time < DayTime.oneHour()) {
                                //... min differance between wake up and good night - 1 hour
                                time = value - DayTime.oneHour();
                              }
                              data.wakeUpTime = time;
                            }
                          }),
                    ),
                  ],
                ),
                //........................ Currency ............................
                getRow(
                    const TwinkleLabel(
                      data: 'Currency:',
                      size: 20,
                      width: 150,
                      align: TextAlign.end,
                    ),
                    TwinkleRadioList(
                      values: data.currency.values,
                      value: data.currency.index,
                      width: MediaQuery.of(context).size.width * 0.55,
                      size: 12,
                      onChange: (value) {
                        data.currencyIndex = value;
                      },
                    ),
                    3,
                    10),
                //......................... Language ...........................
                getRow(
                    const TwinkleLabel(
                      data: 'Language:',
                      size: 20,
                      width: 150,
                      align: TextAlign.end,
                    ),
                    TwinkleRadioList(
                      values: const ['Eng', 'Rus'],
                      value: 0,
                      width: 180,
                      size: 20,
                      onChange: (value) {},
                    ),
                    10,
                    10),
                //...................... Save changes ..........................
                TwinkleButton(
                  text: 'save changes',
                  selected: true,
                  size: 24,
                  width: 250,
                  onPressed: () async {
                    bool result = await showConfirmDialog(context,
                        title: 'Do you really want to change initial data?');
                    //print('result = $result');
                    if (result) {
                      bloc.changeData();
                    }
                  },
                ),
              ],
            ),
          )),
          persistentFooterButtons: [
            //.........................  RESET ALL  ............................
            TwinkleButton(
              text: 'clear all data',
              selected: true,
              size: 24,
              width: 250,
              onPressed: () async {
                bool result = await showConfirmDialog(context,
                    title: 'Do you really want to clear all data?');
                //print('result = $result');
                if (result) {
                  bloc.resetData();
                }
              },
            ),
          ],
        ),
      );
    });
  }
}

TableRow getTableRow(Widget key, Widget value) {
  return TableRow(children: [
    key,
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: value,
    ),
  ]);
}

Row getRow(Widget key, Widget value, double pad1, double pad2) {
  return Row(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: pad1),
        child: key,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: pad2),
        child: value,
      )
    ],
  );
}
