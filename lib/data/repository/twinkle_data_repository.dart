import 'dart:convert';
import 'package:twinkle/data/shared_preferences/local_data_storage.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/domain/repository/data_repository.dart';

import '../../domain/models/user_data.dart';

class TwinkleDataRepository extends TwinkleRepository{
  TwinkleDataRepository({required this.data, required this.storage});

  // Main data
  final TwinkleDataModel data;
  final LocalStorage storage;
  ProcessState get processState => data.processState;

  //-------------------------- TREE MAIN CASES ---------------------------------
  // Start process
  void startProcess(){
    data.startDataState();
    storeData();
  }

  // Reset All Data
  void resetAllData(){
    data.resetDataState();
    storeData();
  }

  // End process
  void endProcess(){
    data.congratulationDataState();
    storeData();
  }

  //---------------------------- OVERRIDES -------------------------------------
  @override
  void loadData() {
    String loadedData =  storage.getPreferences();
    //print('loaded string: $loadedData');
    if (loadedData != ''){
      //print('process fromJson');
      data.fromJson(json.decode(loadedData));
    }else{
      //print('keep default data');
    }
  }

  @override
  void storeData(){
    //print('storing data');
    storage.storePreferences(json.encode(data.toJson()));
  }
}