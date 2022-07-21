import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twinkle/data/repository/twinkle_data_repository.dart';
import 'package:twinkle/data/shared_preferences/local_data_storage.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/foreground_task/data/process_calculation_data.dart';
import 'package:twinkle/presentation/cubit/mode_cubit.dart';

import '../foreground_task/foreground_api.dart';
import '../presentation/pages/homepage.dart';

class DIContainer{
  late SharedPreferences preferences;
  late LocalStorage storage;
  late TwinkleDataModel data;
  late TwinkleTimeCalculationData calculationData;
  late TwinkleDataRepository repository;
  late ModeCubit cubit;
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

      calculationData = TwinkleTimeCalculationData.empty();
      print('calculation data - ok');

      repository = TwinkleDataRepository(data: data, storage: storage);
      print('repository - ok');

      api = ForegroundApi(calculationData: calculationData );
      print('Add lifecycle observer');
      WidgetsBinding.instance.addObserver(homePage);

      cubit = ModeCubit(repository: repository, foregroundApi: api)..initialState();
      print('cubit - ok');

      // Init Notification API
      api.initForegroundTask(cubit.onForegroundEvent);
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