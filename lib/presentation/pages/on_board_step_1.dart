import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/presentation/dialogs/confirm_dialog.dart';
import 'package:twinkle/presentation/widgets/button.dart';
import 'package:twinkle/presentation/widgets/counter.dart';
import 'package:twinkle/presentation/widgets/label.dart';
import 'package:twinkle/presentation/widgets/radio_list.dart';
import 'package:twinkle/presentation/widgets/separator.dart';
import 'package:twinkle/presentation/style/styles.dart';

import '../../main.dart';

class TwinkleOnBoardOne extends StatelessWidget {
  const TwinkleOnBoardOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit =
        context.read<ModeCubit>(); //BlocProvider.of<ModeBloc>(context);
    return Consumer<TwinkleDataModel>(
      builder: (context, data, child) {
        return WillPopScope(
          onWillPop: () async {
            return await showConfirmDialog(context,
                title: 'Do you really want to exit?');
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
                    data: di.localization.page1Header,
                    size: 28,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),

                  const TwinkleSeparator(),

                  // ---------- Language ------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TwinkleLabel(
                        data: di.localization.languageString,
                        size: 24,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                      TwinkleRadioList(
                        values: data.language.values,
                        value: data.language.index,
                        width: MediaQuery.of(context).size.width * 0.7,
                        size: 20,
                        onChange: (value) {
                          cubit.setLanguage(value);
                        },
                      ),
                      const TwinkleSeparator(),
                    ],
                  ),

                  //----------- Gender --------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TwinkleLabel(
                        data: di.localization.genderString,
                        size: 24,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                      TwinkleRadioList(
                        values: data.gender.values,
                        value: data.gender.index,
                        width: 250,
                        size: 22,
                        onChange: (value) {
                          data.genderIndex = value;
                        },
                      ),
                      const TwinkleSeparator(),
                    ],
                  ),

                  //------------- Age --------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TwinkleLabel(
                        data: di.localization.ageString,
                        size: 24,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                      TwinkleCounter(
                        size: 20,
                        width: 200,
                        min: data.age.min,
                        max: data.age.max,
                        value: data.age.value,
                        onChange: (differance) {
                          data.age.value += differance;
                        },
                      ),
                      const TwinkleSeparator(),
                    ],
                  ),

                  //-------------- Total days ----------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TwinkleLabel(
                        data: di.localization.totalTimeString,
                        size: 24,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                      TwinkleCounter(
                        size: 20,
                        width: 200,
                        min: data.daysToSmokeBreak.min,
                        max: data.daysToSmokeBreak.max,
                        value: data.daysToSmokeBreak.value,
                        onChange: (differance) {
                          data.daysToSmokeBreak.value += differance;
                        },
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
                  const SizedBox(
                    width: 30,
                  ),
                  const TwinkleLabel(
                    data: 'Step 1 of 3',
                    size: 24,
                    width: 170,
                  ),
                  //Padding(padding: EdgeInsets.symmetric(horizontal: 20),),
                  const SizedBox(
                    width: 70,
                  ),
                  TwinkleButton(
                    text: 'Next',
                    selected: true,
                    size: 24,
                    width: 100,
                    onPressed: () {
                      cubit.toOnboardPageTwo();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
