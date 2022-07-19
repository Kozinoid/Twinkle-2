import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/domain/models/time_class.dart';
import 'package:twinkle/presentation/widgets/time.dart';

import '../../domain/models/main_data_model.dart';
import '../cubit/mode_cubit.dart';
import '../style/styles.dart';
import '../widgets/button.dart';
import '../widgets/label.dart';
import '../widgets/separator.dart';

class TwinkleOnBoardThree extends StatelessWidget {
  const TwinkleOnBoardThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit =
        context.read<ModeCubit>(); //BlocProvider.of<ModeBloc>(context);
    return Consumer<TwinkleDataModel>(builder: (context, data, child) {
      return WillPopScope(
        onWillPop: () async {
          cubit.toOnboardPageTwo();
          return false;
        },
        child: Scaffold(
          backgroundColor: Utils.YELLOW_COLOR,
          body: Center(
              child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TwinkleLabel(
                  data: 'Schedule',
                  size: 26,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const TwinkleSeparator(),

                //-------------------  Wake up time field  ---------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TwinkleLabel(
                      data: 'Your \'wake up\' time?',
                      size: 24,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    TwinkleTime(
                        value: data.wakeUpTime,
                        size: 20,
                        width: 300,
                        onChange: (value) {
                          if (value < DayTime(hours: 23, minutes: 0)){
                            DayTime time = data.goodNightTime;
                            data.wakeUpTime = value;
                            if (time - value < DayTime.oneHour()){
                              time = value + DayTime.oneHour();
                            }
                            data.goodNightTime = time;
                          }
                        }),
                    const TwinkleSeparator(),
                  ],
                ),

                //-----------------  Good night time field  --------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TwinkleLabel(
                      data: 'Your \'good night\' time?',
                      size: 24,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    TwinkleTime(
                        value: data.goodNightTime,
                        size: 20,
                        width: 300,
                        onChange: (value) {
                          if (value >= DayTime(hours: 1, minutes: 0)){
                            DayTime time = data.wakeUpTime;
                            data.goodNightTime = value;
                            if (value - time < DayTime.oneHour()){
                              time = value - DayTime.oneHour();
                            }
                            data.wakeUpTime = time;
                          }
                        }),
                    const TwinkleSeparator(),
                  ],
                ),
              ],
            ),
          )),

          //=============================  ROOTER BUTTONS  ===================================
          persistentFooterButtons: [
            Row(
              children: [
                //-------------------  Back to page 2 button  ------------------------------
                TwinkleButton(
                  text: '<',
                  selected: true,
                  size: 24,
                  width: 30,
                  onPressed: () {
                    cubit.toOnboardPageTwo();
                  },
                ),

                // Label 'Step 2 of 2'
                const TwinkleLabel(
                  data: 'Step 3 of 3',
                  size: 24,
                  width: 170,
                ),

                // Sized box
                const SizedBox(
                  width: 70,
                ),

                //------------------- Save data and Start Process Button ----------------------
                TwinkleButton(
                  text: 'Save',
                  selected: true,
                  size: 24,
                  width: 100,
                  onPressed: () {
                    //TwinkleDataModel model = context.read<TwinkleDataModel>();
                    cubit.startProcess();
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
