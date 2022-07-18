import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/presentation/dialogs/confirm_dialog.dart';
import 'package:twinkle/presentation/style/styles.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/models/time_calculation_data.dart';

class MainProcess extends StatelessWidget {
  const MainProcess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit =
        context.read<ModeCubit>(); //BlocProvider.of<ModeBloc>(context);

    return Consumer<TwinkleTimeCalculationData>(
        builder: (context, calculationData, child) {
      return Consumer<TwinkleDataModel>(
        builder: (context, data, child) => WillPopScope(
          onWillPop: () async {
            return await showConfirmDialog(context,
                title: 'Do you really want to exit?');
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Utils.ORANGE_COLOR,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //---------------  Time remaining before next cigarette  ----------------
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                          'You can smoke after ${calculationData.timeToNext.hours} hours ${calculationData.timeToNext.minutes} minutes',
                          textAlign: TextAlign.center,
                          style: Utils.getWhiteOnOrangeStyle(size: 26)),
                    ),

                    //---------------------  Remaining time indicator  -----------------------
                    CircularPercentIndicator(
                      percent: 1.0 - calculationData.percentToNext,
                      lineWidth: 25,
                      radius: MediaQuery.of(context).size.width / 2 * 0.9,
                      backgroundColor: Utils.ORANGE_COLOR,
                      progressColor: Utils.WHITE_COLOR,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        calculationData.timeToNext.toString(),
                        style: Utils.getWhiteOnOrangeStyle(size: 64),
                      ),
                    ),

                    //----------------------  Extra cigarette button  -----------------------
                    TextButton(
                      onPressed: () async {
                        bool answer = await showConfirmDialog(context,
                            title: 'Do you really need an extra cigarette?');
                        if (answer) {
                          cubit.addExtraCigarette();
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Utils.YELLOW_COLOR)),
                      child: Text(
                        'I need extra cigarette!',
                        style: Utils.getWhiteOnYellowStyle(size: 24),
                      ),
                    ),
                    //---------------  Time remaining before next cigarette  ----------------
                    Text('Extra cigarettes: ${data.extraCigaretteCount}',
                        textAlign: TextAlign.start,
                        style: Utils.getWhiteOnOrangeStyle(size: 20)),
                    Text('Max cigarettes today: ${calculationData.totalCigarettesToday}',
                        textAlign: TextAlign.start,
                        style: Utils.getWhiteOnOrangeStyle(size: 20)),
                  ],
                ),
              ),

              // ---------------------------  FOOTER MENU  ------------------------------------
              persistentFooterButtons: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ----------------------  'Achivements' button  ------------------------
                      IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.trophy,
                            size: 32,
                            color: Utils.WHITE_COLOR,
                          ),
                          onPressed: () {
                            cubit.toAchivements();
                          }),
                      // ----------------------  'Settings' button  ---------------------------
                      IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.gear,
                            size: 32,
                            color: Utils.WHITE_COLOR,
                          ),
                          onPressed: () {
                            cubit.toHotSettings();
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
