import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/plan_data.dart';
import '../model/map_data.dart';
import 'map_web_screen.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static List<DateTime> start = [
    DateTime.utc(2024, 5, 1),
    DateTime.utc(2024, 5, 3),
    DateTime.utc(2024, 5, 10),
    DateTime.utc(2024, 5, 20),
    DateTime.utc(2024, 5, 23),
  ];
  static List<DateTime> end = [
    DateTime.utc(2024, 5, 1),
    DateTime.utc(2024, 5, 3),
    DateTime.utc(2024, 5, 11),
    DateTime.utc(2024, 5, 21),
    DateTime.utc(2024, 5, 28),
  ];
  static List<String> startTime = [
    "10:00",
    "16:00",
    "07:00",
    "07:00",
    "14:00",
  ];
  static List<String> endTime = [
    "12:00",
    "20:00",
    "24:00",
    "10:00",
    "24:00",
  ];

  static List<String> eventName = [
    "운동하기",
    "밥 약속",
    "제주도 여행",
    "울릉도 여행",
    "강원도 여행",
  ];
  static List<String> eventLocationStart = [
    "서울과학기술대학교 불암학사",
    "서울과학기술대학교 불암학사",
    "이스턴호텔제주",
    "아라호텔",
    "원경펜션",
  ];
  static List<String> eventLocationEnd = [
    "3PM 복싱 앤 휘트니스",
    "버거투버거, since 2011",
    "협재해변",
    "내수전 일출전망대",
    "발왕산 관광케이블카",
  ];
  static List<String> mapLocationStart = [
    "14146056.2506796,4528180.5334094,서울과학기술대학교불암학사,18642120,PLACE_POI",
    "14146056.2506796,4528180.5334094,서울과학기술대학교불암학사,18642120,PLACE_POI",
    "14084150.0124322,3929115.417801,이스턴호텔제주,1744448811,PLACE_POI",
    "14572780.5609263,4508042.4705256,아라호텔,1634331181,PLACE_POI",
    "14292390.7084405,4510794.4047985,휴원경펜션,11448804,PLACE_POI",
  ];
  static List<String> mapLocationEnd = [
    "14146768.6397609,4529814.8556527,3PM%20복싱%20앤%20휘트니스,450122793,PLACE_POI",
    "14145898.0211554,4528281.380416,버거투버거,20899942,PLACE_POI",
    "14052960.2725988,3947761.3946837,협재해수욕장,11491807,PLACE_POI",
    "14572808.5243824,4510754.6188346,내수전일출전망대,15932109,PLACE_POI",
    "14324471.7277769,4529267.1570634,발왕산%20관광케이블카,1934048912,PLACE_POI",
  ];

  final List<Plan> planData =  List.generate(start.length,
          (index) => Plan(scheduleId: index,start:start[index],end : end[index],startTime:startTime[index],endTime: endTime[index],eventName: eventName[index],eventLocationStart: eventLocationStart[index],eventLocationEnd: eventLocationEnd[index], routeEnd: 'routeEnd', routeStart: 'routeStart', planFlag: false));

  final List<MapData> mapData =  List.generate(mapLocationStart.length,
          (index) => MapData(mapLocationStart[index],mapLocationEnd[index]));


  List<Plan> _displayedPlanData = [];

  List<MapData> _displayedMapData = [];
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
    _displayedMapData = List.from(mapData);
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _displayedMapData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){

          },
          child: Card(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context)=>MapWebScreen(mapData:_displayedMapData[index])));
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
                        Text(
                          " ~ ",
                          style:
                          const TextStyle(fontSize: 20),
                        ),
                        Text(
                          formatDateTime(_displayedPlanData[index].end),
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
                        Text(
                          " ~ ",
                          style:
                          const TextStyle(fontSize: 20),
                        ),
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

