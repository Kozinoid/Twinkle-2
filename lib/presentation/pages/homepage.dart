import 'package:android_long_task/long_task/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/presentation/cubit/states.dart';
import 'package:twinkle/presentation/pages/settings.dart';
import 'package:twinkle/presentation/pages/splash.dart';

import '../../main.dart';
import 'achivements.dart';
import 'main_process.dart';
import 'on_board_step_1.dart';
import 'on_board_step_2.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        //------------------ Cubit for mode switching --------------------------
        BlocProvider(create: (context) => ModeCubit(repository: di.repository)..loadData(),),

        //--------------------- Main Data Provider -----------------------------
        ChangeNotifierProvider<TwinkleDataModel>.value(value: di.data),

        //--------------- Foreground process data stream -----------------------
        StreamProvider<Map<String, dynamic>?>.value(
            value: AppClient.updates,
            initialData: di.data.toJson()

        ),
      ],
      child: BlocBuilder<ModeCubit, TwinkleState>(
        //-----------------------------  MODES  --------------------------------
        builder: (context, state) {
          if (state is TwinkleLoadingState) {
            return const TwinkleSplash();
          } else if (state is TwinkleOnBoardOneState) {
            return const TwinkleOnBoardOne();
          } else if (state is TwinkleOnBoardTwoState) {
            return const TwinkleOnBoardTwo();
          } else if (state is TwinkleProcessingState) {
            return const MainProcess();
          } else if (state is TwinkleSettingsState) {
            return const TwinkleSettings();
          } else if (state is TwinkleAchivementsState) {
            return const TwinkleAchivements();
          } else {
            return Container();
          }
          return Container();
        },
      ),
    );
  }
}
