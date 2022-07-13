import 'package:android_long_task/long_task/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twinkle/presentation/pages/homepage.dart';
import 'core/foreground_service_data.dart';
import 'core/notification_api.dart';
import 'core/service_locator.dart';
import 'package:android_long_task/long_task/service_client.dart';

//----------------------------- DI Container -----------------------------------
DIContainer di = DIContainer();

//--------------------------------- Main ---------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI injection
  await di.initDependencies();

  _setScreenOrientation();
  runApp(MyApp());
}

// Set portrait orientation only
void _setScreenOrientation(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
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
