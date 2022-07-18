import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/domain/models/time_class.dart';
import 'package:twinkle/foreground_task/foreground_api.dart';
import 'package:twinkle/presentation/cubit/states.dart';

import '../../domain/models/foreground_notificztions.dart';
import '../../domain/models/process_state.dart';

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

class ModeCubit extends Cubit<TwinkleState>{
  ModeCubit({required this.repository, required this.foregroundApi}) : super(TwinkleLoadingState());

  final TwinkleDataRepository repository;
  DayTime timeToNextSmoke = DayTime.empty();
  double percentageToNextSmoke = 0;
  ForegroundApi foregroundApi;

  // Initial state
  void initialState()async{
    // Show plash screen
    toSplashScreen();
    await Future.delayed(const Duration(seconds: 3));
    loadState();
    bool isRunning = await foregroundApi.isRunning;
    ProcessState processState = repository.processState;
    //print('is running: $isRunning, Process state: $processState');
    if (!isRunning && processState == ProcessState.started){
      startProcess();
    }else{
      selectPage();
    }
  }

  // Load data to repository
  void loadState() {
    //print('loading data...');
    repository.loadData();
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
      case ProcessState.finished:
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
    emit(TwinkleProcessingState(timeToNextSmoke, percentageToNextSmoke));
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

  // To next cigarette
  void toNextCigarettePage(){
    emit(TwinkleNextCigaretteState());
  }

  // To Wake up
  void toWakeUpPage(){
    emit(TwinkleWakeUpState());
  }

  // To good night
  void toGoodNightPage(){
    emit(TwinkleGoodNightState());
  }

  // Start process -> to Main screen
  void startProcess() async {
    repository.startProcess();
    selectPage();
    // Start foreground process
    foregroundApi.startForegroundTask(repository.data);
  }

  // Reset data -> to Initial Setting screen
  void resetData(){
    // Stop foreground process
    foregroundApi.stopForegroundTask();
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

  void addExtraCigarette() {
    repository.addExtraCigarette();
  }

  void onForegroundEvent(ForegroundNotification notification){
    switch (notification) {
      case ForegroundNotification.nextCigarette:
        toNextCigarettePage();
        // 'Can Smoke' event was handled
        foregroundApi.smokeTime.handle();  // reset trigger
        break;
      case ForegroundNotification.wakeUp:
        toWakeUpPage();
        // 'Wake Up' event was handled
        foregroundApi.wakeUpTime.handle();  // reset trigger
        break;
      case ForegroundNotification.goodNight:
        toGoodNightPage();
        // 'Good night' event was handled
        foregroundApi.goodNightTime.handle();  // reset trigger
        break;
      case ForegroundNotification.finished:
        toCongratulationsPage();
        // 'Finished' event was handled
        foregroundApi.finishTime.handle();  // reset trigger
        break;
    }
  }
}