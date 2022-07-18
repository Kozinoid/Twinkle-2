import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';

class TwinkleCongratulations extends StatelessWidget {
  const TwinkleCongratulations({Key? key}) : super(key: key);

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
                    child: const Text('Congratulations!'),
                    onPressed: (){
                      cubit.resetData();
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
