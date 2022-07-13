import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twinkle/presentation/pages/homepage.dart';
import 'core/foreground_service_data.dart';
import 'core/notification_service.dart';
import 'core/service_locator.dart';
import 'package:android_long_task/long_task/service_client.dart';

//----------------------------- DI Container -----------------------------------
DIContainer di = DIContainer();

//--------------------------------- Main ---------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI injection
  await di.initDependencies();

  // Notification service in main
  await NotificationService().init();
  print('notification service - ok');

  // Screen orientation - Portrait only
  _setScreenOrientation();

  // Main App
  runApp(MyApp());
}

// Set portrait orientation only
void _setScreenOrientation() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

//--------------------------------- App ----------------------------------------
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

//--------------------------  Foreground process  ------------------------------
@pragma('vm:entry-point')
serviceMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  //---------------- Create process callback --------------
  ServiceClient.setExecutionCallback(processCallBack);
}

//---------------------------- Process callback --------------------------------
Future<void> processCallBack(initialData) async {
  // Get initial state
  var serviceData = AppServiceData.fromJson(initialData);

  // Init notification service in foreground process
  await NotificationService().init();
  print('notification service in process - ok');

  //----------------------  Scheduled notification  ----------------------------
  NotificationService().delayedNotifications(
      id: 1,
      title: 'Andrew',
      body: 'Alarm!',
      payload: 'Payload',
      delayTime: const Duration(seconds: 5)
  );

  // ------------------- Main loop ------------------
  for (var i = 0;; i++) {
    serviceData.data.calculates();

    // --------------- Update data -------------------
    // if (i % 3 == 0) {
    //   NotificationService().showNotifications(
    //       id: 1,
    //       title: 'You can smoke after',
    //       body: '$i minutes',
    //       payload: 'Payload');
    // }

    await ServiceClient.update(serviceData);

    // ----------- End of process condition ----------
    if (i > 10) {
      // ------------- Successful done! --------------
      NotificationService().showNotifications(
          id: 1,
          title: 'Congratulations!',
          body: 'You are not smoker!',
          payload: 'Payload');

      await ServiceClient.endExecution(serviceData);
      var result = await ServiceClient.stopService();
      // ---------------------------------------------
    }

    // ------------------ Interval -------------------
    await Future.delayed(const Duration(seconds: 1));
  }
}
