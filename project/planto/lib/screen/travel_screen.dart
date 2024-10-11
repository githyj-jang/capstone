import 'package:flutter/material.dart';
import 'package:planto/common/dataTransfom.dart';
import 'package:planto/model/itiinerary_data.dart';
import 'package:planto/model/plan_data.dart';
import 'package:planto/model/schedule_data.dart';
import 'package:planto/model/user_data.dart';
import 'package:planto/repository/itiinerary_repository.dart';
import 'package:planto/repository/schedule_repository.dart';
import 'package:planto/screen/travel_detail_screen.dart';

import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}
class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {

  // static List<DateTime> start = [
  //   DateTime.utc(2024, 5, 10),
  //   DateTime.utc(2024, 5, 20),
  //   DateTime.utc(2024, 5, 23),
  // ];
  // static List<DateTime> end = [
  //   DateTime.utc(2024, 5, 11),
  //   DateTime.utc(2024, 5, 21),
  //   DateTime.utc(2024, 5, 28),
  // ];
  // static List<String> startTime = [
  //   "07:00",
  //   "07:00",
  //   "14:00",
  // ];
  // static List<String> endTime = [
  //   "24:00",
  //   "10:00",
  //   "24:00",
  // ];

  // static List<String> eventName = [
  //   "제주도 여행",
  //   "울릉도 여행",
  //   "강원도 여행",
  // ];
  // static List<String> eventLocationStart = [
  //   "이스턴호텔제주",
  //   "아라호텔",
  //   "휴원경펜션",
  // ];
  // static List<String> eventLocationEnd = [
  //   "협재해수욕장",
  //   "내수전 일출전망대",
  //   "발왕산 관광케이블카",
  // ];

   List<Plan> planData = [];
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

  ScheduleRepository scheduleRepository = ScheduleRepository();
  ItiineraryRepository itiineraryRepository = ItiineraryRepository();
  _prepareEvents() async{
    List<Schedule> data = await scheduleRepository.getSchedulesByUserIDAndPlanFlag(currentUser, false);
    List<Itiinerary> itineraries = await itiineraryRepository.getItiinerariesByUserID(currentUser);
    planData = createPlans(data, itineraries);
    print(planData.length);

  }

  @override
  void initState() {
    super.initState();
    _prepareEvents().then((_) {
      setState(() {
        _displayedPlanData = List.from(planData);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _displayedPlanData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){

          },
          child: Card(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context)=>TravelDetailScreen(travel:_displayedPlanData[index])));
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
                    Row(
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
