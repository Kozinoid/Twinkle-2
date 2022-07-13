import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //------------------------------  Singleton  ---------------------------------
  NotificationService._internal();

  static final _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  //------------------------  Notification plugin  -----------------------------
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ---------------------------  Initialization  ------------------------------
  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    //Initialization Settings for iOS
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    //initialize timezone package here
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String? payload) async {
      //   await Navigator.push(
      //       context,
      //       route
      //   )
      // }
    );
  }

  //-------------------------  Details  -------------------------
  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    icon: "ic_launcher",
  );

  final IOSNotificationDetails _iOSNotificationDetails =
      const IOSNotificationDetails();

  //-------------------------  SHOW  ---------------------------
  Future<void> showNotifications(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
          android: _androidNotificationDetails, iOS: _iOSNotificationDetails),
      payload: payload,
    );
  }

  //-----------------------  SCHEDULED  -------------------------
  Future<void> scheduledNotifications(
      {required int id,
      required String title,
      required String body,
      required DateTime dateTime,
      required String payload}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        NotificationDetails(
            android: _androidNotificationDetails, iOS: _iOSNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  //-----------------------  DELAYED  -------------------------
  Future<void> delayedNotifications(
      {required int id,
      required String title,
      required String body,
      required Duration delayTime,
      required String payload}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(delayTime),
        NotificationDetails(
            android: _androidNotificationDetails, iOS: _iOSNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  tz.Location getLocal(){
    return tz.local;
  }
}
