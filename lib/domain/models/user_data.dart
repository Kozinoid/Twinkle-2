import 'package:flutter/cupertino.dart';
import 'package:twinkle/core/types.dart';
import 'package:equatable/equatable.dart';
import 'package:twinkle/domain/models/time_class.dart';

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
  DateTime registrationDate = DateTime.now();

  // Start smoke time today
  DayTime wakeUpTime = DayTime(hours: 7, minutes: 0);

  // Finish smoke time today
  DayTime goodNightTime = DayTime(hours: 23, minutes: 0);

  // Extra cigarette count
  int _extraCigaretteCount = 0;
  int get extraCigaretteCount => _extraCigaretteCount;
  set extraCigaretteCount(int value) {
    _extraCigaretteCount = value;
    notifyListeners();
  }

  // Equatable override
  @override
  List<Object?> get props => [age, _gender, _currency, price, perDay, daysToSmokeBreak, registrationDate,
    wakeUpTime, goodNightTime, _extraCigaretteCount];
}