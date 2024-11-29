// lib/screens/edit_plan_screen.dart
// import 'dart:ffi'; // This import is not needed

import 'package:planto/model/google_map.dart';
import 'package:planto/screen/places_search_screen.dart';

import '../model/itiinerary_data.dart';
import '../model/schedule_data.dart';
import 'package:flutter/material.dart';

class EditPlanScreen extends StatefulWidget {
  final Itiinerary activity;

  EditPlanScreen(this.activity);

  @override
  _EditPlanScreenState createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  late TextEditingController placeController;
  late List<double> startPlace;
  late TextEditingController startTimeController;

  @override
  void initState() {
    super.initState();
    placeController = TextEditingController(text: widget.activity.place);
    startTimeController =
        TextEditingController(text: widget.activity.startTime.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일정 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: placeController,
              decoration: const InputDecoration(labelText: '시작 장소'),
              onTap: () async {
                PlacesSearchResult result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacesSearchScreen(),
                  ),
                );
                if (result != null) {
                  startPlace = 
                      [result.lat,result.lng]; // Assuming 'name' is a property of your place object
                  placeController.text = result
                      .name; // Assuming 'name' is a property of your place object
                }
              },
            ),
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(labelText: '시작 시간'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 수정된 데이터 반환
                Navigator.pop(context, {
                  'place': placeController.text,
                  'startTime': startTimeController.text,
                  'placeInfo': startPlace
                });
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
