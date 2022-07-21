import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/foreground_task/data/process_calculation_data.dart';

class StatisticsCalculator{
  final TwinkleDataModel data;
  final TwinkleTimeCalculationData calculationData;
  late final int currentDay;
  late double minusCigarettePerDay;

  StatisticsCalculator({required this.data, required this.calculationData}){
    currentDay = DateTime.now().difference(data.registrationDate).inDays;
    minusCigarettePerDay =
        data.maxPerDay.value / data.daysToSmokeBreak.value;
  }

  int get percentToFinish => (currentDay / data.daysToSmokeBreak.value).round();
  int get passedCigarettesFromStart {
    int count = 0;
    for (int i = 0; i < currentDay; i++)
      {
        // Max cigarette count today
        int totalCigarettesToday =
            ((data.daysToSmokeBreak.value - currentDay) * minusCigarettePerDay)
                .ceil();
        count += totalCigarettesToday;
      }
    return count + calculationData.passedCigarettesToday + data.extraCigaretteCount;
  }
}