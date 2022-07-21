import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:twinkle/domain/models/day_time_class.dart';

class TwinkleTimeCalculationData extends Equatable with ChangeNotifier {
  TwinkleTimeCalculationData(
      {required this.timeToNext,
      required this.percentToNext,
      required this.totalCigarettesToday,
      required this.passedCigarettesToday,
      required this.isSmokeTime,
      required this.isFinished,
      required this.isWakeUp,
      required this.isGoodNight});

  DayTime timeToNext; // Time to next smoke
  double percentToNext; // Percentage of process
  int totalCigarettesToday; // Max cigarettes today
  int passedCigarettesToday; // Passed up to current time
  bool isSmokeTime;
  bool isFinished;
  bool isWakeUp;
  bool isGoodNight;

  factory TwinkleTimeCalculationData.empty() {
    return TwinkleTimeCalculationData(
        timeToNext: DayTime.empty(),
        percentToNext: 0,
        totalCigarettesToday: 0,
        passedCigarettesToday: 0,
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
    passedCigarettesToday = map['passedCigarettesToday'];
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
      'totalCigarettesToday': totalCigarettesToday,
      'passedCigarettesToday': passedCigarettesToday,
      'isSmokeTime': isSmokeTime,
      'isFinished': isFinished,
      'isWakeUp': isWakeUp,
      'isGoodNight': isGoodNight
    };
  }

  // Equatable override
  @override
  List<Object?> get props => [
        timeToNext,
        percentToNext,
        totalCigarettesToday,
        passedCigarettesToday,
        isSmokeTime,
        isWakeUp,
        isGoodNight,
        isFinished
      ];
}
