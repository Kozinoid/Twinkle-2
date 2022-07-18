import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/main_data_model.dart';
import '../cubit/mode_cubit.dart';

class TwinkleGoodNight extends StatelessWidget {
  const TwinkleGoodNight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeCubit cubit = context.read<ModeCubit>();
    return Consumer<TwinkleDataModel>(
      builder: (context, data, child) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                  children: [
                    ElevatedButton(
                      child: const Text('Goog night!'),
                      onPressed: (){
                        cubit.toMainScreen();
                      },
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
