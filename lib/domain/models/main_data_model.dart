// Main data class
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
      processState = ProcessState.values[json['processState'] as int];
      extraCigarettesCount = json['extraCigarettesCount'];
      String timeString = json['firstCigaretteTime']; // ??
      firstCigaretteTime = DateTime.parse(timeString);
      print('Process state: $processState');
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
      'processState' : processState.index,
      'extraCigarettesCount' : extraCigarettesCount,
      'firstCigaretteTime' : firstCigaretteTime.toString()
    };
  }
}
