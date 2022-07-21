import 'dart:convert';
import 'package:twinkle/data/shared_preferences/local_data_storage.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/domain/repository/data_repository.dart';

import '../../foreground_task/process_state.dart';

const String DATA_KEY = 'TWINKLE_DATA';
const String PROCESS_KEY = 'TWINKLE_PROCESS';
const String EXTRA_KEY = 'TWINKLE_EXTRA';

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
    data.registrationDate = DateTime.now();
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
    String loadedData =  storage.getPreferences(DATA_KEY);
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
    String loadedData =  storage.getPreferences(PROCESS_KEY);
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
}