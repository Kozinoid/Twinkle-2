import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twinkle/presentation/pages/homepage.dart';
import 'core/service_locator.dart';
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
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}
