import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twinkle/core/types.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/domain/models/day_time_class.dart';
import 'package:twinkle/foreground_task/foreground_api.dart';
import 'package:twinkle/localization/localEn.dart';
import 'package:twinkle/presentation/cubit/states.dart';

import '../../localization/localRu.dart';
import '../../localization/localUk.dart';
import '../../main.dart';
import '../../notification_service/foreground_notifications.dart';
import '../../foreground_task/process_state.dart';
import '../../notification_service/notification_flag.dart';

const audioAsset = "assets/audio/red-indian-music.mp3";

class ModeCubit extends Cubit<TwinkleState> {
  ModeCubit({required this.repository, required this.foregroundApi})
      : super(TwinkleLoadingState());

  final TwinkleDataRepository repository;
  DayTime timeToNextSmoke = DayTime.empty();
  double percentageToNextSmoke = 0;
  ForegroundApi foregroundApi;
  // Hi from process to loading app
  NotificationTrigger receivedEvent = NotificationTrigger();

  // Audioplayer
  AudioPlayer player = AudioPlayer();
  // Audio asset
  String audioAsset = 'audio/bell.mp3';

  // Initial state
  void initialState() async {
    // Show plash screen
    toSplashScreen();
    await Future.delayed(const Duration(seconds: 3));
    // Load last settings
    loadState();
    //Load language
    loadLanguage();
    // Is background process running?
    bool isRunning = await foregroundApi.isRunning;
    // Last process status stored in repository
    ProcessState processState = repository.processState;

    // if last stored state - active (processState = true), but process is not running (isRunning = false) - device was restarted, process is going on
    // if last stored state - inactive (processState = false) and process is not running (isRunning = false) - process was not started yet
    // if last stored state - active (processState = true) and process is running (isRunning = true) - application is active, process is going on
    // if last stored state - inactive (processState = false) and process is running (isRunning = true) - application was restarted, process is going on
    if (!isRunning && processState == ProcessState.started) {
      // Device was restarted, restart process
      restartProcess();
    } else {
      // Application was restarted
      selectPage();
    }
  }

  // Load data to repository
  void loadState() {
    //print('loading data...');
    repository.loadData();
  }

  // Select page
  void selectPage() {
    switch (repository.processState) {
      case ProcessState.stopped:
        toOnboardPageOne();
        break;
      case ProcessState.started:
        if (!receivedEvent.isNotHandled) {
          toMainScreen();
        } else {
          receivedEvent.handle();
        }
        break;
    }
  }

  // To splash
  void toSplashScreen() {
    emit(TwinkleLoadingState());
  }

  // First settings. Page 1
  void toOnboardPageOne() {
    emit(TwinkleOnBoardOneState());
  }

  // First settings. Page 2
  void toOnboardPageTwo() {
    emit(TwinkleOnBoardTwoState());
  }

  // First settings. Page 3
  void toOnboardPageThree() {
    emit(TwinkleOnBoardThreeState());
  }

  // To Main screen
  void toMainScreen() {
    emit(TwinkleProcessingState(timeToNextSmoke, percentageToNextSmoke));
  }

  // To hot settings screen
  void toHotSettings() {
    emit(TwinkleSettingsState());
  }

  // To Achivements screen
  void toAchivements() {
    emit(TwinkleAchivementsState());
  }

  // To congratulations
  void toCongratulationsPage() {
    emit(TwinkleCongratulationsState());
  }

  // To next cigarette
  void toNextCigarettePage() {
    emit(TwinkleNextCigaretteState());
  }

  // To Wake up
  void toWakeUpPage() {
    emit(TwinkleWakeUpState());
  }

  // To good night
  void toGoodNightPage() {
    emit(TwinkleGoodNightState());
  }

  // Start process -> to Main screen
  void startProcess() async {
    // Set data
    repository.startProcess();;
    // Change page
    selectPage();
    // Start foreground process
    foregroundApi.startForegroundTask(repository.data);
  }

  // Restart process -> to Main Screen
  void restartProcess() async {
    // Set data
    repository.restartProcess();
    // Change page
    selectPage();
    // Start foreground process
    foregroundApi.startForegroundTask(repository.data);
  }

  // Reset data -> to Initial Setting screen
  void resetData() {
    // Stop foreground process
    foregroundApi.stopForegroundTask();
    // Reset data
    repository.resetAllData();
    // Change page
    selectPage();
  }

  // Change initial data
  void changeData(){
    // Save changes
    repository.changeInitialData();
    // Send changes to process
    foregroundApi.sendMessage(repository.data.toJson());
    // Restart foreground process
    initialState();
  }

  // Add extra cigarette
  void addExtraCigarette() {
    repository.addExtraCigarette();
  }

  // Select language
  void selectLanguage(int index){
    LanguageEnum lang = LanguageEnum.values[index];
    switch(lang){
      case LanguageEnum.Eng:
        di.localization = LocalizationEn();
        break;
      case LanguageEnum.Rus:
        di.localization = LocalizationRu();
        break;
      case LanguageEnum.Ukr:
        di.localization = LocalizationUk();
        break;
    }
    repository.data.languageIndex = index;
    repository.storeLanguage();
  }

  // Set language
  void setLanguage(int index){
    selectLanguage(index);
    repository.languageIndex = index;
  }

  // Load language
  void loadLanguage(){
    selectLanguage(repository.languageIndex);
  }

  // Handle notification from foreground
  void onForegroundEvent(ForegroundNotification notification) async  {
    receivedEvent.triggerValue = true;
    switch (notification) {
      case ForegroundNotification.nextCigarette:
        // handle 'Can Smoke' event
        foregroundApi.handleOuterNotification(ForegroundNotification.nextCigarette); // reset trigger
        await player.play(AssetSource(audioAsset));
        toNextCigarettePage();
        break;
      case ForegroundNotification.wakeUp:
        // handle 'Wake Up' event
        foregroundApi.handleOuterNotification(ForegroundNotification.wakeUp); // reset trigger
        await player.play(AssetSource(audioAsset));
        toWakeUpPage();
        break;
      case ForegroundNotification.goodNight:
        // handle 'Good night' event
        foregroundApi.handleOuterNotification(ForegroundNotification.goodNight); // reset trigger
        await player.play(AssetSource(audioAsset));
        repository.resetDailyExtraCigaretteCount();
        toGoodNightPage();
        break;
      case ForegroundNotification.finished:
        // 'Finished' event was received
        foregroundApi.stopForegroundTask();
        await player.play(AssetSource(audioAsset));
        toCongratulationsPage();
        break;
    }
  }
}
