import 'dart:convert';
import 'package:android_long_task/android_long_task.dart';
import '../domain/models/main_data_model.dart';

class AppServiceData with ServiceData {
  AppServiceData({required this.data});

  TwinkleDataModel data;

  @override
  String get notificationTitle => 'You can smoke after';  // Next cigarette

  @override
  String get notificationDescription => '${data.currentDay}';  // Progress

  @override
  String toJson() {
    var map = data.toJson();
    return jsonEncode(map);
  }

  factory AppServiceData.fromJson(Map<String, dynamic> json) {
    return AppServiceData(data: TwinkleDataModel()..fromJson(json));
  }

}