import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/foreground_task/data/process_calculation_data.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/presentation/style/styles.dart';
import '../../domain/models/statistics_calculator.dart';
import '../widgets/label.dart';

class TwinkleAchivements extends StatelessWidget {
  const TwinkleAchivements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit =
        context.read<ModeCubit>(); //BlocProvider.of<ModeBloc>(context);

    return Consumer<TwinkleTimeCalculationData>(
      builder:(context, calculationData, child) => Consumer<TwinkleDataModel>(
        builder: (context, data, child) {
          StatisticsCalculator calculator = StatisticsCalculator(data: data, calculationData: calculationData);

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
                  'statistics',
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TwinkleLabel(
                      data: 'Current day: ${calculator.currentDay} of ${data.daysToSmokeBreak.value}',
                      size: 24,
                      width: MediaQuery.of(context).size.width,
                    ),
                    TwinkleLabel(
                      data: 'Start date: ${data.registrationDateString}',
                      size: 24,
                      width: MediaQuery.of(context).size.width,
                    ),
                    TwinkleLabel(
                      data: 'Quit smoking: ${calculator.percentToFinish}%',
                      size: 24,
                      width: MediaQuery.of(context).size.width,
                    ),
                    TwinkleLabel(
                      data: 'Extra cigarettes: ${data.extraCigaretteCount}',
                      size: 24,
                      width: MediaQuery.of(context).size.width,
                    ),
                    TwinkleLabel(
                      data:
                          'Passed cigarettes: ${calculator.passedCigarettesFromStart}',
                      size: 24,
                      width: MediaQuery.of(context).size.width,
                    ),
                    // TwinkleLabel(
                    //   data: 'Cleared lungs: 21%',
                    //   size: 24,
                    //   width: MediaQuery.of(context).size.width,
                    // ),
                    // TwinkleLabel(
                    //   data: 'Repaired blood: 17%',
                    //   size: 24,
                    //   width: MediaQuery.of(context).size.width,
                    // ),
                    // TwinkleLabel(
                    //   data: 'Saved days: 21%',
                    //   size: 24,
                    //   width: MediaQuery.of(context).size.width,
                    // ),
                    // TwinkleLabel(
                    //   data: 'Saved money: 287\$',
                    //   size: 24,
                    //   width: MediaQuery.of(context).size.width,
                    // ),
                  ],
                ),
              )),
              persistentFooterButtons: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  height: 210,
                  color: Utils.DARK_BLUE_COLOR,
                  child: Column(
                    children: [
                      Text('You can buy on 287\$',
                          textAlign: TextAlign.center,
                          style: Utils.getStyle(
                              size: 20,
                              textColor: Utils.WHITE_COLOR,
                              backColor: Utils.DARK_BLUE_COLOR,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 170,
                        //color: Utils.DARK_BLUE_COLOR,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                width: 180,
                                height: 100,
                                //color: Colors.black87,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      color: Colors.black87,
                                      width: 180,
                                      height: 120,
                                    ),
                                    Text('250\$',
                                        textAlign: TextAlign.center,
                                        style: Utils.getStyle(
                                            size: 20,
                                            textColor: Utils.WHITE_COLOR,
                                            backColor: Utils.DARK_BLUE_COLOR,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
