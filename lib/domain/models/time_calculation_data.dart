import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:twinkle/domain/models/time_class.dart';

class TwinkleTimeCalculationData extends Equatable with ChangeNotifier {
  TwinkleTimeCalculationData(
      {required this.timeToNext,
      required this.percentToNext,
      required this.totalCigarettesToday,
      required this.isSmokeTime,
      required this.isFinished,
      required this.isWakeUp,
      required this.isGoodNight});

  DayTime timeToNext; // Time to next smoke
  double percentToNext; // Percentage of process
  int totalCigarettesToday;
  bool isSmokeTime;
  bool isFinished;
  bool isWakeUp;
  bool isGoodNight;

  factory TwinkleTimeCalculationData.empty() {
    return TwinkleTimeCalculationData(
        timeToNext: DayTime.empty(),
        percentToNext: 0,
        totalCigarettesToday: 0,
        isSmokeTime: false,
        isFinished: false,
        isWakeUp: false,
        isGoodNight: false);
  }

  void updateConsumers() {
    notifyListeners();
  }

  //----------------------------- Data exchange --------------------------------
  void fromJson(Map<String, dynamic> map) {
    timeToNext = DayTime.fromJson(map['timeToNext']);
    percentToNext = map['percentToNext'];
    totalCigarettesToday = map['totalCigarettesToday'];
    isSmokeTime = map['isSmokeTime'];
    isFinished = map['isFinished'];
    isWakeUp = map['isWakeUp'];
    isGoodNight = map['isGoodNight'];
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'timeToNext': timeToNext.toJson(),
      'percentToNext': percentToNext,
      'totalCigarettesToday' : totalCigarettesToday,
      'isSmokeTime': isSmokeTime,
      'isFinished': isFinished,
      'isWakeUp': isWakeUp,
      'isGoodNight': isGoodNight
    };
  }

  // Equatable override
  @override
  // TODO: implement props
  List<Object?> get props =>
      [timeToNext, percentToNext, isSmokeTime, isFinished, totalCigarettesToday];
}
