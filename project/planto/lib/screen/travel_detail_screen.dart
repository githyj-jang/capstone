import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planto/model/google_map.dart';
import 'package:planto/model/itiinerary_data.dart';
import 'package:planto/model/plan_data.dart';
import 'package:planto/repository/itiinerary_repository.dart';
import 'package:planto/repository/schedule_repository.dart';
import 'package:planto/screen/map_web_screen.dart';
import 'package:planto/screen/place_map_screen.dart.dart';
import 'package:planto/screen/route_display_screen.dart';
import 'package:planto/screen/share_travel_screen.dart';
import '../model/travel_data.dart';

class TravelDetailScreen extends StatefulWidget {
  const TravelDetailScreen({Key? key, required this.travel}) : super(key: key);

  final Plan travel;

  @override
  State<TravelDetailScreen> createState() => _TravelDetailScreenState();
}

class _TravelDetailScreenState extends State<TravelDetailScreen> {
  List<Itiinerary> _displayedItineraryData = [];
  ScheduleRepository scheduleRepository = ScheduleRepository();
  ItiineraryRepository itiineraryRepository = ItiineraryRepository();
  _loadItinerary() async {
    List<Itiinerary> itineraries = await itiineraryRepository
        .getItiinerariesByScheduleID(widget.travel.scheduleId);
    setState(() {
      _displayedItineraryData = itineraries;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItinerary();
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  void optimizeRoutes(List<Itiinerary> itineraryData) async {
    _displayedItineraryData = await optimizeRoute(itineraryData);
    for (int i = 0; i < _displayedItineraryData.length; i++) {
      await itiineraryRepository.updateItiinerary(_displayedItineraryData[i]);
    }
  }

  String saveEdit() {
    for (int i = 0; i < _displayedItineraryData.length; i++) {
      itiineraryRepository.updateItiinerary(_displayedItineraryData[i]);
    }
    return "edit saved";
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.travel.eventName),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                optimizeRoutes(_displayedItineraryData);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MapWebScreen(mapData: _displayedItineraryData)));
              });
            },
          ),
          IconButton(
              onPressed: () {
                var stopOverPlaces = _displayedItineraryData
                    .sublist(1, _displayedItineraryData.length - 1)
                    .map(
                        (location) => location.place + "|" + location.placeInfo)
                    .toList();
                var endPlace = _displayedItineraryData[
                            _displayedItineraryData.length - 1]
                        .place +
                    "|" +
                    _displayedItineraryData[_displayedItineraryData.length - 1]
                        .placeInfo;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteDisplayScreen(
                      startPlace: _displayedItineraryData[0].place +
                          "|" +
                          _displayedItineraryData[0].placeInfo,
                      endPlace: endPlace,
                      stopOverPlaces: stopOverPlaces,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.directions)),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ShareScreen(
                            travel: widget.travel,
                            itiinerary: _displayedItineraryData)));
              });
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "기간 : ",
                        style: TextStyle(
                          fontSize: 24.0, // 글자 크기
                          color: Colors.blue, // 글자 색상을 파란색으로 설정
                          fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                        ),
                      ),
                      Text(
                        formatDateTime(widget.travel.start),
                        style: TextStyle(
                          fontSize: 20.0, // 글자 크기를 24로 설정
                        ),
                      ),
                      if (formatDateTime(widget.travel.start) !=
                          formatDateTime(widget.travel.end))
                        Text(' ~ '),
                      if (formatDateTime(widget.travel.start) !=
                          formatDateTime(widget.travel.end))
                        Text(
                          formatDateTime(widget.travel.end),
                          style: TextStyle(
                            fontSize: 20.0, // 글자 크기를 24로 설정
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Text(
                            "시작 시간",
                            style: TextStyle(
                              fontSize: 24.0, // 글자 크기
                              color: Colors.blue, // 글자 색상을 파란색으로 설정
                              fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                            ),
                          ),
                          Text(
                            widget.travel.startTime.split('.')[0],
                            style: TextStyle(
                              fontSize: 20.0, // 글자 크기를 24로 설정
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Text(
                            '종료 시간',
                            style: TextStyle(
                              fontSize: 24.0, // 글자 크기
                              color: Colors.blue, // 글자 색상을 파란색으로 설정
                              fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                            ),
                          ),
                          Text(
                            widget.travel.endTime,
                            style: TextStyle(
                              fontSize: 20.0, // 글자 크기를 24로 설정
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Text(
                        ' 경로 ',
                        style: TextStyle(
                          fontSize: 24.0, // 글자 크기
                          color: Colors.blue, // 글자 색상을 파란색으로 설정
                          fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Replace the existing Expanded widget and its children with this code
              Expanded(
                child: ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) async {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = _displayedItineraryData.removeAt(oldIndex);
                      Itiinerary newItem = Itiinerary(
                        id: item.id,
                        scheduleId: item.scheduleId,
                        place: item.place,
                        placeInfo: item.placeInfo,
                        route: newIndex + 1,
                        startTime: item.startTime,
                        description: item.description,
                      );
                      _displayedItineraryData.insert(newIndex, newItem);
                    });
                    await saveEdit();
                  },
                  children: _displayedItineraryData
                      .map((location) => Card(
                            key: ValueKey(
                                location), // Ensure each item has a unique key
                            child: InkWell(
                              onTap: () {
                                final PlacesSearchResult place =
                                    PlacesSearchResult(
                                  name: location.place,
                                  address: location.place,
                                  lat: double.parse(
                                      location.placeInfo.split(',')[0]),
                                  lng: double.parse(
                                      location.placeInfo.split(',')[1]),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlaceMapScreen(place)),
                                );
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(location.place,
                                        style: TextStyle(fontSize: 20.0)),
                                    if (location.startTime
                                        .toString()
                                        .isNotEmpty)
                                      Text(
                                          "시작 시간: ${location.startTime.toString().split('.')[0]}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey)),
                                    if (location.description
                                        .toString()
                                        .isNotEmpty)
                                      Text("상세 일정: ${location.description}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scheduleRepository.deleteSchedule(widget.travel.scheduleId);
          Navigator.pop(context);
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:planto/model/google_map.dart';
// import 'package:planto/model/itiinerary_data.dart';
// import 'package:planto/model/plan_data.dart';
// import 'package:planto/repository/itiinerary_repository.dart';
// import 'package:planto/repository/schedule_repository.dart';
// import 'package:planto/screen/map_web_screen.dart';
// import 'package:planto/screen/place_map_screen.dart.dart';
// import 'package:planto/screen/route_display_screen.dart';
// import 'package:planto/screen/share_travel_screen.dart';
// import '../model/travel_data.dart';

// class TravelDetailScreen extends StatefulWidget {
//   const TravelDetailScreen({Key? key, required this.travel}) : super(key: key);

//   final Plan travel;

//   @override
//   State<TravelDetailScreen> createState() => _TravelDetailScreenState();
// }

// class _TravelDetailScreenState extends State<TravelDetailScreen> {
//   List<Itiinerary> _displayedItineraryData = [];
//   ScheduleRepository scheduleRepository = ScheduleRepository();
//   ItiineraryRepository itiineraryRepository = ItiineraryRepository();
//   _loadItinerary() async {
//     List<Itiinerary> itineraries = await itiineraryRepository
//         .getItiinerariesByScheduleID(widget.travel.scheduleId);
//     setState(() {
//       _displayedItineraryData = itineraries;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadItinerary();
//   }

//   String formatDateTime(DateTime dateTime) {
//     final DateFormat formatter = DateFormat('yyyy-MM-dd');
//     return formatter.format(dateTime);
//   }

//   void optimizeRoutes(List<Itiinerary> itineraryData) async {
//     _displayedItineraryData = await optimizeRoute(itineraryData);
//     for (int i = 0; i < _displayedItineraryData.length; i++) {
//       await itiineraryRepository.updateItiinerary(_displayedItineraryData[i]);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.travel.eventName),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 optimizeRoutes(_displayedItineraryData);
//               });
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.map),
//             onPressed: () {
//               setState(() {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (BuildContext context) =>
//                             MapWebScreen(mapData: _displayedItineraryData)));
//               });
//             },
//           ),
//           IconButton(
//                 onPressed: () {
//                   var stopOverPlaces = _displayedItineraryData.sublist(1, _displayedItineraryData.length-1).map((location) => location.place+"|"+location.placeInfo).toList();
//                   var endPlace = _displayedItineraryData[_displayedItineraryData.length-1].place+"|"+_displayedItineraryData[_displayedItineraryData.length-1].placeInfo;
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => RouteDisplayScreen(
//                         startPlace: _displayedItineraryData[0].place+"|"+_displayedItineraryData[0].placeInfo,
//                         endPlace: endPlace,
//                         stopOverPlaces: stopOverPlaces,
//                       ),
//                     ),
//                   );
//                 },
//                 icon: Icon(Icons.directions)),
//           IconButton(icon: Icon(Icons.share),
          
//               onPressed: () {
//               setState(() {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (BuildContext context) =>
//                             ShareScreen(travel: widget.travel, itiinerary: _displayedItineraryData)));
//               });
//             },),
//         ],
//       ),
//       body: Center(
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Card(
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "기간 : ",
//                         style: TextStyle(
//                           fontSize: 24.0, // 글자 크기
//                           color: Colors.blue, // 글자 색상을 파란색으로 설정
//                           fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
//                         ),
//                       ),
//                       Text(
//                         formatDateTime(widget.travel.start),
//                         style: TextStyle(
//                           fontSize: 20.0, // 글자 크기를 24로 설정
//                         ),
//                       ),
//                       if (formatDateTime(widget.travel.start) !=
//                           formatDateTime(widget.travel.end))
//                         Text(' ~ '),
//                       if (formatDateTime(widget.travel.start) !=
//                           formatDateTime(widget.travel.end))
//                         Text(
//                           formatDateTime(widget.travel.end),
//                           style: TextStyle(
//                             fontSize: 20.0, // 글자 크기를 24로 설정
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Card(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child: Column(
//                         children: [
//                           Text(
//                             "시작 시간",
//                             style: TextStyle(
//                               fontSize: 24.0, // 글자 크기
//                               color: Colors.blue, // 글자 색상을 파란색으로 설정
//                               fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
//                             ),
//                           ),
//                           Text(
//                             widget.travel.startTime.split('.')[0],
//                             style: TextStyle(
//                               fontSize: 20.0, // 글자 크기를 24로 설정
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Card(
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child: Column(
//                         children: [
//                           Text(
//                             '종료 시간',
//                             style: TextStyle(
//                               fontSize: 24.0, // 글자 크기
//                               color: Colors.blue, // 글자 색상을 파란색으로 설정
//                               fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
//                             ),
//                           ),
//                           Text(
//                             widget.travel.endTime,
//                             style: TextStyle(
//                               fontSize: 20.0, // 글자 크기를 24로 설정
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Card(
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: Column(
//                     children: [
//                       Text(
//                         ' 경로 ',
//                         style: TextStyle(
//                           fontSize: 24.0, // 글자 크기
//                           color: Colors.blue, // 글자 색상을 파란색으로 설정
//                           fontWeight: FontWeight.bold, // 글자 굵기를 굵게(bold) 설정
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: Column(
//                     children: [
//                       Column(
//                         children: _displayedItineraryData
//                             .map((location) => Card(
//                                   child: InkWell(
//                                     onTap: () {
//                                       final PlacesSearchResult place =
//                                           PlacesSearchResult(
//                                         name: location.place,
//                                         address: location.place,
//                                         lat: double.parse(
//                                             location.placeInfo.split(',')[0]),
//                                         lng: double.parse(
//                                             location.placeInfo.split(',')[1]),
//                                       );
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               PlaceMapScreen(place),
//                                         ),
//                                       );
//                                     },
//                                     child: SizedBox(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.9,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(location.place,
//                                               style: TextStyle(fontSize: 20.0)),
//                                           if (location.startTime
//                                               .toString()
//                                               .isNotEmpty)
//                                             Text(
//                                                 "시작 시간: ${location.startTime.toString().split('.')[0]}",
//                                                 style: TextStyle(
//                                                     fontSize: 16.0,
//                                                     color: Colors.grey)),
//                                           if (location.description
//                                               .toString()
//                                               .isNotEmpty)
//                                             Text(
//                                                 "상세 일정: ${location.description}",
//                                                 style: TextStyle(
//                                                     fontSize: 16.0,
//                                                     color: Colors.grey)),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
      
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           scheduleRepository.deleteSchedule(widget.travel.scheduleId);
//           Navigator.pop(context);
//         },
//         child: const Icon(Icons.delete),
//       ),
//     );
//   }
// }
