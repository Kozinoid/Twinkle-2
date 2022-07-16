import 'package:flutter/cupertino.dart';
import 'package:twinkle/core/types.dart';
import 'package:equatable/equatable.dart';
import 'package:twinkle/domain/models/time_class.dart';

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

  // Start smoke time today
  DayTime _firstCigaretteTime = DayTime(hours: 7, minutes: 0);
  set firstCigaretteTime(DayTime value) {_firstCigaretteTime = value;}
  DayTime get firstCigaretteTime => _firstCigaretteTime;

  // Finish smoke time today
  DayTime _lastCigaretteTime = DayTime(hours: 23, minutes: 0);
  set lastCigaretteTime(DayTime value) {_lastCigaretteTime = value;}
  DayTime get lastCigaretteTime => _lastCigaretteTime;

  //--------------------------- Calculations -----------------------------------
  // Current day number
  int _currentDay = 0;
  int get currentDay => _currentDay;

  // Today user must smoke minus this count cigarettes
  double _minusCigarettePerDay = 0;
  double get minusCigarettePerDay => _minusCigarettePerDay;

  // Cigarettes, saved today
  int _savedCigarettesToday = 0;
  int get savedCigarettesToday => _savedCigarettesToday;

  // Cigarettes, saved from begin
  int _savedCigarettesFromBegin = 0;
  int get savedCigarettesFromBegin => _savedCigarettesFromBegin;

  // Money, saved from begin
  int _savedMoney = 0;
  int get savedMoney => _savedMoney;

  // Time in percent to stop smoke finish
  int _endOfSmoke = 0;
  int get endOfSmoke => _endOfSmoke;

  // Cigarettes, passed from begin
  int _passedCigarettesFromBegin = 0;
  int get passedCigarettesFromBegin => _passedCigarettesFromBegin;

  // Cigarettes, passed today
  int _totalCigarettesToday = 0;
  int get totalCigarettesToday => _totalCigarettesToday;

  // Cigarettes, smoked by now
  int _smokedByNow = 0;
  int get smokedByNow => _smokedByNow;

  // Interval
  DayTime _interval = DayTime(hours: 1, minutes: 0);
  DayTime get interval => _interval;

  // Time to next smoke
  DayTime _timeToNext = DayTime(hours: 1, minutes: 0);
  DayTime get timeToNext => _timeToNext;

  // Percent to next
  double _percentToNext = 0.75;
  double get percentToNext => _percentToNext;

  //-------------------------------- Process -----------------------------------
  // Registered
  ProcessState _processState = ProcessState.stopped;
  set processState(ProcessState value){_processState = value;}
  ProcessState get processState => _processState;

  // Extra cigarettes count from begin
  int _extraCigarettesCount = 0;
  set extraCigarettesCount(int value) {_extraCigarettesCount = value;}
  int get extraCigarettesCount => _extraCigarettesCount;

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
  int getSavedCigarettes(){
    double sum = 0;
    for (var i = 0; i < _currentDay; i++){
      sum += (i * _minusCigarettePerDay);
    }
    return sum.round();
  }

  // Current State Data
  void calculates(){
    // get current day
    _currentDay = DateTime.now().difference(_registrationDate).inDays;
    // everyday decrease cigarette count
    _minusCigarettePerDay = perDay.value / daysToSmokeBreak.value;

    _savedCigarettesToday = (_currentDay * _minusCigarettePerDay).floor();
    _savedCigarettesFromBegin = getSavedCigarettes() - _extraCigarettesCount;
    _savedMoney = (_savedCigarettesFromBegin * (price.value / 20)).round();
    _endOfSmoke = ((_currentDay / daysToSmokeBreak.value) * 100).round();
    _totalCigarettesToday = perDay.value - _savedCigarettesToday;

    // time between cigarette smoke
    _interval = (_lastCigaretteTime - _firstCigaretteTime) / (_totalCigarettesToday + 1);
    // now
    DateTime _now = DateTime.now();
    DayTime _timeNow = DayTime(hours: _now.hour, minutes: _now.minute);

    if ((_firstCigaretteTime < _timeNow)&&(_timeNow < _lastCigaretteTime)){
      _timeToNext = _interval * (((_timeNow - _firstCigaretteTime) ~/ _interval) + 1) - (_timeNow - _firstCigaretteTime);
      _percentToNext = _timeToNext.inMinutes() / _interval.inMinutes();
    }else{
      _timeToNext = _firstCigaretteTime + DayTime.parse('24:00') - _timeNow;
      _percentToNext = _timeToNext.inMinutes() / (_firstCigaretteTime + DayTime.parse('24:00') - _lastCigaretteTime).inMinutes();
    }
  }

  // Get updates
  void getUpdates(){
    notifyListeners();
  }

  @override
  // TODO: implement props
  List<Object?> get props => [age, _gender, _currency, price, perDay, daysToSmokeBreak, _registrationDate,
     _firstCigaretteTime, _lastCigaretteTime, _passedCigarettesFromBegin, _processState, _interval];
}