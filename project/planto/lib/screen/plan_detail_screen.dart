import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planto/model/itiinerary_data.dart';
import 'package:planto/repository/itiinerary_repository.dart';
import 'package:planto/screen/map_web_screen.dart';
import '../model/plan_data.dart';


import 'dart:math';
import 'package:flutter/material.dart'; // Ensure this is imported
import 'package:intl/intl.dart';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({Key? key, required this.plan}) : super(key: key);
  final Plan plan;

  @override
  State createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  

  // double haversine(List<double> coord1, List<double> coord2) {
  //   const R = 6371; // Earth radius in kilometers
  //   final lat1 = coord1[0];
  //   final lon1 = coord1[1];
  //   final lat2 = coord2[0];
  //   final lon2 = coord2[1];
  //   final dLat = (lat2 - lat1) * pi / 180;
  //   final dLon = (lon2 - lon1) * pi / 180;
  //   final a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
  //       sin(dLon / 2) * sin(dLon / 2);
  //   final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //   return R * c;
  // }

  

  // Future<void> _launchURL(String urlString) async {
  //   final Uri url = Uri.parse(urlString);
  //   if (!await launchUrl(url)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  List<Itiinerary> _displayedItineraryData = [];

  
  ItiineraryRepository itiineraryRepository = ItiineraryRepository();
  _loadItinerary() async {
    
    List<Itiinerary> itineraries = await itiineraryRepository.getItiinerariesByScheduleID(widget.plan.scheduleId);
    setState(() {
      _displayedItineraryData = itineraries;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItinerary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.eventName),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(()  {
                _displayedItineraryData = optimizeRoute(_displayedItineraryData);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("기간 : ",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(formatDateTime(widget.plan.start),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    if (widget.plan.start != widget.plan.end)
                      Text(' ~ '),
                    if (widget.plan.start != widget.plan.end)
                      Text(formatDateTime(widget.plan.end),
                        style: TextStyle(fontSize: 20.0),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Column(
                        children: [
                          Text("시작 시간",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.plan.startTime,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Column(
                        children: [
                          Text('종료 시간',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.plan.endTime,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                child: GestureDetector( // Add GestureDetector here
                  onTap: () => {
                    // Navigator.push(context,
                    // MaterialPageRoute(builder: (BuildContext context)=>MapWebScreen(mapData:_displayedMapData[index])));
                  }, // Replace with your URL
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      children: [
                        Text(' 경로 ',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                            children:
                              _displayedItineraryData.map((location) => Text(location.place, style:
                                TextStyle(fontSize:
                                20.0))).toList(),
                        ),
                      ],
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

Iterable<List<T>> permutations<T>(List<T> list, [int startIndex = 0]) sync* {
if (startIndex >= list.length - 1) {
yield list;
} else {
for (int i = startIndex; i < list.length; i++) {
var copy = List<T>.from(list);
var temp = copy[startIndex];
copy[startIndex] = copy[i];
copy[i] = temp;
yield* permutations(copy, startIndex + 1);
}
}
}

String formatDateTime(DateTime dateTime) {
final DateFormat formatter = DateFormat('yyyy-MM-dd');
return formatter.format(dateTime);
}
}


