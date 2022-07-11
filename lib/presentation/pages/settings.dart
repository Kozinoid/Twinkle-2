import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/presentation/widgets/button.dart';
import 'package:twinkle/presentation/widgets/counter.dart';
import 'package:twinkle/presentation/widgets/label.dart';
import 'package:twinkle/presentation/widgets/radio_list.dart';
import 'package:twinkle/presentation/dialogs/confirm_dialog.dart';
import 'package:twinkle/presentation/style/styles.dart';

class TwinkleSettings extends StatelessWidget {
  const TwinkleSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeBloc bloc = context.read<ModeBloc>();//BlocProvider.of<ModeBloc>(context);
    return Consumer<TwinkleDataModel>(
      builder:(context, data, child){
        return WillPopScope(
          onWillPop: () async{
            bloc.toMainScreen();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Utils.WHITE_COLOR, onPressed: (){
                bloc.toMainScreen();
              },),
              backgroundColor: Utils.DARK_BLUE_COLOR,
              title: Text('settings', style:  Utils.getStyle(size: 20, fontWeight: FontWeight.bold, textColor: Utils.WHITE_COLOR, backColor: Utils.DARK_BLUE_COLOR,), ),
              centerTitle: true,
            ),
            backgroundColor: Utils.YELLOW_COLOR,
            body: Center(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        const TwinkleLabel(data: 'Gender:', size: 20, width: 150, align: TextAlign.end,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        TwinkleRadioList(values: data.gender.values, value: data.gender.index, width: MediaQuery.of(context).size.width * 0.55, size: 16,
                          onChange: (value){data.genderIndex = value;},),
                      ],),
                      Row(children: [
                        const TwinkleLabel(data: 'Age:', size: 20, width: 150, align: TextAlign.end,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        TwinkleCounter(size: 20, width: 160, min: data.age.min, max: data.age.max, value: data.age.value,
                          onChange: (differance){data.age.value += differance;
                        },),
                      ],),
                      Row(children: [
                        const TwinkleLabel(data: 'Price:', size: 20, width: 150, align: TextAlign.end,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        TwinkleCounter(size: 20, width: 160, min: data.price.min, max: data.price.max, value: data.price.value,
                          onChange: (differance){data.price.value += differance;},),
                      ],),
                      Row(children: [
                        const TwinkleLabel(data: 'Per day:', size: 20, width: 150, align: TextAlign.end,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        TwinkleCounter(size: 20, width: 160, min: data.perDay.min, max: data.perDay.max, value: data.perDay.value,
                          onChange: (differance){data.perDay.value += differance;},),
                      ],),
                      Row(children: [
                        const TwinkleLabel(data: 'Days to finish:', size: 20, width: 150, align: TextAlign.end,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        TwinkleCounter(size: 20, width: 160, min: data.daysToSmokeBreak.min, max: data.daysToSmokeBreak.max, value: data.daysToSmokeBreak.value,
                          onChange: (differance){data.daysToSmokeBreak.value += differance;},),
                      ],),
                      Row(children: [
                        const TwinkleLabel(data: 'Currency:', size: 20, width: 150, align: TextAlign.end,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        TwinkleRadioList(values: data.currency.values, value: data.currency.index, width: MediaQuery.of(context).size.width * 0.55, size: 12,
                          onChange: (value) {
                            data.currencyIndex = value;
                          },),
                      ],),
                      Row(children: [
                        const TwinkleLabel(data: 'Language:', size: 20, width: 150, align: TextAlign.end,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                        TwinkleRadioList(values: const ['Eng', 'Rus'], value: 0, width: 180, size: 20, onChange: (value){},),
                      ],),

                    ],
                  ),
                )
            ),
            persistentFooterButtons: [
              TwinkleButton(text: 'clear all data', selected: true, size: 24, width: 250, onPressed: () async {
                bool result = await showConfirmDialog(context, title: 'Do you really want to clear all data?');
                print('result = $result');
                if (result) bloc.resetData();
              },),
            ],
          ),
        );
      }
    );
  }
}
