import 'package:flutter/cupertino.dart';
import 'package:twinkle/core/types.dart';
import 'package:equatable/equatable.dart';

// Main States Enum
enum ProcessState{
  stopped,
  started,
  ended
}

class UserData extends Equatable with ChangeNotifier {
  // Constructor
  UserData(){
    // Set onChange handlers for all fields
    age.setOnChange((){notifyListeners();});
    price.setOnChange(() {notifyListeners();});
    perDay.setOnChange(() {notifyListeners();});
    daysToSmokeBreak.setOnChange(() {notifyListeners();});
  }

  //------------------------ Registration data ---------------------------------
  // User age
  LimitedIntCounter age = LimitedIntCounter(value: 20, min: 18, max: 120);

  // User gender
  final Gender _gender = Gender(initValue: GenderEnum.Male);
  set genderIndex (int index) {_gender.index = index; notifyListeners();}
  Gender get gender => _gender;

  // User currency
  final Currency _currency = Currency(initValue: CurrencyEnum.UAH);
  set currencyIndex (int index){_currency.index = index; notifyListeners();}
  Currency get currency => _currency;

  // Price of 20 cigarettes
  LimitedIntCounter price = LimitedIntCounter(value: 50, min: 1, max: 1000);

  // Cigarette count per day
  LimitedIntCounter perDay = LimitedIntCounter(value: 20, min: 1, max: 100);

  // How fast user wants to stop smoking
  LimitedIntCounter daysToSmokeBreak = LimitedIntCounter(value: 90, min: 1, max: 1000);

  // Registration date
  DateTime _registrationDate = DateTime.now();
  set registrationDate(DateTime value) => _registrationDate = value;
  DateTime get registrationDate => _registrationDate;

  //--------------------------- Calculations -----------------------------------
  // Current day number
  int _currentDay = 0;
  int get currentDay => _currentDay;

  // Today user must smoke minus this count cigarettes
  double _minusCigarettePerDay = 0;
  double get minusCigarettePerDay => _minusCigarettePerDay;

  // Cigarettes, passed today
  int _passedCigarettesToday = 0;
  int get passedCigarettesToday => _passedCigarettesToday;

  // Cigarettes, passed from begin
  int _passedCigarettesFromBegin = 0;
  int get passedCigarettesFromBegin => _passedCigarettesFromBegin;

  // Money, passed from begin
  int _passedMoney = 0;
  int get passedMoney => _passedMoney;

  // Time in percent to stop smoke finish
  int _endOfSmoke = 0;
  int get endOfSmoke => _endOfSmoke;

  //-------------------------------- Process -----------------------------------
  // Registered
  ProcessState _processState = ProcessState.stopped;
  set processState(ProcessState value){_processState = value;}
  ProcessState get processState => _processState;

  // Extra cigarettes count from begin
  int _extraCigarettesCount = 0;
  set extraCigarettesCount(int value) {_extraCigarettesCount = value;}
  int get extraCigarettesCount => _extraCigarettesCount;

  // First cigarette time today
  DateTime _firstCigaretteTime = DateTime.parse('2022-07-05 07:00:00.905401');
  set firstCigaretteTime(DateTime value) {_firstCigaretteTime = value;}
  DateTime get firstCigaretteTime => _firstCigaretteTime;

  //------------------------------ Methods -------------------------------------
  // Store user data
  void startDataState(){
    // store registration date
    _registrationDate = DateTime.now();
    _extraCigarettesCount = 0;
    _processState = ProcessState.started;
  }

  // Reset all data
  void resetDataState(){
    _processState = ProcessState.stopped;
  }

  // CongratulationDataState
  void congratulationDataState(){
    _processState = ProcessState.ended;
  }

  // Calculate passed cigarettes
  int getPassedCigarettes(){
    double sum = 0;
    for (var i = 0; i < _currentDay; i++){
      sum += (i * _minusCigarettePerDay);
    }
    return sum.round();
  }

  // Current State Data
  void calculates(){
    _currentDay = DateTime.now().difference(_registrationDate).inDays;
    _minusCigarettePerDay = perDay.value / daysToSmokeBreak.value;
    _passedCigarettesToday = (_currentDay * _minusCigarettePerDay).floor();
    _passedCigarettesFromBegin = getPassedCigarettes() - _extraCigarettesCount;
    _passedMoney = (_passedCigarettesFromBegin * (price.value / 20)).round();
    _endOfSmoke = ((_currentDay / daysToSmokeBreak.value) * 100).round();
    //notifyListeners();
  }

  // Get updates
  void getUpdates(){
    notifyListeners();
  }

  @override
  // TODO: implement props
  List<Object?> get props => [age, _gender, _currency, price, perDay, daysToSmokeBreak, _registrationDate,
    _currentDay, _minusCigarettePerDay, _passedCigarettesToday, _passedCigarettesFromBegin, _passedMoney, _endOfSmoke,
    _processState, _extraCigarettesCount, _firstCigaretteTime];
}