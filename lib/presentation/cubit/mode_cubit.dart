import 'package:android_long_task/long_task/app_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/domain/models/user_data.dart';
import 'package:twinkle/presentation/cubit/states.dart';

import '../../core/foreground_service_data.dart';

class ModeCubit extends Cubit<TwinkleState>{
  ModeCubit({required this.repository}) : super(TwinkleLoadingState());

  final TwinkleDataRepository repository;

  //********************************************* New version *****************************************************
  //           +-(Load data)-+--------------------------+--------------------------------------+
  //           |             |                          |                                      |
  //   (detect process)      |                          |                                      |
  //           |             V                          V                                      V
  //  Splash --+      +-> Stopped -----------------> Started -------> [process] -----------> Ended ----------------+
  //                  | (Store data)               (Store data)                           (Store data)             |
  //                  |      ^                    (start process)                         (end process)            |
  //                  |      |                          |(kill process)                                            |
  //                  |      +--------------------------+                                                          |
  //                  +--------------------------------------------------------------------------------------------+

  // Initial state
  void initialState()async{
    // Show plash screen
    toSplashScreen();
    await Future.delayed(const Duration(seconds: 3));
    try{
      var result = await AppClient.getData();
      if (result == null){
        // process was stopped or ended

      }else{
        // process is running

      }
    } catch (e){
      print('----------------ERROR GETTING DATA------------------');
    }

    loadState();
  }

  // Load data to repository
  void loadState() {
    //print('loading data...');
    repository.loadData();
    selectPage();
  }

  // Select page
  void selectPage(){
    switch(repository.processState) {
      case ProcessState.stopped:
        toOnboardPageOne();
        break;
      case ProcessState.started:
        toMainScreen();
        break;
      case ProcessState.ended:
        toCongratulationsPage();
        break;
    }
  }

  // To splash
  void toSplashScreen(){
    emit(TwinkleLoadingState());
  }

  // First settings. Page 1
  void toOnboardPageOne(){
    emit(TwinkleOnBoardOneState());
  }

  // First settings. Page 2
  void toOnboardPageTwo(){
    emit(TwinkleOnBoardTwoState());
  }

  // To Main screen
  void toMainScreen(){
    emit(TwinkleProcessingState());
  }

  // To hot settings screen
  void toHotSettings(){
    emit(TwinkleSettingsState());
  }

  // To Achivements screen
  void toAchivements(){
    emit(TwinkleAchivementsState());
  }

  // To congratulations
  void toCongratulationsPage(){
    emit(TwinkleCongratulationsState());
  }

  // Start process -> to Main screen
  void startProcess() async {
    repository.startProcess();
    selectPage();

    //---------------  START FOREGROUND PROCESS  ---------------
    final serviceData = AppServiceData(data: repository.data);
    var result = await AppClient.execute(serviceData);
    var resultData = AppServiceData.fromJson(result);

    endProcess();
    selectPage();
  }

  // Reset data -> to Initial Setting screen
  void resetData(){
    // Stop process
    AppClient.stopService();
    // Reset data
    repository.resetAllData();
    // Change page
    selectPage();
  }

  // End process -> to Congratulations screen
  void endProcess(){
    repository.endProcess();
    selectPage();
  }
}

