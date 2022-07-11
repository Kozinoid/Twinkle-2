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
      started = json['started'];
      extraCigarettesCount = json['extraCigarettesCount'];
      String timeString = json['firstCigaretteTime']; // ??
      print('timeString: $timeString');
      firstCigaretteTime = DateTime.parse(timeString);
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
      'started' : started,
      'extraCigarettesCount' : extraCigarettesCount,
      'firstCigaretteTime' : firstCigaretteTime.toString()
    };
  }
}
