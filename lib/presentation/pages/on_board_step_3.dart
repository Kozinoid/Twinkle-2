import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/presentation/dialogs/get_time_dialog.dart';

import '../../domain/models/main_data_model.dart';
import '../../main.dart';
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
                //-------------------------- Header ----------------------------
                TwinkleLabel(
                  data: di.localization.page3Header,
                  size: 28,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),

                const TwinkleSeparator(),

                //-------------------  Wake up time field  ---------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TwinkleLabel(
                      data: di.localization.wakeUpString,
                      size: 24,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TwinkleButton(
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
                    const SizedBox(
                      height: 20,
                    ),
                    const TwinkleSeparator(),
                  ],
                ),

                //-----------------  Good night time field  --------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TwinkleLabel(
                      data: di.localization.goodNightString,
                      size: 24,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TwinkleButton(
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
                    const SizedBox(
                      height: 20,
                    ),
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
