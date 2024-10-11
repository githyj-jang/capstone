import 'package:planto/model/itiinerary_data.dart';
import 'package:planto/model/plan_data.dart';
import 'package:planto/model/schedule_data.dart';

Map<List<DateTime>, List<String>> transformSchedules(
    List<Schedule> schedules, List<Itiinerary> itineraries) {
  
  // 1. Itiinerary 데이터를 scheduleId로 그룹화
  Map<int, List<Itiinerary>> itineraryMap = {};
  for (var itinerary in itineraries) {
    if (!itineraryMap.containsKey(itinerary.scheduleId)) {
      itineraryMap[itinerary.scheduleId] = [];
    }
    itineraryMap[itinerary.scheduleId]!.add(itinerary);
  }

  // 2. Schedule 데이터를 날짜 범위별로 그룹화
  Map<String, List<Schedule>> groupedSchedules = {};

  for (var schedule in schedules) {
    // 날짜만 추출하여 키 생성 (YYYY-MM-DD_YYYY-MM-DD)
    String key =
        '${schedule.startTime.toUtc().toIso8601String().split('T')[0]}_${schedule.endTime.toUtc().toIso8601String().split('T')[0]}';
    if (!groupedSchedules.containsKey(key)) {
      groupedSchedules[key] = [];
    }
    groupedSchedules[key]!.add(schedule);
  }

  // 3. 최종 events 맵 생성
  Map<List<DateTime>, List<String>> events = {};

  groupedSchedules.forEach((key, schedules) {
    var dates = key.split('_');
    List<DateTime> dateRange = [
      DateTime.parse(dates[0]).toUtc(),
      DateTime.parse(dates[1]).toUtc()
    ];

    List<String> eventDetails = schedules.map((schedule) {
      // 시간 포맷팅
      String start = '${schedule.startTime.toUtc().hour.toString().padLeft(2, '0')}:${schedule.startTime.toUtc().minute.toString().padLeft(2, '0')}';
      String end = '${schedule.endTime.toUtc().hour.toString().padLeft(2, '0')}:${schedule.endTime.toUtc().minute.toString().padLeft(2, '0')}';
      
      // Itinerary 데이터 조회 및 location 생성
      String location = "";
      if (itineraryMap.containsKey(schedule.id)) {
        List<Itiinerary> relatedItineraries = itineraryMap[schedule.id]!;

        // route 순으로 정렬
        relatedItineraries.sort((a, b) => a.route.compareTo(b.route));

        if (relatedItineraries.length >= 2) {
          String startPlace = relatedItineraries.first.place;
          String endPlace = relatedItineraries.last.place;
          location = '$startPlace ~ $endPlace';
        } else if (relatedItineraries.length == 1) {
          location = relatedItineraries.first.place;
        }
      } else {
        // Itinerary 데이터가 없는 경우 planFlag를 활용하여 장소 결정
        location = '온라인';
      }
      

      return '$start  $end  ${schedule.title}  $location';
    }).toList();

    events[dateRange] = eventDetails;
  });

  return events;
}

List<Plan> createPlans(List<Schedule> schedules, List<Itiinerary> itineraries) {
  // 1. Itiinerary 데이터를 scheduleId로 그룹화
  Map<int, List<Itiinerary>> itineraryMap = {};
  for (var itinerary in itineraries) {
    if (!itineraryMap.containsKey(itinerary.scheduleId)) {
      itineraryMap[itinerary.scheduleId] = [];
    }
    itineraryMap[itinerary.scheduleId]!.add(itinerary);
  }

  // 2. 각 Schedule을 Plan으로 변환
  List<Plan> plans = schedules.map((schedule) {
    // 시간 포맷팅
    String startTime = '${schedule.startTime.toUtc().hour.toString().padLeft(2, '0')}:${schedule.startTime.toUtc().minute.toString().padLeft(2, '0')}';
    String endTime = '${schedule.endTime.toUtc().hour.toString().padLeft(2, '0')}:${schedule.endTime.toUtc().minute.toString().padLeft(2, '0')}';

    // Itiinerary 데이터 조회 및 장소 설정
    String eventLocationStart = '';
    String eventLocationEnd = '';
    String routeStart = '';
    String routeEnd = '';

    if (itineraryMap.containsKey(schedule.id)) {
      List<Itiinerary> relatedItineraries = itineraryMap[schedule.id]!;

      // route 순으로 정렬
      relatedItineraries.sort((a, b) => a.route.compareTo(b.route));

      if (relatedItineraries.isNotEmpty) {
        eventLocationStart = relatedItineraries.first.place;
        eventLocationEnd = relatedItineraries.last.place;
        routeStart = relatedItineraries.first.place;
        routeEnd = relatedItineraries.last.place;
      }
      
    }

    return Plan(
      scheduleId: schedule.id,
      start: schedule.startTime,
      end: schedule.endTime,
      startTime: startTime,
      endTime: endTime,
      eventName: schedule.title,
      eventLocationStart: eventLocationStart,
      eventLocationEnd: eventLocationEnd,
      routeStart: routeStart,
      routeEnd: routeEnd,
      planFlag: schedule.planFlag ,
    );
  }).toList();

  return plans;
}