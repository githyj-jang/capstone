import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 위해 필요

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});
  @override
  _AddPlanScreenState createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController dateController = TextEditingController(); // 날짜 입력 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일정 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 장소 입력 필드
            TextField(
              controller: placeController,
              decoration: InputDecoration(labelText: '장소'),
            ),

            // 날짜 입력 필드
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: '날짜'),
              readOnly: true, // 사용자가 직접 입력하지 않도록 설정
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000), // 선택 가능한 최소 날짜
                  lastDate: DateTime(2101),  // 선택 가능한 최대 날짜
                );
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    dateController.text = formattedDate; // 선택된 날짜를 텍스트 필드에 표시
                  });
                }
              },
            ),

            // 시작 시간 입력 필드
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(labelText: '시작 시간'),
            ),

            // 종료 시간 입력 필드
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(labelText: '종료 시간'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _addNewActivity();
              },
              child: Text('추가'),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewActivity() {
    final newActivity = {
      'place': placeController.text,
      'date': dateController.text, // 추가된 날짜 정보
      'startTime': startTimeController.text,
      'endTime': endTimeController.text,
    };

    print(newActivity); // 새 활동 출력 (디버깅용)

    Navigator.pop(context, newActivity); // 부모 화면으로 돌아가서 새 활동을 전달
  }
}