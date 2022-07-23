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

import '../dialogs/get_time_dialog.dart';
import '../../main.dart';

class TwinkleSettings extends StatelessWidget {
  const TwinkleSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit =
        context.read<ModeCubit>(); //BlocProvider.of<ModeBloc>(context);
    return Consumer<TwinkleDataModel>(builder: (context, data, child) {
      return WillPopScope(
        onWillPop: () async {
          cubit.toMainScreen();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Utils.WHITE_COLOR,
              onPressed: () {
                cubit.toMainScreen();
              },
            ),
            backgroundColor: Utils.DARK_BLUE_COLOR,
            title: Text(
              di.localization.settingsString,
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
                        TwinkleLabel(
                          data: di.localization.settingsGender,
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
                      TwinkleLabel(
                        data: di.localization.settingsAge,
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
                      TwinkleLabel(
                        data: di.localization.settingsPrice,
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
                      TwinkleLabel(
                        data: di.localization.settingsPerDay,
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
                      TwinkleLabel(
                        data: di.localization.settingsTotalDays,
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
                      TwinkleLabel(
                        data: di.localization.settingsWakeUp,
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TwinkleButton(
                            text: '${data.wakeUpTime}',
                            selected: true,
                            size: 30,
                            onPressed: () async {
                              // Dialog:  Get Wake up time
                              var value =
                                await getDayTime(context, time: data.wakeUpTime);

                              // Validation was encapsulated in TwinkleMainData
                              if (value != null){
                                data.wakeUpTime = value;
                              }

                            }),
                      ),
                    ),
                    //..................... GoodNight Time .....................
                    getTableRow(
                      TwinkleLabel(
                        data: di.localization.settingsGoodNight,
                        size: 20,
                        width: 150,
                        align: TextAlign.end,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TwinkleButton(
                            text: '${data.goodNightTime}',
                            selected: true,
                            size: 30,
                            onPressed: () async {
                              // Dialog:  Get Wake up time
                              var value = await getDayTime(context,
                                  time: data.goodNightTime);

                              // Validation was encapsulated in TwinkleMainData
                              if (value != null){
                                data.goodNightTime = value;
                              }

                            }),
                      ),
                    ),
                  ],
                ),
                //........................ Currency ............................
                getRow(
                    TwinkleLabel(
                      data: di.localization.settingsCurrency,
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
                    TwinkleLabel(
                      data: di.localization.settingsLanguage,
                      size: 20,
                      width: 150,
                      align: TextAlign.end,
                    ),
                    TwinkleRadioList(
                      values: data.language.values,
                      value: data.language.index,
                      width: MediaQuery.of(context).size.width * 0.5,
                      size: 16,
                      onChange: (value) {
                        cubit.setLanguage(value);
                      },
                    ),
                    10,
                    10),

              ],
            ),
          )),
          persistentFooterButtons: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //...................... Save changes ..........................
                TwinkleButton(
                  text: 'save',
                  selected: true,
                  size: 24,
                  width: 100,
                  onPressed: () async {
                    bool result = await showConfirmDialog(context,
                        title: 'Do you really want to change initial data?');
                    //print('result = $result');
                    if (result) {
                      cubit.changeData();
                    }
                  },
                ),
                //.......................... Divider ...........................
                const SizedBox(width: 10,),
                //.........................  RESET ALL  ........................
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
                      cubit.resetData();
                    }
                  },
                ),
              ],
            )
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
