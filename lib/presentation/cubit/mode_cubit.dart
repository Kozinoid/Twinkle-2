import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/domain/models/user_data.dart';
import 'package:twinkle/presentation/cubit/states.dart';

class ModeCubit extends Cubit<TwinkleState>{
  ModeCubit({required this.repository}) : super(TwinkleLoadingState());

  final TwinkleDataRepository repository;

  // Load data to repository
  void loadData() async {
    // Show plash screen
    toSplashScreen();

    //print('loading data...');
    repository.loadData();
    await Future.delayed(const Duration(seconds: 3));

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
  void startProcess(){
    repository.startProcess();
    toMainScreen();
  }

  // Reset data -> to Initial Setting screen
  void resetData(){
    repository.resetAllData();
    loadData();
  }

  // End process -> to Congratulations screen
  void endProcess(){
    repository.endProcess();
    toCongratulationsPage();
  }
}