import 'dart:convert';
import 'package:twinkle/data/shared_preferences/local_data_storage.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/domain/repository/data_repository.dart';

import '../../foreground_task/process_state.dart';

const String DATA_KEY = 'TWINKLE_DATA';
const String PROCESS_KEY = 'TWINKLE_PROCESS';
const String LANGUAGE_KEY = 'TWINKLE_LANGUAGE';

class TwinkleDataRepository extends TwinkleRepository{
  TwinkleDataRepository({required this.data, required this.storage});

  // Main data
  final TwinkleDataModel data;
  final LocalStorage storage;

  // Process State
  ProcessState _processState = ProcessState.started;
  ProcessState get processState{
    loadProcessState();
    return _processState;
  }
  set processState(ProcessState value){
    _processState = value;
    storeProcessState();
  }

  // Language
  int get languageIndex{
    loadLanguage();
    return data.language.index;
  }
  set languageIndex (int index) {
    data.languageIndex = index;
    storeLanguage();
  }

  //--------------------------- TWO MAIN CASES ---------------------------------
  // Reset All Data
  void resetAllData(){
    processState = ProcessState.stopped;
    data.extraCigaretteCount = 0;
    data.extraCigaretteTodayCount = 0;
    storeData();
  }

  // Start process
  void startProcess(){
    processState = ProcessState.started;
    data.extraCigaretteCount = 0;
    data.extraCigaretteTodayCount = 0;
    DateTime now = DateTime.now();
    data.registrationDate = DateTime(now.year, now.month, now.day); // It registration date hours = 0, minutes = 0 etc.
    storeData();
  }

  // Restart process
  void restartProcess(){
    processState = ProcessState.started;
    storeData();
  }

  //--------------------------  CHANGE DATA  -----------------------------------
  void addExtraCigarette(){
    data.extraCigaretteCount++;
    data.extraCigaretteTodayCount++;
    storeData();
  }

  //----------------  RESET DAILY EXTRA CIGARETTE COUNT  -----------------------
  void resetDailyExtraCigaretteCount(){
    data.extraCigaretteTodayCount = 0;
    storeData();
  }

  //-----------------------  CHANGE INITIAL DATA  ------------------------------
  void changeInitialData(){
    storeData();
  }

  //---------------------------- OVERRIDES -------------------------------------
  //------------- DATA -------------
  @override
  void loadData() {
    String loadedData = storage.getPreferences(DATA_KEY);
    if (loadedData != ''){
      data.fromJson(json.decode(loadedData));
    }
  }

  @override
  void storeData(){
    storage.storePreferences(DATA_KEY, json.encode(data.toJson()));
  }

  //----------- PROCESS ------------
  @override
  void loadProcessState() {
    String loadedData = storage.getPreferences(PROCESS_KEY);
    if (loadedData != ''){
      final loadedJson = json.decode(loadedData);
      _processState = ProcessState.values[loadedJson['processState'] as int];
    }else{
      _processState = ProcessState.stopped;
    }
  }

  @override
  void storeProcessState() {
    storage.storePreferences(PROCESS_KEY, json.encode(
      {
        'processState' : _processState.index
      }
    ));
  }

  //------------ LANGUAGE ------------
  @override
  void loadLanguage() {
    String loadedData = storage.getPreferences(LANGUAGE_KEY);
    if (loadedData != ''){
      final loadedJson = json.decode(loadedData);
      data.languageIndex = loadedJson['language'] as int;
    }else{
      data.languageIndex = 0;
    }
  }

  @override
  void storeLanguage() {
    storage.storePreferences(LANGUAGE_KEY, json.encode(
        {
          'language' : data.language.index
        }
    ));
  }


}