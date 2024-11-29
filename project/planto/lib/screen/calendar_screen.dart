import 'package:flutter/material.dart';
import 'package:planto/common/dataTransfom.dart';
import 'package:planto/model/itiinerary_data.dart';
import 'package:planto/model/user_data.dart';
import 'package:planto/repository/itiinerary_repository.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:planto/model/schedule_data.dart';
import 'package:planto/repository/schedule_repository.dart';




class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _preparedEvents = {};
  Map<DateTime, Color> _eventColors = {};

  ScheduleRepository scheduleRepository = ScheduleRepository();
  ItiineraryRepository itiineraryRepository = ItiineraryRepository();

  



  @override
  void initState() {
    super.initState();
    setState(() {
      _prepareEvents();
    });
    
  }

  void _prepareEvents() async{

    List<Schedule> data = await scheduleRepository.getSchedulesByUserID(currentUser);
    List<Itiinerary> itineraries = await itiineraryRepository.getItiinerariesByUserID(currentUser);
    Map<List<DateTime>, List<String>> events = transformSchedules(data, itineraries);
    

    _preparedEvents = {};
    _eventColors = {};
  


    events.forEach((dates, events) {
      DateTime start = dates[0];
      DateTime end = dates[1];
      Color color = events.length > 1 ? Colors.red : Colors.blue;
      for (DateTime day = start;
      day.isBefore(end.add(Duration(days: 1)));
      day = day.add(Duration(days: 1))) {
        if (!_preparedEvents.containsKey(day)) {
          _preparedEvents[day] = [];
        }
        _preparedEvents[day]?.addAll(events);
        _eventColors[day] = color;
      }
    });
  }
  void showPopup(context, start, end, startTime, endTime, eventName, eventSite,description) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(eventName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBox(height: 16),
                Text("시작 시간: $startTime"),
                Text("종료 시간: $endTime"),
                Text("장소: $eventSite"),
                if (description.isNotEmpty) Text("설명: $description"), // description 표시
                
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          TableCalendar(
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  List<String> eventStrings = events.cast<String>();
                  bool isMultipleDays = eventStrings.any((event) => event.contains('여행'));// 예시: '여행'이 포함된 이벤트는 여러 날짜에 걸친 것으로 가정
                  return Positioned(
                    child: isMultipleDays
                        ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: _eventColors[date] ?? Colors.blue,
                      ),
                    )
                        : Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _eventColors[date] ?? Colors.blue,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            eventLoader: (day) {
              return _preparedEvents[day] ?? [];
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

          ),
          ..._getEventsForDay(_selectedDay).map((event)
          =>  GestureDetector(
            onTap: (){
              // 이벤트 문자열을 공백 두 칸을 기준으로 분할
              List<String> eventDetails = event.split('  ');
              // 분할된 문자열에서 각 정보 추출
              String start = eventDetails[0];
              String end = eventDetails[1];
              String eventName = eventDetails[2];
              String eventSite = eventDetails.length > 3 ? eventDetails[3] : ''; // 장소 정보가 없는 경우를 대비해 기본값 설정
              String description = eventDetails.length > 4 ? eventDetails[4] : ''; // 설명 정보가 없는 경우를 대비해 기본값 설정

              // 추출한 정보를 showPopup 함수에 전달
              showPopup(context, _selectedDay, _selectedDay, start, end, eventName, eventSite, description);
            },
            child: Card(
              child: ListTile(
                title: Text( event.split('  ')[2]),
                subtitle: Text( event.split('  ')[0]+"~"+event.split('  ')[1]),
              ),
            ),
          )),
        ],
      );
  }

  List<String> _getEventsForDay(DateTime? day) {
    // _events를 _preparedEvents로 변경
    return _preparedEvents[day] ?? [];
  }


}
