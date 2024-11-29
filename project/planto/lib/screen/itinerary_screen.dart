// lib/screens/itinerary_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식 변환을 위한 패키지
import 'package:planto/model/user_data.dart';
import 'package:planto/screen/add_plan_screen.dart';
import 'package:planto/screen/edit_plan_screen.dart';
import 'package:planto/screen/map_web_screen.dart';
import 'package:planto/screen/route_display_screen.dart';
import '../dto/schedule_response.dart';
import '../model/itiinerary_data.dart';
import '../model/schedule_data.dart';
import '../repository/itiinerary_repository.dart';
import '../repository/recommand_plan.dart';
import '../repository/schedule_repository.dart'; // fetchItinerary 함수 import

class ItineraryScreen extends StatefulWidget {
  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  List itinerary = []; // API로부터 받은 일정 데이터를 저장할 리스트
  bool isLoading = false;

  // 사용자 입력값을 저장할 변수들
  final TextEditingController _locationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? inputStartDate;
  DateTime? inputEndDate;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // 날짜 선택 함수
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // 일정 불러오기 함수
  Future<void> _loadItinerary() async {
    // 필수 입력값 검증
    if (_locationController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // 로그 추가: fetchItinerary 호출 직전까지 실행 여부 확인

    try {
      final Map<String, dynamic> data = await fetchItinerary(
        location: _locationController.text,
        startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
      );
      // print(data);
//       Map<String, dynamic> data = {
//         "id": "3c90c3cc-0d44-4b50-8888-8dd25736052a",
//         "model": "llama-3.1-sonar-small-128k-online",
//         "object": "chat.completion",
//         "created": 1724369245,
//         "choices": [
//           {
//             "index": 0,
//             "finish_reason": "stop",
//             "message": {
//               "role": "assistant",
//               "content": """
//               2024년 11월 1일부터 2024년 11월 2일까지의 여행 일정을 다음과 같이 JSON 형식으로 작성할 수 있습니다:
//               '''
//               {
//   "itinerary": [
//     {
//       "day": "2024-11-01",
//       "activities": [
//         {
//           "place": "Olvera Street",
//           "placeInfo": [34.0449, -118.2335],
//           "startTime": "09:00",
//           "endTime": "12:00",
//           "route": 1,
//           "description": "Explore the historic Mexican marketplace."
//         },
//         {
//           "place": "Hollywood Forever Cemetery",
//           "placeInfo": [34.0784, -118.3285],
//           "startTime": "13:00",
//           "endTime": "16:00",
//           "route": 2,
//           "description": "Visit the final resting place of many Hollywood legends."
//         },
//         {
//           "place": "Griffith Observatory",
//           "placeInfo": [34.1184, -118.3004],
//           "startTime": "17:00",
//           "endTime": null,
//           "route": 3,
//           "description": "Enjoy panoramic views of Los Angeles and the Hollywood Sign."
//         }
//       ]
//     },
//     {
//       "day": "2024-11-02",
//       "activities": [
//         {
//           "place": "Griffith Observatory",
//           "placeInfo": [34.1184, -118.3004],
//           "startTime": "17:00",
//           "endTime": "23:55",
//           "route": 1,
//           "description": "Enjoy panoramic views of Los Angeles and the Hollywood Sign."
//         }
//       ]
//     }
//   ]
// }
//               '''
//               """
// //             },
//             // "delta": {"role": "assistant", "content": ""}
//           }
//         ],
//         "usage": {
//           "prompt_tokens": 14,
//           "completion_tokens": 70,
//           "total_tokens": 84
//         }
//       };
      String content = data['choices'][0]['message']['content'];

      // 중괄호로 시작하는 여러 개의 JSON 블록 추출
      List<String> extractJsonBlocks(String input) {
        List<String> jsonBlocks = [];
        int openBraces = 0;
        int startIndex = -1;

        for (int i = 0; i < input.length; i++) {
          if (input[i] == '{') {
            if (openBraces == 0) {
              startIndex = i;
            }
            openBraces++;
          } else if (input[i] == '}') {
            openBraces--;
            if (openBraces == 0 && startIndex != -1) {
              jsonBlocks.add(input.substring(startIndex, i + 1));
              startIndex = -1; // 다음 JSON 블록을 찾기 위해 초기화
            }
          }
        }

        return jsonBlocks; // 모든 JSON 블록 반환
      }

      List<String> jsonStrings = extractJsonBlocks(content);

      if (jsonStrings.isNotEmpty) {
        for (String jsonString in jsonStrings) {
          try {
            Map<String, dynamic> extractedJson = jsonDecode(jsonString);

            print('Extracted JSON: $extractedJson');
            itinerary = extractedJson['itinerary'];
          } catch (e) {
            print('Error parsing JSON: $e');
          }
        }
      } else {
        print('No valid JSON found in the content.');
      }
      setState(() {
        // API 응답에서 일정 데이터 추출
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching itinerary: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일정 불러오기 중 오류가 발생했습니다.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 일정 추천'),
        // actions: [
        //   // IconButton(
        //   //   icon: Icon(Icons.map),
        //   //   onPressed: () {
        //   //     setState(() {
        //   //       List<Itiinerary> itineraryData = [];
        //   //       for (var dayPlan in itinerary) {
        //   //         for (var activity in dayPlan['activities']) {
        //   //           itineraryData.add(Itiinerary(
        //   //             id: null,
        //   //             scheduleId: 1,
        //   //             place: activity['place'],
        //   //             placeInfo: activity['placeInfo'][0].toString() +
        //   //                 ',' +
        //   //                 activity['placeInfo'][1].toString(),
        //   //             route: activity['route'],
        //   //             startTime: DateFormat('yyyy-MM-dd HH:mm')
        //   //                 .parse('${dayPlan['day']} ${activity['startTime']}'),
        //   //             description: activity['description'],
        //   //           ));
        //   //         }
        //   //       }
        //   //       Navigator.push(
        //   //           context,
        //   //           MaterialPageRoute(
        //   //               builder: (BuildContext context) =>
        //   //                   MapWebScreen(mapData: itineraryData)));
        //   //     });
        //   //   },
        //   // ),
        //   IconButton(
        //       onPressed: () {
        //         List<Itiinerary> itineraryData = [];
        //         for (var dayPlan in itinerary) {
        //           for (var activity in dayPlan['activities']) {
        //             itineraryData.add(Itiinerary(
        //               id: null,
        //               scheduleId: 1,
        //               place: activity['place'],
        //               placeInfo: activity['placeInfo'][0].toString() +
        //                   ',' +
        //                   activity['placeInfo'][1].toString(),
        //               route: activity['route'],
        //               startTime: DateFormat('yyyy-MM-dd HH:mm')
        //                   .parse('${dayPlan['day']} ${activity['startTime']}'),
        //               description: activity['description'],
        //             ));
        //           }
        //         }
        //         var stopOverPlaces = itineraryData
        //             .sublist(1, itineraryData.length - 1)
        //             .map(
        //                 (location) => location.place + "|" + location.placeInfo)
        //             .toList();
        //         var endPlace = itineraryData[itineraryData.length - 1].place +
        //             "|" +
        //             itineraryData[itineraryData.length - 1].placeInfo;
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => RouteDisplayScreen(
        //               startPlace: itineraryData[0].place +
        //                   "|" +
        //                   itineraryData[0].placeInfo,
        //               endPlace: endPlace,
        //               stopOverPlaces: stopOverPlaces,
        //             ),
        //           ),
        //         );
        //       },
        //       icon: Icon(Icons.directions)),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 사용자 입력 필드들
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: '위치'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(_startDate == null
                      ? '시작 날짜 선택'
                      : '시작 날짜: ${DateFormat('yyyy-MM-dd').format(_startDate!)}'),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context, true);
                  }, // 시작 날짜 선택
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_endDate == null
                      ? '종료 날짜 선택'
                      : '종료 날짜: ${DateFormat('yyyy-MM-dd').format(_endDate!)}'),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false), // 종료 날짜 선택
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadItinerary, // 일정 불러오기 버튼
              child: Text('일정 불러오기'),
            ),
            SizedBox(height: 20),

            // 로딩 중일 때 로딩 표시
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: itinerary.length,
                      itemBuilder: (context, index) {
                        final dayPlan = itinerary[index];
                        return ExpansionTile(
                          title: Text(dayPlan['day']),
                          children:
                              dayPlan['activities'].map<Widget>((activity) {
                            return ListTile(
                              title: Text(activity['place']),
                              subtitle: Text(
                                  '${activity['startTime']} - ${activity['endTime']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      try {
                                        // Itiinerary inputActivity = Itiinerary(
                                        //   id: null,
                                        //   scheduleId: 1,
                                        //   place: activity['place'],
                                        //   placeInfo: activity['placeInfo'][0]
                                        //           .toString() +
                                        //       ',' +
                                        //       activity['placeInfo'][1]
                                        //           .toString(),
                                        //   route: activity['route'],
                                        //   startTime: DateFormat(
                                        //           'yyyy-MM-dd HH:mm')
                                        //       .parse(
                                        //           '${dayPlan['day']} ${activity['startTime']}'),
                                        //   description: activity['description'],
                                        // );
                                        // print(inputActivity.placeInfo);
                                        // Edit 화면으로 이동하고 수정된 데이터를 받음
                                        var updatedActivity;
                                        setState(() async {
                                          updatedActivity =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPlanScreen(activity),
                                            ),
                                          );
                                        });

                                        if (updatedActivity != null) {
                                          setState(() {
                                            // 수정된 내용을 반영
                                            activity['place'] =
                                                updatedActivity['place'];
                                            activity['placeInfo'] =
                                                updatedActivity['placeInfo'];
                                            activity['startTime'] =
                                                updatedActivity['startTime'];
                                          });
                                        }
                                      } catch (e) {
                                        print('Error: $e');
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _deleteActivity(index, activity);
                                      });
                                      // 삭제 함수 호출
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // FAB 위치 변경
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              onPressed: () async {
                var newActivity;
                setState(() {
                  newActivity = Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPlanScreen()),
                  );
                });

                if (newActivity != null) {
                  setState(() {
                    _addActivityToItinerary(newActivity);
                  });
                }
              },
              label: Text('일정 추가'),
              icon: Icon(Icons.add),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _addRecommendedItinerary();
                });
              }, // 추천 일정 추가 함수 호출 (구현 필요 시 여기에 추가)
              label: Text('추천 일정 추가'),
              icon: Icon(Icons.recommend),
            ),
          ],
        ),
      ),
    );
  }

  void _addActivityToItinerary(Map<String, String> newActivity) {
    String activityDate = newActivity['date']!;
    String startTime = newActivity['startTime']!;

    setState(() {
      // 해당 날짜가 이미 있는지 확인
      int dayIndex =
          itinerary.indexWhere((dayPlan) => dayPlan['day'] == activityDate);

      if (dayIndex != -1) {
        // 해당 날짜가 있으면 그 날짜의 활동 리스트에 추가
        itinerary[dayIndex]['activities'].add(newActivity);

        // 활동들을 시작 시간 순으로 정렬
        itinerary[dayIndex]['activities']
            .sort((a, b) => a['startTime'].compareTo(b['startTime']));
      } else {
        // 해당 날짜가 없으면 새로운 날짜를 추가하고 활동을 넣음
        itinerary.add({
          'day': activityDate,
          'activities': [newActivity],
        });

        // 날짜 순으로 정렬
        itinerary.sort((a, b) => a['day'].compareTo(b['day']));
      }
    });
  }

  void _deleteActivity(int dayIndex, Map<String, dynamic> activity) {
    setState(() {
      itinerary[dayIndex]['activities'].remove(activity);
    });
  }

  Future<void> _addRecommendedItinerary() async {
    // 필수 입력값 검증
    if (_locationController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Schedule 객체 생성
      Schedule newSchedule = Schedule(
        id: null, // 서버에서 ID를 생성하므로 0 또는 임의의 값 설정
        userId: currentUser, // 실제 사용자 ID로 대체
        title: _locationController.text + ' 여행 일정',
        startTime: DateFormat('yyyy-MM-dd HH:mm').parse(
            DateFormat('yyyy-MM-dd').format(_startDate!).toString() +
                " " +
                itinerary[0]['activities'][0]['startTime']),
        endTime: DateFormat('yyyy-MM-dd HH:mm').parse(DateFormat('yyyy-MM-dd')
                .format(_endDate!) +
            " " +
            itinerary[itinerary.length - 1]['activities']
                    [itinerary[itinerary.length - 1]['activities'].length - 1]
                ['endTime']),
        planFlag: false,
      );
      ScheduleRepository scheduleRepository = new ScheduleRepository();
      // Schedule 추가
      Schedule_Response scheduleResponse =
          await scheduleRepository.addSchedule(newSchedule);

      // Itiinerary 리스트 생성
      List<Itiinerary> itineraries = [];

      for (var dayPlan in itinerary) {
        String day = dayPlan['day'];
        for (var activity in dayPlan['activities']) {
          // // placeInfo에서 위도와 경도 추출
          // List<String> coords = activity['placeInfo'].split(',');
          // double latitude = double.parse(coords[0]);
          // double longitude = double.parse(coords[1]);

          Itiinerary itiinerary = Itiinerary(
            id: null,
            scheduleId: scheduleResponse.id,
            place: activity['place'],
            placeInfo: activity['placeInfo'].join(','),
            route: activity['route'],
            startTime: DateFormat('yyyy-MM-dd HH:mm')
                .parse('$day ${activity['startTime']}'),
            description: activity['description'],
          );

          itineraries.add(itiinerary);
        }
      }
      ItiineraryRepository itiineraryRepository = new ItiineraryRepository();
      // Schedule 추가
      // Itiinerary 추가
      for (Itiinerary itiinerary in itineraries) {
        await itiineraryRepository.addItiinerary(itiinerary);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('추천 일정이 성공적으로 추가되었습니다.')),
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('추천 일정 추가 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('추천 일정 추가 중 오류가 발생했습니다.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
