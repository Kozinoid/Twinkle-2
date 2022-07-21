import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:twinkle/domain/models/main_data_model.dart';
import 'package:twinkle/domain/models/time_calculation_data.dart';
import '../domain/models/foreground_notifications.dart';
import 'callback_function.dart';

class ForegroundApi {
  // Receive port
  ReceivePort? receivePort;

  // Send port
  SendPort? sendPort;

  // Initial data
  TwinkleTimeCalculationData calculationData;

  // Notification callback
  late void Function(ForegroundNotification notification) onNotification;

  // //------------- Notification flags ------------
  // // can smoke
  // NotificationTrigger smokeTime = NotificationTrigger();
  // // wake up
  // NotificationTrigger wakeUpTime = NotificationTrigger();
  // // good night
  // NotificationTrigger goodNightTime = NotificationTrigger();
  // // finish
  // NotificationTrigger finishTime = NotificationTrigger();
  // //---------------------------------------------

  // Constructor
  ForegroundApi({required this.calculationData});

  // Process status
  Future<bool> get isRunning async =>
      await FlutterForegroundTask.isRunningService;

  //-----------------------  INIT FOREGROUND TASK  -----------------------------
  // Future<void> initForegroundTask(BuildContext context) async {
  Future<void> initForegroundTask(
      void Function(ForegroundNotification) handler) async {
    onNotification = handler;
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        // buttons: [
        //   const NotificationButton(id: 'sendButton', text: 'Send'),
        //   const NotificationButton(id: 'testButton', text: 'Test'),
        // ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 1000,
        // <------------------------------- Set interval 1 minute
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

  //-----------------------  START FOREGROUND TASK  ----------------------------
  Future<bool> startForegroundTask(TwinkleDataModel data) async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }

    // ........................  save custom data  .............................
    await FlutterForegroundTask.saveData(
        key: 'twinkleData', value: jsonEncode(data.toJson()));

    bool reqResult;
    if (await FlutterForegroundTask.isRunningService) {
      reqResult = await FlutterForegroundTask.restartService();
    } else {
      reqResult = await FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }

    ReceivePort? rPort;
    if (reqResult) {
      rPort = await FlutterForegroundTask.receivePort;
    }
    return registerReceivePort(rPort);
  }

  //-----------------------  STOP FOREGROUND TASK  -----------------------------
  Future<bool> stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }

  //----------------------  REGISTER RECEIVE PORT  -----------------------------
  bool registerReceivePort(ReceivePort? rPort) {
    closeReceivePort();
    print('Open receive port');
    if (rPort != null) {
      receivePort = rPort;
      rPort.listen(_listenCallback);
      return true;
    }
    return false;
  }

  //--------------------------  LISTEN CALLBACK  -------------------------------
  void _listenCallback(message) {
      if (message is SendPort){
        // get send port from callback side
        sendPort = message;
        //print('Foreground: Send port was received!');
      } else if (message is String) {

      // Get data from callback function & Update UI
      calculationData.fromJson(jsonDecode(message));

      //----------------------- Is Smoke Time ? -----------------------
      if (calculationData.isSmokeTime){
        onNotification(ForegroundNotification.nextCigarette);
      }

      //--------------------- Is Wake Up Time ? ----------------------
      if (calculationData.isWakeUp){
        onNotification(ForegroundNotification.wakeUp);
      }

      //------------------- Is Good Night Time ? --------------------
      if (calculationData.isGoodNight){
        onNotification(ForegroundNotification.goodNight);
      }

      //---------------------- Is Finished ? -----------------------
      if (calculationData.isFinished){
        onNotification(ForegroundNotification.finished);
      }

    } else if (message is int) {
      print('notify: $message');
      sendMessage('main -> callback: $message');
    }
  }

  //-----------------------  CLOSE RECEIVE PORT  -------------------------------
  void closeReceivePort() {
    receivePort?.close();
    receivePort = null;
    print('Close receive port');
  }

  //---------------------  HANDLE OUTER NOTIFICATION  --------------------------
  void handleOuterNotification(ForegroundNotification notification){
    sendMessage(notification.index);
  }

  //----------------  Send message to the callback side  -----------------------
  void sendMessage(message){
    if (sendPort != null){
      sendPort?.send(message);
    }
  }
}
