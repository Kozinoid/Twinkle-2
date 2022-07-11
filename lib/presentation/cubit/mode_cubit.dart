import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/presentation/cubit/states.dart';
import 'package:twinkle/domain/models/main_data_model.dart';

class ModeBloc extends Cubit<TwinkleState>{
  ModeBloc({required this.repository}) : super(TwinkleLoadingState());

  final TwinkleDataRepository repository;

  // Load data to repository
  void loadData() async {
    // Show plash screen
    emit(TwinkleLoadingState());
    print('loading data...');
    repository.loadData();
    await Future.delayed(const Duration(seconds: 3));

    if (repository.isStarted) {
      // if process was started early -> to Main screen
      toMainScreen();
    } else {
      // else: -> Initialization page 1.
      emit(TwinkleOnBoardOneState());
    }
  }

  // First settings. Page 1
  void toOnboardPageOne(){
    emit(TwinkleOnBoardOneState());
  }

  // First settings. Page 2
  void toOnboardPageTwo(){
    emit(TwinkleOnBoardTwoState());
  }

  // Start process -> to Main screen
  void startProcess(){
    repository.startProcess();
    toMainScreen();
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

  // Reset data ->
  void resetData(){
    repository.resetAllData();
    loadData();
  }
}