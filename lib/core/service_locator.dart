import 'package:shared_preferences/shared_preferences.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/data/shared_preferences/local_data_storage.dart';
import 'package:twinkle/domain/models/main_data_model.dart';

import 'foreground_service_data.dart';
import 'notification_service.dart';

class DIContainer{
  late SharedPreferences preferences;
  late LocalStorage storage;
  late TwinkleDataModel data;
  late TwinkleDataRepository repository;

  Future<void> initDependencies()  {
    return Future(()async{
      preferences = await SharedPreferences.getInstance();
      print('preferences - ok');
      storage = LocalStorage(preferences: preferences);
      print('storage - ok');
      data = TwinkleDataModel();
      print('data - ok');
      repository = TwinkleDataRepository(data: data, storage: storage);
      print('repository - ok');
    });
  }
}