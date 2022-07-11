//------------------------- Universal Enum Wrapper  ----------------------------
import 'package:flutter/material.dart';

class MyEnumWrapper<T extends Enum>{
  int _index = 0;           // index of current value
  List<dynamic> list;       // enum values

  // Constructor
  MyEnumWrapper({required this.list, required T initValue}){
    this.value = initValue;
  }

  // value getter
  T get value => list[_index];
  // value setter
  set value (T value) {_index = list.indexOf(value);}
  // index getter
  int get index => _index;
  // index setter
  set index(int index) => _index = index;
  // List of values (List<String>)
  List<String> values = [];
}

//------------------------------- GENDER ---------------------------------------
enum GenderEnum{
  Male,
  Female
}

class Gender extends MyEnumWrapper<GenderEnum>{
  Gender({required GenderEnum initValue})
      : super(list: GenderEnum.values, initValue: initValue);

  @override
  List<String> get values =>
      GenderEnum.values.map((value) => value.toString().split('.')[1]).toList();
}

//-------------------------------- CURRENCY ------------------------------------
enum CurrencyEnum{
  UAH,
  USD,
  EUR,
  RUB
}

class Currency extends MyEnumWrapper<CurrencyEnum>{
  Currency({required CurrencyEnum initValue})
      : super(list: CurrencyEnum.values, initValue:  initValue);

  @override
  List<String> get values =>
      CurrencyEnum.values.map((value) => value.toString().split('.')[1]).toList();
}

//-------------------------- Interface language --------------------------------
enum LanguageEnum{
  Eng,
  Rus,
  Ukr
}

class Language extends MyEnumWrapper<LanguageEnum>{
  Language({required LanguageEnum initValue})
      : super(list:  LanguageEnum.values, initValue: initValue);

  @override
  // TODO: implement values
  List<String> get values =>
      LanguageEnum.values.map((value) => value.toString().split('.')[1]).toList();
}

//--------------------------- Limited int counter ------------------------------
class LimitedIntCounter{

  // counter value
  late int _value = 0;
  int get value => _value;
  set value(int value){_value = value; _validate(); _onChange.call();}

  // counter minimum
  late int _min;
  int get min => _min;

  // counter maximum
  late int _max;
  int get max => _max;

  // callback function
  late void Function() _onChange;

  // Constructor
  LimitedIntCounter({required int value, required int min, required int max}){
    _value = value;
    _min = min;
    _max = max;

    _validate();
  }

  void setOnChange(void Function() onChange){
    _onChange = onChange;
  }

  // Validate data
  void _validate(){
    if (_max < _min) _max = _min;
    if (_value < _min) _value = _min;
    if (_value > _max) _value = _max;
  }

  // Increment counter
  void increment(){
    _value++;
    _validate();
    _onChange.call();
  }

  // Decrement counter
  void decrement(){
    _value--;
    _validate();
    _onChange.call();
  }
}
