import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/data/shared_preferences/local_data_storage.dart';
import 'package:twinkle/domain/models/main_data_model.dart';

import '../foreground_task/foreground_api.dart';
import '../presentation/pages/homepage.dart';
import '../presentation/pages/main_process.dart';

class DIContainer{
  late SharedPreferences preferences;
  late LocalStorage storage;
  late TwinkleDataModel data;
  late TwinkleDataRepository repository;
  late ForegroundApi api;

  // ambiguity
  T? ambiguity<T>(T? value) => value;
  // main page
  MyHomePage homePage = const MyHomePage();

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

      api = ForegroundApi(data);
      print('Add lifecycle observer');
      WidgetsBinding.instance.addObserver(homePage);
      api.initForegroundTask();
      ambiguity(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
        // You can get the previous ReceivePort without restarting the service.
        if (await FlutterForegroundTask.isRunningService) {
          final newReceivePort = await FlutterForegroundTask.receivePort;
          api.registerReceivePort(newReceivePort);
        }
      });
    });
  }
}