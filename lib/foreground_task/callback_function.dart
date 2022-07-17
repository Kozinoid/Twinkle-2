import 'dart:convert';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/foreground_task/process_calculations.dart';

// The callback function should always be a top-level function.
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

// Callback handler
class MyTaskHandler extends TaskHandler {
  // Send port
  SendPort? _sendPort;

  // DATA
  late final TwinkleProcessCalculations _processCalculations;

  //-----------------------------  ON START  -----------------------------------
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // ......................  load custom data  ...............................
    final json = await FlutterForegroundTask.getData<String>(key: 'twinkleData');
    final dataModel = TwinkleDataModel()..fromJson(jsonDecode(json!));
    _processCalculations = TwinkleProcessCalculations(dataModel: dataModel);
    // .................  Send initial calculation state  ......................
    // // GET CALCULATION DATA
    // Map<String, dynamic> calculationMap = _processCalculations.getData();
    // // Send some notification data to foreground process
    // _sendPort?.send(jsonEncode(calculationMap));
  }

  //-----------------------------  ON EVENT  -----------------------------------
  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // GET CALCULATION DATA
    Map<String, dynamic> calculationMap = _processCalculations.getData();

    // Time to next smoke in notification
    FlutterForegroundTask.updateService(
        notificationTitle: 'Twinkle',
        notificationText: 'Time to next smoke: ${_processCalculations.timeToNext}' );

    // Send data to the main isolate.
    _sendPort = sendPort;
    // Send some notification data to foreground process
    _sendPort?.send(jsonEncode(calculationMap));
  }

  //----------------------------  ON DESTROY  ----------------------------------
  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  //------------------------  ON BUTTON PRESSED  -------------------------------
  // @override
  // void onButtonPressed(String id) {
  //   // Called when the notification button on the Android platform is pressed.
  //   print('onButtonPressed >> $id');
  // }

  //---------------------  ON NOTIFICATION PRESSED  ----------------------------
  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp('/');
    _sendPort?.send(101);
  }
}
