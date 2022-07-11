import 'package:flutter/material.dart';
import 'package:twinkle/presentation/widgets/button.dart';
import 'package:twinkle/presentation/widgets/label.dart';
import 'package:twinkle/presentation/style/styles.dart';

Future<dynamic> showConfirmDialog(BuildContext context, {required String title}){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Utils.YELLOW_COLOR,
          title: TwinkleLabel(data: title,width: 400, size: 20,),
          actions: [
            TwinkleButton(text: 'Yes', selected: true, width: 100, size: 20, onPressed: (){
              Navigator.of(context).pop(true);
            },),
            TwinkleButton(text: 'No', selected: true, width: 100, size: 20, onPressed: (){
              Navigator.of(context).pop(false);
            },),
          ],
        );
      }
  );
}