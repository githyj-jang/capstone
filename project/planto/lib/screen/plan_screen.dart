import 'package:flutter/material.dart';

import '../model/plan_data.dart';
import 'package:intl/intl.dart';

import 'plan_detail_screen.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {


  static List<DateTime> start = [
    DateTime.utc(2024, 5, 1),
    DateTime.utc(2024, 5, 1),
    DateTime.utc(2024, 5, 3),
    DateTime.utc(2024, 5, 5),
  ];
  static List<DateTime> end = [
    DateTime.utc(2024, 5, 1),
    DateTime.utc(2024, 5, 1),
    DateTime.utc(2024, 5, 3),
    DateTime.utc(2024, 5, 5),
  ];
  static List<String> startTime = [
    "22:00",
    "10:00",
    "16:00",
    "13:00",
  ];
  static List<String> endTime = [
    "24:00",
    "12:00",
    "20:00",
    "15:00",
  ];

  static List<String> eventName = [
    "프로젝트 회의",
    "운동하기",
    "밥 약속",
    "독서",
  ];
  static List<String> eventLocationStart = [
    "온라인",
    "서울과학기술대학교 불암학사",
    "서울과학기술대학교 불암학사",
    "서울과학기술대학교 불암학사",
  ];
  static List<String> eventLocationEnd = [
    "온라인",
    "3PM 복싱 앤 휘트니스",
    "버거투버거, since 2011",
    "서울과학기술대학교 불암학사",
  ];

  final List<Plan> planData =  List.generate(start.length,
          (index) => Plan(start:start[index],end : end[index],startTime:startTime[index],endTime: endTime[index],eventName: eventName[index],eventLocationStart: eventLocationStart[index],eventLocationEnd: eventLocationEnd[index], routeEnd: 'routeEnd', routeStart: 'routeStart', planFlag: ''));
  List<Plan> _displayedPlanData = [];

  // 여기에 검색 로직을 구현하세요.
  void _performSearch(String query) {
    if (query.isEmpty) {
      _displayedPlanData = List.from(planData);
    } else {
      _displayedPlanData = planData
          .where((friend) =>
      friend.eventName.toLowerCase().contains(query.toLowerCase()) ||
          friend.eventName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _displayedPlanData = List.from(planData);
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _displayedPlanData.length,
      itemBuilder: (context, index) {
        return SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
          child: Card(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context)=>PlanDetailScreen(plan:_displayedPlanData[index])));
              },
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          formatDateTime(_displayedPlanData[index].start),
                          style:
                          const TextStyle(fontSize: 20),
                        ),
                        if(_displayedPlanData[index].start != _displayedPlanData[index].end)
                          Text(
                            " ~ ",
                            style:
                            const TextStyle(fontSize: 20),
                          ),
                        if(_displayedPlanData[index].start != _displayedPlanData[index].end)
                          Text(
                            formatDateTime(_displayedPlanData[index].end),
                            style:
                            const TextStyle(fontSize: 20),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          _displayedPlanData[index].startTime,
                          style:
                          const TextStyle(fontSize: 20),
                        ),
                        Text(
                          " ~ ",
                          style:
                          const TextStyle(fontSize: 20),
                        ),
                        Text(
                          _displayedPlanData[index].endTime,
                          style:
                          const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Text(
                      _displayedPlanData[index].eventName,
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text(
                          _displayedPlanData[index].eventLocationStart,
                          style:
                          const TextStyle(fontSize: 20),
                        ),
                        if(_displayedPlanData[index].eventLocationStart != _displayedPlanData[index].eventLocationEnd)
                          Text(
                            " ~ ",
                            style:
                            const TextStyle(fontSize: 20),
                          ),
                        if(_displayedPlanData[index].eventLocationStart != _displayedPlanData[index].eventLocationEnd)
                          Text(
                            _displayedPlanData[index].eventLocationEnd,
                            style:
                            const TextStyle(fontSize: 20),
                          ),

                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
