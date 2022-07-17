import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:twinkle/domain/models/time_class.dart';

class TwinkleTimeCalculationData extends Equatable with ChangeNotifier {
  TwinkleTimeCalculationData(
      {required this.timeToNext,
      required this.percentToNext,
      required this.isSmokeTime,
      required this.isFinished});

  DayTime timeToNext; // Time to next smoke
  double percentToNext; // Percentage of process
  bool isSmokeTime;
  bool isFinished;

  factory TwinkleTimeCalculationData.empty(){
    return TwinkleTimeCalculationData(timeToNext: DayTime.empty(), percentToNext: 0, isSmokeTime: false, isFinished: false);
  }

  void updateCunsumers(){
    notifyListeners();
  }

  //----------------------------- Data exchange --------------------------------
  void fromJson(Map<String, dynamic> map) {
    timeToNext = DayTime.fromJson(map['timeToNext']);
    percentToNext =  map['percentToNext'];
    isSmokeTime = map['isSmokeTime'];
    isFinished = map['isFinished'];
  }

  Map<String, dynamic> toJson() {
    return {
      'timeToNext': timeToNext.toJson(),
      'percentToNext': percentToNext,
      'isSmokeTime': isSmokeTime,
      'isFinished': isFinished
    };
  }

  // Equatable override
  @override
  // TODO: implement props
  List<Object?> get props => [timeToNext, percentToNext, isSmokeTime, isFinished];
}
