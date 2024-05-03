import 'package:flutter/material.dart';

class Plan{
  final DateTime start;
  final DateTime end;
  final String startTime;
  final String endTime;
  final String eventName;
  final String eventLocationStart;
  final String eventLocationEnd;

  Plan(this.start, this.end, this.startTime, this.endTime, this.eventName, this.eventLocationStart,this.eventLocationEnd);

}