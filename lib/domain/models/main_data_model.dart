// Main data class
import 'package:twinkle/domain/models/time_class.dart';
import 'package:twinkle/domain/models/user_data.dart';

class TwinkleDataModel extends UserData{
  TwinkleDataModel() : super();

  void fromJson(Map<String, dynamic> json){
      age.value = json['age'];
      genderIndex = json['gender'];
      currencyIndex = json['currency'];
      price.value = json['price'];
      perDay.value = json['perDay'];
      daysToSmokeBreak.value = json['timeForSmokeBreak'];
      registrationDate = DateTime.parse(json['registrationDate']);
      String firstTimeString = json['firstCigaretteTime']; // ??
      wakeUpTime = DayTime.parse(firstTimeString);
      String lastTimeString = json['lastCigaretteTime']; // ??
      goodNightTime = DayTime.parse(lastTimeString);
  }

  Map<String, dynamic> toJson(){
    return {
      'age' : age.value,
      'gender' : gender.index,
      'currency' : currency.index,
      'price' : price.value,
      'perDay' : perDay.value,
      'timeForSmokeBreak' : daysToSmokeBreak.value,
      'registrationDate' : registrationDate.toString(),
      'firstCigaretteTime' : wakeUpTime.toString(),
      'lastCigaretteTime' : goodNightTime.toString()
    };
  }
}
