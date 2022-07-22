import 'package:flutter/cupertino.dart';
import 'package:twinkle/core/types.dart';
import 'package:equatable/equatable.dart';
import 'package:twinkle/domain/models/day_time_class.dart';

class UserData extends Equatable with ChangeNotifier {
  // Constructor
  UserData(){
    // Set onChange handlers for all fields
    age.setOnChange((){notifyListeners();});
    price.setOnChange(() {notifyListeners();});
    maxPerDay.setOnChange(() {notifyListeners();});
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

  // User language
  final Language _language = Language(initValue: LanguageEnum.Eng);
  set languageIndex (int index){_language.index = index; notifyListeners();}
  Language get language => _language;

  // Price of 20 cigarettes
  LimitedIntCounter price = LimitedIntCounter(value: 50, min: 1, max: 1000);

  // Cigarette count per day
  LimitedIntCounter maxPerDay = LimitedIntCounter(value: 20, min: 1, max: 100);

  // How fast user wants to stop smoking
  LimitedIntCounter daysToSmokeBreak = LimitedIntCounter(value: 90, min: 1, max: 1000);

  // Registration date
  DateTime registrationDate = DateTime.now();
  String get registrationDateString {
    String year = '${registrationDate.year}';
    String month = '${registrationDate.month}'.padLeft(2, '0');
    String day = '${registrationDate.day}'.padLeft(2, '0');
    return '$day.$month.$year';
  }

  // Wake up time today
  DayTime _wakeUpTime = DayTime(hours: 7, minutes: 0);
  DayTime get wakeUpTime => _wakeUpTime;
  set wakeUpTime(DayTime value) {
    //_wakeUpTime = value;
    _validateByWakeUpTime(value);
    notifyListeners();
  }

  // Good night time today
  DayTime _goodNightTime = DayTime(hours: 23, minutes: 0);
  DayTime get goodNightTime => _goodNightTime;
  set goodNightTime(DayTime value) {
    //_goodNightTime = value;
    _validateByGoodNightTime(value);
    notifyListeners();
  }

  // Extra cigarette count
  int _extraCigaretteCount = 0;
  int get extraCigaretteCount => _extraCigaretteCount;
  set extraCigaretteCount(int value) {
    _extraCigaretteCount = value;
    notifyListeners();
  }

  // Extra cigarette TODAY count
  int _extraCigaretteTodayCount = 0;
  int get extraCigaretteTodayCount => _extraCigaretteCount;
  set extraCigaretteTodayCount(int value) {
    _extraCigaretteTodayCount = value;
    notifyListeners();
  }

  // Validate
  //  ... by wake up time
  void _validateByWakeUpTime(DayTime value){
    // If dialog result = ok (null - cancel)
    // Wake up time must be < 23:00, min differance between wake up and good night - 1 hour
    if (value >= DayTime(hours: 23, minutes: 0)) {
      value = DayTime(
          hours: 22, minutes: 59); // max wake up time
    }
    DayTime time = _goodNightTime;
    _wakeUpTime = value;
    if (time - value < DayTime.oneHour()) {
      //... min differance between wake up and good night - 1 hour
      time = value + DayTime.oneHour();
    }
    _goodNightTime = time;
  }

  // ... by good night time
  void _validateByGoodNightTime(DayTime value){
    // Good night time must be > 01:00, min differance between wake up and good night - 1 hour
    if (value < DayTime(hours: 1, minutes: 0)) {
      value = DayTime(
          hours: 1, minutes: 0); // min good night time
    }
    DayTime time = _wakeUpTime;
    _goodNightTime = value;
    if (value - time < DayTime.oneHour()) {
      //... min differance between wake up and good night - 1 hour
      time = value - DayTime.oneHour();
    }
    _wakeUpTime = time;
  }

  // Equatable override
  @override
  List<Object?> get props => [age, _gender, _currency, price, maxPerDay, daysToSmokeBreak, registrationDate,
    wakeUpTime, goodNightTime, _extraCigaretteCount, _extraCigaretteTodayCount];
}