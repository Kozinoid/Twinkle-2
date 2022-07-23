import 'dart:convert';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/foreground_task/data/process_calculations.dart';

import '../notification_service/foreground_notifications.dart';
import '../notification_service/notification_flag.dart';
import '../notification_service/notification_service.dart';

// The callback function should always be a top-level function.
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

// Callback handler
class MyTaskHandler extends TaskHandler {
  // Send port
  SendPort? _sendPort;

  // Receive port
  ReceivePort? _receivePort;

  // DATA
  late final TwinkleProcessCalculations _processCalculations;

  //------------- Notification flags ------------
  // can smoke
  NotificationDualTrigger smokeTime = NotificationDualTrigger();

  // wake up
  NotificationDualTrigger wakeUpTime = NotificationDualTrigger();

  // good night
  NotificationDualTrigger goodNightTime = NotificationDualTrigger();

  // finish
  //NotificationDualTrigger finishTime = NotificationDualTrigger();
  //---------------------------------------------

  //-----------------------------  ON START  -----------------------------------
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    //                          < get send port >
    _sendPort = sendPort;

    //                      < Init notifications >
    await NotificationService().init();

    //                       < load custom data >
    final json =
        await FlutterForegroundTask.getData<String>(key: 'twinkleData');
    final dataModel = TwinkleDataModel()..fromJson(jsonDecode(json!));
    _processCalculations = TwinkleProcessCalculations(dataModel: dataModel);

    //                  < Create stream to foreground >
    // create receive port
    _receivePort = ReceivePort();
    // subscribe for listen messages from the main process side
    _receivePort?.listen(_listenCallback);

    // Send Receive port
    await sendReceivePortToBackground();
  }

  //----------------  Listen for main process side messages  -------------------
  void _listenCallback(message) {
    if (message is int) {
      //print('RECEIVE FROM MAIN: $message');
      ForegroundNotification notification =
          ForegroundNotification.values[message];
      switch (notification) {
        case ForegroundNotification.nextCigarette:
          smokeTime.outerHandle();
          break;
        case ForegroundNotification.wakeUp:
          wakeUpTime.outerHandle();
          break;
        case ForegroundNotification.goodNight:
          goodNightTime.outerHandle();
          break;
        case ForegroundNotification.finished:
          // finishTime.outerHandle();
          break;
      }
    } else if (message is Map<String, dynamic>) {
      //print('JSON: $message');
      _processCalculations.loadJson(message);
    }
    // else{
    //   print('RECEIVED FROM MAIN: $message');
    // }
  }

  //-----------------------------  ON EVENT  -----------------------------------
  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    //            < Send port to foreground every iteration >
    // Send data to the main isolate.
    _sendPort = sendPort;
    // Send Receive port
    await sendReceivePortToBackground();

    //        < Send some notification data to foreground process >
    // GET CALCULATION DATA
    Map<String, dynamic> calculationMap = _processCalculations.getData();

    // Time to next smoke in notification
    FlutterForegroundTask.updateService(
        notificationTitle: 'Twinkle',
        notificationText:
            'Time to next smoke: ${_processCalculations.timeToNext}');

    // Handle callback notifications
    handleCallbackNotifications();

    // Refresh outer handle statuses
    calculationMap['isSmokeTime'] = smokeTime.outerIsNotHandled;
    calculationMap['isWakeUp'] = wakeUpTime.outerIsNotHandled;
    calculationMap['isGoodNight'] = goodNightTime.outerIsNotHandled;

    // Send some notification data to foreground process
    _sendPort?.send(jsonEncode(calculationMap));
  }

  // Send 'SendPort' to foreground
  Future<void> sendReceivePortToBackground(){

    return Future(()async{
      await Future.delayed(const Duration(milliseconds: 200));

      if (_sendPort == null){
        print('Callback: _sendPort = null');
      } else  if (_receivePort == null){
        print('Callback: _receivePort = null');
      } else if (_receivePort?.sendPort == null){
        print('Callback: _receivePort?.sendPort = null');
      } else {
        print('Callback: sending _receivePort?.sendPort to foreground');
        _sendPort?.send(_receivePort?.sendPort);
      }
    });

  }

  //----------------------------  ON DESTROY  ----------------------------------
  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    _receivePort?.close();
    _receivePort = null;
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

  //--------------------  HANDLE CALLBACK NOTIFICATIONS  -----------------------
  void handleCallbackNotifications() {
    //----------------------- Is Smoke Time ? -----------------------
    smokeTime.triggerValue = _processCalculations.isSmokeTime;
    if (smokeTime.innerIsNotHandled) {
      NotificationService().showNotifications(
          id: 1, title: 'Twinkle', body: 'It\' smoke time.', payload: '');
      smokeTime.innerHandle();
    }
    //_processCalculations.isSmokeTime = smokeTime.outerIsNotHandled;

    //--------------------- Is Wake Up Time ? ----------------------
    wakeUpTime.triggerValue = _processCalculations.isWakeUp;
    if (wakeUpTime.innerIsNotHandled) {
      NotificationService().showNotifications(
          id: 2, title: 'Twinkle', body: 'Good morning!', payload: '');
      wakeUpTime.innerHandle();
    }
    //_processCalculations.isWakeUp = wakeUpTime.outerIsNotHandled;

    //------------------- Is Good Night Time ? --------------------
    goodNightTime.triggerValue = _processCalculations.isGoodNight;
    if (goodNightTime.innerIsNotHandled) {
      NotificationService().showNotifications(
          id: 3, title: 'Twinkle', body: 'Good night!', payload: '');
      goodNightTime.innerHandle();
    }
    //_processCalculations.isGoodNight = goodNightTime.outerIsNotHandled;

    //---------------------- Is Finished ? -----------------------
    // finishTime.triggerValue = _processCalculations.isFinished;
    // if (finishTime.innerIsNotHandled){
    //   NotificationService().showNotifications(id: 4, title: 'Twinkle', body: 'Congratulations!!!', payload: '');
    //   finishTime.innerHandle();
    // }
    //_processCalculations.isFinished = finishTime.outerIsNotHandled;
    //-------------------------------------------------------------
  }
}
