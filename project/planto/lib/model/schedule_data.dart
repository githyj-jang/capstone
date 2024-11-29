class Schedule {
  final int? id;
  final String userId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool planFlag;

  Schedule({
    this.id,
    required this.userId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.planFlag,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      userId: json['userID'],
      title: json['title'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      planFlag: json['planFlag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userId,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'planFlag': planFlag,
    };
  }
}