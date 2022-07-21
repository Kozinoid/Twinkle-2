// Main data class
import 'package:twinkle/domain/models/day_time_class.dart';
import 'package:twinkle/domain/models/main_data.dart';

class TwinkleDataModel extends UserData{
  TwinkleDataModel() : super();

  void fromJson(Map<String, dynamic> json){
      age.value = json['age'] ?? 20;
      genderIndex = json['gender'] ?? 0;
      currencyIndex = json['currency'] ?? 0;
      price.value = json['price'] ?? 70;
      maxPerDay.value = json['perDay'] ?? 20;
      daysToSmokeBreak.value = json['timeForSmokeBreak'] ?? 90;
      registrationDate = DateTime.parse(json['registrationDate'] ?? DateTime.now());
      String firstTimeString = json['firstCigaretteTime'] ?? '07:00';
      wakeUpTime = DayTime.parse(firstTimeString);
      String lastTimeString = json['lastCigaretteTime'] ?? '23:00';
      goodNightTime = DayTime.parse(lastTimeString);
      extraCigaretteCount = json['extraCigaretteCount'] ?? 0;
      extraCigaretteTodayCount = json['extraCigaretteTodayCount'] ?? 0;
  }

  Map<String, dynamic> toJson(){
    return {
      'age' : age.value,
      'gender' : gender.index,
      'currency' : currency.index,
      'price' : price.value,
      'perDay' : maxPerDay.value,
      'timeForSmokeBreak' : daysToSmokeBreak.value,
      'registrationDate' : registrationDate.toString(),
      'firstCigaretteTime' : wakeUpTime.toString(),
      'lastCigaretteTime' : goodNightTime.toString(),
      'extraCigaretteCount' : extraCigaretteCount,
      'extraCigaretteTodayCount' : extraCigaretteTodayCount
    };
  }
}
