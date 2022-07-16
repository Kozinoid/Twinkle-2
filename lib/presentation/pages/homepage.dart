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
import 'congratulations.dart';
import 'main_process.dart';
import 'on_board_step_1.dart';
import 'on_board_step_2.dart';

class MyHomePage extends StatelessWidget with WidgetsBindingObserver{
  const MyHomePage({Key? key}) : super(key: key);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //print(state);
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.resumed:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        di.api.closeReceivePort();
        print('Remove lifecycle observer');
        //WidgetsBinding.instance.removeObserver(di.exPage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        //------------------ Cubit for mode switching --------------------------
        BlocProvider(create: (context) => ModeCubit(repository: di.repository)..initialState(),),

        //--------------------- Main Data Provider -----------------------------
        ChangeNotifierProvider<TwinkleDataModel>.value(value: di.data),

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
          } if (state is TwinkleCongratulationsState) {
            return const TwinkleCongratulations();
          } else {
            return Container();
          }
          return Container();
        },
      ),
    );
  }
}
