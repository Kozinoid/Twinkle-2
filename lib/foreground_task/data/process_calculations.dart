import 'package:twinkle/domain/models/main_data_model.dart';

import 'process_calculation_data.dart';
import '../../domain/models/day_time_class.dart';

class TwinkleProcessCalculations {
  TwinkleProcessCalculations({required this.dataModel}) {
    // Minus cigarette per day (double!)
    minusCigarettePerDay =
        dataModel.maxPerDay.value / dataModel.daysToSmokeBreak.value;
  }

  TwinkleDataModel dataModel;

  double minusCigarettePerDay = 0; // Minus per EVERY DAY
  DayTime timeToNext = DayTime.empty(); // Time to next smoke
  double percentToNext = 0; // Percentage of process
  int totalCigarettesToday = 0; // Max cigarettes today
  int passedCigarettesToday = 0; // Passed up to current time
  bool isSmokeTime = false;
  bool isFinished = false;
  bool isWakeUp = false;
  bool isGoodNight = false;

  void loadJson(Map<String, dynamic> map){
    dataModel.fromJson(map);
  }

  // Time calculation
  Map<String, dynamic> getData() {
    // Current day
    DateTime now = DateTime.now();
    // Current time
    DayTime timeNow = DayTime(hours: now.hour, minutes: now.minute);
    // get current day
    int currentDay = now.difference(dataModel.registrationDate).inDays;

    // Max cigarette count today
    totalCigarettesToday =
        ((dataModel.daysToSmokeBreak.value - currentDay) * minusCigarettePerDay)
            .ceil();

    // Time between cigarette smoke
    DayTime interval = (dataModel.goodNightTime - dataModel.wakeUpTime) /
        (totalCigarettesToday + 1);

    // First cigarette time
    DayTime firstCigaretteTime = dataModel.wakeUpTime + interval;

    // Last cigarette time
    DayTime lastCigaretteTime = dataModel.goodNightTime - interval;

    // Next cigarette time
    DayTime nextTime;

    if ((dataModel.wakeUpTime < timeNow) && (timeNow < lastCigaretteTime)) {
      passedCigarettesToday = (timeNow - dataModel.wakeUpTime) ~/ interval;
      nextTime = interval * (passedCigarettesToday + 1) + dataModel.wakeUpTime;
      timeToNext = nextTime - timeNow;
      percentToNext = timeToNext.inMinutes() / interval.inMinutes();
    } else if (timeNow >= lastCigaretteTime) {
      passedCigarettesToday = totalCigarettesToday;
      nextTime = dataModel.wakeUpTime + interval;
      timeToNext = nextTime + DayTime.parse('24:00') - timeNow;
      percentToNext = timeToNext.inMinutes() /
          (nextTime + DayTime.parse('24:00') - lastCigaretteTime).inMinutes();
    } else {
      //if (dataModel.wakeUpTime >= timeNow)
      passedCigarettesToday = 0;
      nextTime = dataModel.wakeUpTime + interval;
      timeToNext = nextTime - timeNow;
      percentToNext = timeToNext.inMinutes() /
          (nextTime + DayTime.parse('24:00') - dataModel.goodNightTime)
              .inMinutes();
    }

    isSmokeTime = false;
    if ((firstCigaretteTime <= timeNow) && (timeNow <= lastCigaretteTime)) {
      // if it's time to smoke
      if ((timeNow - dataModel.wakeUpTime) % interval == DayTime.empty()) {
        // Send 'Can smoke'
        isSmokeTime = true;
      }
    }

    if (timeNow == dataModel.wakeUpTime) {
      // Send 'Good morning!'
      isWakeUp = true;
    } else {
      isWakeUp = false;
    }

    if (timeNow == dataModel.goodNightTime) {
      // Send 'Good night!'
      isGoodNight = true;
    } else {
      isGoodNight = false;
    }

    return TwinkleTimeCalculationData(
            timeToNext: timeToNext,
            percentToNext: percentToNext,
            totalCigarettesToday: totalCigarettesToday,
            passedCigarettesToday: passedCigarettesToday,
            isSmokeTime: isSmokeTime,
            isFinished: isFinished,
            isWakeUp: isWakeUp,
            isGoodNight: isGoodNight)
        .toJson();
  }
}
