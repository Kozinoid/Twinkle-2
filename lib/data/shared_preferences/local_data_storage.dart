import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences preferences;
  LocalStorage({required this.preferences});

  void storePreferences(String key, String data) {
    preferences.setString(key, data);
  }

  String getPreferences(String key){
    try{
      String data = preferences.getString(key) ?? '';
      return data;
    }
    catch (e){
      return '';
    }
  }
}