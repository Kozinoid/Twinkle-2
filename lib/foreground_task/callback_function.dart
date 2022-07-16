import 'dart:convert';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:twinkle/domain/models/main_data_model.dart';

// The callback function should always be a top-level function.
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

// Callback handler
class MyTaskHandler extends TaskHandler {
  // Send port
  SendPort? _sendPort;

  // Process state
  int _eventCount = 0;

  // DATA
  final TwinkleDataModel _dataModel = TwinkleDataModel();

  //-----------------------------  ON START  -----------------------------------
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // ......................  load custom data  ...............................
    //
    final json = await FlutterForegroundTask.getData<String>(key: 'twinkleData');
    _dataModel.fromJson(jsonDecode(json!));
    print('Data model: ${_dataModel.perDay.value}');
  }

  //-----------------------------  ON EVENT  -----------------------------------
  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
        notificationTitle: 'Twinkle',
        notificationText: 'eventCount: $_eventCount');

    // Next iteration
    _dataModel.calculates();

    // Send data to the main isolate.
    _sendPort = sendPort;
    _sendPort?.send(jsonEncode(_dataModel.toJson()));
    _eventCount++;
  }

  //----------------------------  ON DESTROY  ----------------------------------
  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  //------------------------  ON BUTTON PRESSED  -------------------------------
  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

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
