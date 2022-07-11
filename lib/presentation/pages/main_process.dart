import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';
import 'package:twinkle/presentation/dialogs/confirm_dialog.dart';
import 'package:twinkle/presentation/style/styles.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainProcess extends StatelessWidget {
  const MainProcess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModeBloc bloc = context.read<ModeBloc>();//BlocProvider.of<ModeBloc>(context);
    return WillPopScope(
      onWillPop: ()async{
        return await showConfirmDialog(context, title: 'Do you really want to exit?');
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
                      'You can smoke after 45 minutes',
                      textAlign: TextAlign.center,
                      style: Utils.getWhiteOnOrangeStyle(size: 32)),
                  ),

                  //---------------------  Remainig time indicator  -----------------------
                  CircularPercentIndicator(
                    percent: 0.75,
                    lineWidth: 30,
                    radius: MediaQuery.of(context).size.width / 2,
                    backgroundColor: Utils.ORANGE_COLOR,
                    progressColor: Utils.WHITE_COLOR,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      '45:57',
                      style: Utils.getWhiteOnOrangeStyle(size: 64),),
                  ),

                  //----------------------  Extra cigarette button  -----------------------
                  TextButton(
                      onPressed: (){},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(5.0)
                      ),),
                        backgroundColor: MaterialStateProperty.all<Color>(Utils.YELLOW_COLOR)
                    ),
                      child: Text(
                        'I need extra cigarette!',
                        style: Utils.getWhiteOnYellowStyle(size: 24),
                      ),
                  )
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
                  IconButton(icon: const FaIcon(FontAwesomeIcons.trophy, size: 32, color: Utils.WHITE_COLOR,), onPressed: (){
                    bloc.toAchivements();
                  }),
                  // ----------------------  'Settings' button  ---------------------------
                  IconButton(icon: const FaIcon(FontAwesomeIcons.gear, size: 32, color: Utils.WHITE_COLOR,), onPressed: (){
                    bloc.toHotSettings();
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
