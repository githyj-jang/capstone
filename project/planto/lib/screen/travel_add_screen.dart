import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planto/dto/schedule_response.dart';
import 'package:planto/model/google_map.dart';
import 'package:planto/model/itiinerary_data.dart';
import 'package:planto/model/schedule_data.dart';
import 'package:planto/model/user_data.dart';
import 'package:planto/repository/itiinerary_repository.dart';
import 'package:planto/repository/schedule_repository.dart';
import 'package:planto/screen/map_web_screen.dart';
import 'package:planto/screen/places_search_screen.dart';
import 'package:planto/screen/route_display_screen.dart';

class TravelAddScreen extends StatefulWidget {
  const TravelAddScreen({super.key});

  @override
  State<TravelAddScreen> createState() => _TravelAddScreenState();
}

class _TravelAddScreenState extends State<TravelAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _planNameController = TextEditingController();
  final _startPlaceController = TextEditingController();
  late String startPlace;
  final _startPlaceDescController = TextEditingController();
  final _startPlaceTimeController = TextEditingController();
  final _endPlaceController = TextEditingController();
  late String endPlace;
  final _endPlaceDescController = TextEditingController();
  final _endPlaceTimeController = TextEditingController();
  List<TextEditingController> _stopOverPlacesControllers = [];
  late List<String> stopOverPlaces = [];
  List<TextEditingController> _stopOverPlacesDescControllers = [];
  List<TextEditingController> _stopOverPlacesTimeControllers = [];

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  get startDateTime => null;

  get endDateTime => null;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _planNameController.dispose();
    _startPlaceController.dispose();
    _startPlaceDescController.dispose();
    _startPlaceTimeController.dispose();
    _endPlaceController.dispose();
    _endPlaceDescController.dispose();
    _endPlaceTimeController.dispose();
    _stopOverPlacesControllers.forEach((controller) {
      controller.dispose();
    });
    _stopOverPlacesDescControllers.forEach((controller) {
      controller.dispose();
    });
    _stopOverPlacesTimeControllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _addStopOverPlace() {
    setState(() {
      _stopOverPlacesControllers.add(TextEditingController());
      _stopOverPlacesDescControllers.add(TextEditingController());
      _stopOverPlacesTimeControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('일정 추가'),
          actions: [
            IconButton(
                onPressed: _addStopOverPlace,
                icon: Icon(Icons.add_circle_outline)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDisplayScreen(
                        startPlace: startPlace,
                        endPlace: endPlace,
                        stopOverPlaces: stopOverPlaces,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.directions)),
            
            IconButton(
                onPressed: () {
                  void _savePlan() async {
                    if (_formKey.currentState?.validate() ?? false) {
                      DateTime startDateTime = DateFormat('yyyy-MM-dd')
                          .parse(_startDateController.text);
                      startDateTime = DateTime(
                        startDateTime.year,
                        startDateTime.month,
                        startDateTime.day,
                        _startTime.hour,
                        _startTime.minute,
                      );

                      // 종료 날짜와 시간 결합
                      DateTime endDateTime = DateFormat('yyyy-MM-dd')
                          .parse(_endDateController.text);
                      endDateTime = DateTime(
                        endDateTime.year,
                        endDateTime.month,
                        endDateTime.day,
                        _endTime.hour,
                        _endTime.minute,
                      );
                      Schedule plan = new Schedule(
                        id: 0,
                        userId: currentUser,
                        title: _planNameController.text,
                        startTime: startDateTime,
                        endTime: endDateTime,
                        planFlag: false,
                        // 'startPlace': _startPlaceController.text,
                        // 'stopOverPlaces': _stopOverPlacesControllers.map((controller) => controller.text).toList(),
                        // 'endPlace': _endPlaceController.text,
                      );
                      ScheduleRepository scheduleRepository =
                          ScheduleRepository();
                      Schedule_Response schedule_response =
                          await scheduleRepository.addSchedule(plan);
                      Itiinerary startRoute = new Itiinerary(
                        scheduleId: schedule_response.id,
                        place: _startPlaceController.text,
                        placeInfo: startPlace.split('|')[1],
                        route: 1,
                        startTime: _startPlaceTimeController.text == ''
                            ? startDateTime
                            : DateFormat('yyyy-MM-dd HH:MM')
                                .parse(_startPlaceTimeController.text),
                        description: _startPlaceDescController.text,
                      );

                      ItiineraryRepository itiineraryRepository =
                          ItiineraryRepository();
                      itiineraryRepository.addItiinerary(startRoute);
                      int queqe_route = 2;
                      for (int i = 0;
                          i < _stopOverPlacesControllers.length;
                          i++) {
                        Itiinerary stopOverRoute = new Itiinerary(
                          scheduleId: schedule_response.id,
                          place: _stopOverPlacesControllers[i].text,
                          placeInfo: stopOverPlaces[i].split('|')[1],
                          route: queqe_route,
                          startTime:
                              _stopOverPlacesTimeControllers[queqe_route - 2]
                                          .text ==
                                      ''
                                  ? startDateTime
                                  : DateFormat('yyyy-MM-dd HH:MM').parse(
                                      _stopOverPlacesTimeControllers[
                                              queqe_route - 2]
                                          .text),
                          description:
                              _stopOverPlacesDescControllers[queqe_route - 2]
                                  .text,
                        );
                        queqe_route++;
                        itiineraryRepository.addItiinerary(stopOverRoute);
                      }
                      // _stopOverPlacesControllers
                      //     .map((controller) => controller.text)
                      //     .toList()
                      //     .forEach((stopOverPlace) {
                      //   Itiinerary stopOverRoute = new Itiinerary(
                      //     scheduleId: schedule_response.id,
                      //     place: stopOverPlace,
                      //     placeInfo: stopOverPlaces[i].split('|')[1],
                      //     route: queqe_route,
                      //     startTime:
                      //         _stopOverPlacesTimeControllers[queqe_route - 2]
                      //                     .text ==
                      //                 ''
                      //             ? startDateTime
                      //             : DateFormat('yyyy-MM-dd HH:MM').parse(
                      //                 _stopOverPlacesTimeControllers[
                      //                         queqe_route - 2]
                      //                     .text),
                      //     description:
                      //         _stopOverPlacesDescControllers[queqe_route - 2]
                      //             .text,
                      //   );
                      //   queqe_route++;
                      //   itiineraryRepository.addItiinerary(stopOverRoute);
                      // });
                      Itiinerary endRoute = new Itiinerary(
                        scheduleId: schedule_response.id,
                        place: _endPlaceController.text,
                        placeInfo: endPlace.split('|')[1],
                        route: queqe_route,
                        startTime: _endPlaceTimeController.text == ''
                            ? endDateTime
                            : DateFormat('yyyy-MM-dd HH:MM')
                                .parse(_endPlaceTimeController.text),
                        description: _endPlaceDescController.text,
                      );
                      itiineraryRepository.addItiinerary(endRoute);

                      // For now, just print the plan. You can replace this with your desired action.
                    }
                  }

                  _savePlan();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _startDateController,
                            decoration: const InputDecoration(
                                labelText: '시작일 (YYYY-MM-DD)'),
                            readOnly: true,
                            onTap: () =>
                                _selectDate(context, _startDateController),
                          ),
                          TextFormField(
                            controller: _endDateController,
                            decoration: const InputDecoration(
                                labelText: '종료일 (YYYY-MM-DD)'),
                            readOnly: true,
                            onTap: () =>
                                _selectDate(context, _endDateController),
                          ),
                          ListTile(
                            title: Text('시작 시간: ${_startTime.format(context)}'),
                            onTap: () => _selectTime(context, true),
                          ),
                          ListTile(
                            title: Text('종료 시간: ${_endTime.format(context)}'),
                            onTap: () => _selectTime(context, false),
                          ),
                          TextFormField(
                            controller: _planNameController,
                            decoration:
                                const InputDecoration(labelText: '일정 이름'),
                          ),
                          TextFormField(
                            controller: _startPlaceController,
                            decoration:
                                const InputDecoration(labelText: '시작 장소'),
                            onTap: () async {
                              PlacesSearchResult result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacesSearchScreen(),
                                ),
                              );
                              if (result != null) {
                                startPlace = result.name +
                                    '|' +
                                    result.lat.toString() +
                                    ',' +
                                    result.lng
                                        .toString(); // Assuming 'name' is a property of your place object
                                _startPlaceController.text = result
                                    .name; // Assuming 'name' is a property of your place object
                              }
                            },
                          ),
                          TextFormField(
                            controller: _startPlaceDescController,
                            decoration:
                                const InputDecoration(labelText: '상세 일정'),
                          ),
                          TextFormField(
                            controller: _startPlaceTimeController,
                            decoration: const InputDecoration(
                                labelText: '시작 시간 (HH:MM)'),
                            readOnly: true,
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                final selectedDate = DateFormat('yyyy-MM-dd')
                                    .parse(_startDateController.text);
                                final selectedTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    picked.hour,
                                    picked.minute);
                                _startPlaceTimeController.text =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(selectedTime);
                              }
                            },
                          ),
                          ...List.generate(_stopOverPlacesControllers.length,
                              (index) {
                            return TextFormField(
                              controller: _stopOverPlacesControllers[index],
                              decoration:
                                  const InputDecoration(labelText: '경유 장소'),
                              onTap: () async {
                                PlacesSearchResult result =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacesSearchScreen(),
                                  ),
                                );
                                if (stopOverPlaces == null) {
                                  stopOverPlaces = List.filled(
                                      _stopOverPlacesControllers.length, '');
                                }
                                if (result != null) {
                                  stopOverPlaces.add(result.name +
                                      '|' +
                                      result.lat.toString() +
                                      ',' +
                                      result.lng
                                          .toString()); // Assuming 'name' is a property of your place object
                                  _stopOverPlacesControllers[index].text = result
                                      .name; // Assuming 'name' is a property of your place object
                                }
                              },
                            );
                          }),
                          ..._stopOverPlacesDescControllers.map((controller) {
                            return TextFormField(
                              controller: controller,
                              decoration:
                                  const InputDecoration(labelText: '상세 일정'),
                            );
                          }).toList(),
                          ..._stopOverPlacesTimeControllers.map((controller) {
                            return TextFormField(
                              controller: controller,
                              decoration: const InputDecoration(
                                  labelText: '경유 날짜 및 시간 (YYYY-MM-DD HH:MM)'),
                              readOnly: true,
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2025),
                                );
                                if (pickedDate != null) {
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    final selectedDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    controller.text =
                                        DateFormat('yyyy-MM-dd HH:mm')
                                            .format(selectedDateTime);
                                  }
                                }
                              },
                            );
                          }).toList(),
                          TextFormField(
                            controller: _endPlaceController,
                            decoration:
                                const InputDecoration(labelText: '종료 장소'),
                            onTap: () async {
                              PlacesSearchResult result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacesSearchScreen(),
                                ),
                              );
                              if (result != null) {
                                endPlace = result.name +
                                    '|' +
                                    result.lat.toString() +
                                    ',' +
                                    result.lng
                                        .toString(); // Assuming 'name' is a property of your place object
                                _endPlaceController.text = result
                                    .name; // Assuming 'name' is a property of your place object
                              }
                            },
                          ),
                          TextFormField(
                            controller: _endPlaceDescController,
                            decoration:
                                const InputDecoration(labelText: '상세 일정'),
                          ),
                          TextFormField(
                            controller: _endPlaceTimeController,
                            decoration: const InputDecoration(
                                labelText: '종료 시간 (HH:MM)'),
                            readOnly: true,
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                final selectedDate = DateFormat('yyyy-MM-dd')
                                    .parse(_endDateController.text);
                                final selectedTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    picked.hour,
                                    picked.minute);
                                _endPlaceTimeController.text =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(selectedTime);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Future<Schedule_Response> {
  get id => null;
}
