import 'dart:ffi';

class Schedule_Response {
  final int id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool planFlag;

  Schedule_Response({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.planFlag,
  });

  factory Schedule_Response.fromJson(Map<String, dynamic> json) {
    return Schedule_Response(
      id: json['id'],
      title: json['title'],
      
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      planFlag: json['planFlag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'planFlag': planFlag,
    };
  }
}