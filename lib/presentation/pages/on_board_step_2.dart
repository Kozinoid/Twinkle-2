import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/presentation/widgets/button.dart';
import 'package:twinkle/presentation/widgets/counter.dart';
import 'package:twinkle/presentation/widgets/label.dart';
import 'package:twinkle/presentation/widgets/radio_list.dart';
import 'package:twinkle/presentation/widgets/separator.dart';
import 'package:twinkle/presentation/style/styles.dart';

import '../../main.dart';

class TwinkleOnBoardTwo extends StatelessWidget {
  const TwinkleOnBoardTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit =
        context.read<ModeCubit>(); //BlocProvider.of<ModeBloc>(context);
    return Consumer<TwinkleDataModel>(builder: (context, data, child) {
      return WillPopScope(
        onWillPop: () async {
          cubit.toOnboardPageOne();
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
                  data: di.localization.page2Header,
                  size: 28,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),

                const TwinkleSeparator(),

                //------------------ Per day ---------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TwinkleLabel(
                      data: di.localization.perDayString,
                      size: 24,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    TwinkleCounter(
                      size: 20,
                      width: 200,
                      min: data.maxPerDay.min,
                      max: data.maxPerDay.max,
                      value: data.maxPerDay.value,
                      onChange: (differance) {
                        data.maxPerDay.value += differance;
                      },
                    ),
                    const TwinkleSeparator(),
                  ],
                ),

                //------------------ Price ---------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TwinkleLabel(
                      data: di.localization.priceString,
                      size: 24,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    TwinkleCounter(
                      size: 20,
                      width: 200,
                      min: data.price.min,
                      max: data.price.max,
                      value: data.price.value,
                      onChange: (differance) {
                        data.price.value += differance;
                      },
                    ),
                    const TwinkleSeparator(),
                  ],
                ),

                //------------------ Currency ---------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TwinkleLabel(
                      data: di.localization.currencyString,
                      size: 24,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    TwinkleRadioList(
                      values: data.currency.values,
                      value: data.currency.index,
                      width: MediaQuery.of(context).size.width * 0.9,
                      onChange: (value) {
                        data.currencyIndex = value;
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
                //-------------------  Back to page 1 button  ------------------------------
                TwinkleButton(
                  text: '<',
                  selected: true,
                  size: 24,
                  width: 30,
                  onPressed: () {
                    cubit.toOnboardPageOne();
                  },
                ),

                const TwinkleLabel(
                  data: 'Step 2 of 3',
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
                    cubit.toOnboardPageThree();
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
