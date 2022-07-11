import 'package:shared_preferences/shared_preferences.dart';

const String DATA_KEY = 'TWINKLE_DATA';

class LocalStorage {
  final SharedPreferences preferences;
  LocalStorage({required this.preferences});

  void storePreferences(String data) {
    preferences.setString(DATA_KEY, data);
  }

  String getPreferences(){
    try{
      String data = preferences.getString(DATA_KEY) ?? '';
      return data;
    }
    catch (e){
      return '';
    }
  }
}