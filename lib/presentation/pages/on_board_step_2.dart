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

class TwinkleOnBoardTwo extends StatelessWidget {
  const TwinkleOnBoardTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeBloc bloc = context.read<ModeBloc>();//BlocProvider.of<ModeBloc>(context);
    return Consumer<TwinkleDataModel>(
      builder: (context, data, child) {
        return WillPopScope(
          onWillPop: () async {
            bloc.toOnboardPageOne();
            return false;
          },
          child: Scaffold(
            backgroundColor: Utils.YELLOW_COLOR,
            body: Center(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TwinkleLabel(data: 'How many cigarettes do you smoke a day?', size: 24, width: MediaQuery.of(context).size.width * 0.9,),
                          TwinkleCounter(size: 20, width: 200, min: data.perDay.min, max: data.perDay.max, value: data.perDay.value,
                            onChange: (differance){data.perDay.value += differance;},),
                          const TwinkleSeparator(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TwinkleLabel(data: 'what is the price of 20 cigarettes?', size: 24, width: MediaQuery.of(context).size.width * 0.9,),
                          TwinkleCounter(size: 20, width: 200, min: data.price.min, max: data.price.max, value: data.price.value,
                            onChange: (differance){data.price.value += differance;},),
                          const TwinkleSeparator(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TwinkleLabel(data: 'What is your currency?', size: 24, width: MediaQuery.of(context).size.width * 0.9,),
                          TwinkleRadioList(values: data.currency.values, value: data.currency.index, width: MediaQuery.of(context).size.width * 0.9,
                            onChange: (value){data.currencyIndex = value;},),
                          const TwinkleSeparator(),
                        ],
                      ),
                    ],
                  ),
                )
            ),
            persistentFooterButtons: [
              Row(
                children: [
                  TwinkleButton(text: '<', selected: true, size: 24, width: 30,
                    onPressed: (){
                      bloc.toOnboardPageOne();
                    },
                  ),
                  const TwinkleLabel(data: 'Step 2 of 2', size: 24, width: 170,),
                  //Padding(padding: EdgeInsets.symmetric(horizontal: 20),),
                  const SizedBox(width: 70,),
                  TwinkleButton(text: 'Save', selected: true, size: 24, width: 100,
                  onPressed: (){
                    bloc.startProcess();
                  },),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}