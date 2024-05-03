import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final _endPlaceController = TextEditingController();
  List<TextEditingController> _stopOverPlacesControllers = [];

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _planNameController.dispose();
    _startPlaceController.dispose();
    _endPlaceController.dispose();
    _stopOverPlacesControllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('일정 추가'),
          actions: [
            IconButton(onPressed: _addStopOverPlace, icon: Icon(Icons.add_circle_outline)),
            IconButton(onPressed: (){}, icon: Icon(Icons.save))
          ],),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  height: MediaQuery.of(context).size.height*0.8,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _startDateController,
                            decoration: const InputDecoration(labelText: '시작일 (YYYY-MM-DD)'),
                            readOnly: true,
                            onTap: () => _selectDate(context, _startDateController),
                          ),
                          TextFormField(
                            controller: _endDateController,
                            decoration: const InputDecoration(labelText: '종료일 (YYYY-MM-DD)'),
                            readOnly: true,
                            onTap: () => _selectDate(context, _endDateController),
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
                            decoration: const InputDecoration(labelText: '일정 이름'),
                          ),
                          TextFormField(
                            controller: _startPlaceController,
                            decoration: const InputDecoration(labelText: '시작 장소'),
                          ),
                          ..._stopOverPlacesControllers.map((controller) {
                            return TextFormField(
                              controller: controller,
                              decoration: const InputDecoration(labelText: '경유 장소'),
                            );
                          }).toList(),
                          TextFormField(
                            controller: _endPlaceController,
                            decoration: const InputDecoration(labelText: '종료 장소'),
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