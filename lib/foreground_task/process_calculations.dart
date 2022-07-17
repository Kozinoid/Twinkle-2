import 'package:twinkle/domain/models/main_data_model.dart';

import '../domain/models/time_calculation_data.dart';
import '../domain/models/time_class.dart';

class TwinkleProcessCalculations{
  TwinkleProcessCalculations({required this.dataModel}){
    // Minus cigarette per day (double!)
    minusCigarettePerDay = dataModel.perDay.value / dataModel.daysToSmokeBreak.value;
  }
  TwinkleDataModel dataModel;
  double minusCigarettePerDay = 0;
  DayTime timeToNext = DayTime.empty();   // Time to next smoke
  double percentToNext = 0; // Percentage of process
  bool isSmokeTime = false;
  bool isFinished = false;

  // Time calculation
  Map<String, dynamic> getData(){
    // Current day
    DateTime now = DateTime.now();
    // Current time
    DayTime timeNow = DayTime(hours: now.hour, minutes: now.minute);
    // get current day
    int currentDay = now.difference(dataModel.registrationDate).inDays;

    // Cigarette count, saved today
    int savedCigarettesPerDay = (currentDay * minusCigarettePerDay).floor();

    // Cigarette count, passed today
    int totalCigarettesToday = dataModel.perDay.value - savedCigarettesPerDay;

    // time between cigarette smoke
    DayTime interval = (dataModel.goodNightTime - dataModel.wakeUpTime) / (totalCigarettesToday + 1);

    if ((dataModel.wakeUpTime < timeNow)&&(timeNow < dataModel.goodNightTime)){
      timeToNext = interval * (((timeNow - dataModel.wakeUpTime) ~/ interval) + 1) - (timeNow - dataModel.wakeUpTime);
      percentToNext = timeToNext.inMinutes() / interval.inMinutes();
    }else{
      timeToNext = dataModel.wakeUpTime + DayTime.parse('24:00') - timeNow;
      percentToNext = timeToNext.inMinutes() / (dataModel.wakeUpTime + DayTime.parse('24:00') - dataModel.goodNightTime).inMinutes();
    }

    return TwinkleTimeCalculationData(timeToNext: timeToNext, percentToNext: percentToNext, isSmokeTime: false, isFinished: false).toJson();
  }
}