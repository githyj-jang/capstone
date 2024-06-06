import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/plan_data.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080/schedules"; // 여기에 실제 서버 주소를 입력하세요.

  // 스케줄 추가
  Future<bool> addSchedule(String userId,Plan plan) async {
    final response = await http.post(Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'userId': userId,
          'startTime': plan.start.toIso8601String(),
          'endTime': plan.start.toIso8601String(),
          'explanation': plan.eventName,
          'startPlace': plan.eventLocationStart,
          'endPlace': plan.eventLocationEnd,
          'startRoute': plan.routeStart,
          'endRoute': plan.routeEnd,
          'planFlag': plan.planFlag,
        }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // 사용자 ID로 스케줄 조회
  Future<List<dynamic>> getSchedulesByUserID(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/user?userID=$userID'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Plan> plans = body.map((dynamic item) => Plan.fromJson(item)).toList();
      return plans;
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  // 사용자 ID와 계획 플래그로 스케줄 조회
  Future<List<dynamic>> getSchedulesByUserIDAndPlanFlag(String userID, bool planFlag) async {
    final response = await http.get(Uri.parse('$baseUrl/user/plan?userID=$userID&planFlag=$planFlag'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Plan> plans = body.map((dynamic item) => Plan.fromJson(item)).toList();
      return plans;
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  // 사용자 ID로 다른 장소들의 스케줄 조회
  Future<List<dynamic>> getSchedulesByUserIDAndDifferentPlaces(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/user/different-places?userID=$userID'));

    if (response.statusCode == 200) {

      List<dynamic> body = jsonDecode(response.body);
      List<Plan> plans = body.map((dynamic item) => Plan.fromJson(item)).toList();
      return plans;

    } else {
      throw Exception('Failed to load schedules');
    }
  }
}