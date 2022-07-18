import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di_container.dart';

//******************************************************************************
//*                               APP SIDE                                     *
//******************************************************************************

//----------------------------- DI Container -----------------------------------
DIContainer di = DIContainer();

//--------------------------------- Main ---------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI injection
  await di.initDependencies();

  // Screen orientation - Portrait only
  _setScreenOrientation();

  // Main App
  runApp(const MyApp());
}

// Set portrait orientation only
void _setScreenOrientation() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

//--------------------------------- App ----------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: di.homePage,
    );
  }
}
