import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/main_data_model.dart';
import '../cubit/mode_cubit.dart';
import '../style/styles.dart';
import '../widgets/button.dart';
import '../widgets/label.dart';

class TwinkleWakeUp extends StatelessWidget {
  const TwinkleWakeUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit = context.read<ModeCubit>();
    return Consumer<TwinkleDataModel>(
      builder: (context, data, child) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Utils.YELLOW_COLOR,
          body: SafeArea(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Image.asset("assets/images/morning_tr.png")),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TwinkleLabel(data: 'Good morning!', size: 24, width: 300),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TwinkleButton(text: 'Ok', selected: true, size: 30, onPressed: (){cubit.toMainScreen();}),
                    )
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
