import 'package:flutter/material.dart';

class Plan{
  final int scheduleId;
  final DateTime start;
  final DateTime end;
  final String startTime;
  final String endTime;
  final String eventName;
  final String eventLocationStart;
  final String eventLocationEnd;
  final String routeStart;
  final String routeEnd;
  final bool planFlag;

  Plan({required this.scheduleId,required this.start,required this.end,required this.startTime,required this.endTime,required this.eventName,required this.eventLocationStart,required this.eventLocationEnd, required this.routeEnd, required this.routeStart,required this.planFlag});
  factory Plan.fromJson(Map<String, dynamic> json) {

    DateTime tempStartDate = DateTime.parse(json['startTime']);
    DateTime tempEndDate = DateTime.parse(json['startTime']);
    // 'endTime'의 시간 부분만 추출합니다.
    String tempStartTime = "${tempStartDate.hour.toString().padLeft(2, '0')}:${tempStartDate.minute.toString().padLeft(2, '0')}";
    String tempEndTime = "${tempEndDate.hour.toString().padLeft(2, '0')}:${tempEndDate.minute.toString().padLeft(2, '0')}";
    return Plan(
      scheduleId: json['scheduleId'],
      start: tempStartDate,
      end: tempEndDate,
      startTime: tempStartTime,
      endTime: tempEndTime,
      eventName: json['explanation'],
      eventLocationStart: json['startPlace'],
      eventLocationEnd: json['endPlace'],
      routeStart: json['startRoute'],
      routeEnd: json['endRoute'],
        planFlag: json['planFlag']
    );
  }
}