import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:planto/dto/schedule_response.dart';
import 'package:planto/model/schedule_data.dart';


class ScheduleRepository {
  final String baseUrl=  "http://10.0.2.2:8080"; 

  // ScheduleRepository(this.baseUrl);

  Future<Schedule_Response> addSchedule(Schedule schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schedules/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(schedule.toJson()),
    );

    

    if (response.statusCode == 200) {
      dynamic  usersJson = jsonDecode(response.body);
      return Schedule_Response.fromJson(usersJson);
    } else {
      throw Exception('Failed to add schedule');
    }
  }

  Future<List<Schedule>> getSchedulesByUserID(String userID) async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/user?userID=$userID'));

    if (response.statusCode == 200) {
      final decodedData = utf8.decode(response.bodyBytes);
      
      Iterable l = json.decode(decodedData);
      return List<Schedule>.from(l.map((model) => Schedule.fromJson(model)));
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<List<Schedule>> getSchedulesByUserIDAndPlanFlag(String userID, bool planFlag) async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/user/plan?userID=$userID&planFlag=$planFlag'));

    if (response.statusCode == 200) {
      final decodedData = utf8.decode(response.bodyBytes);
      
      Iterable l = json.decode(decodedData);
      return List<Schedule>.from(l.map((model) => Schedule.fromJson(model)));
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<List<Schedule>> getSchedulesByUserIDAndPeriod(String userID, DateTime startTime, DateTime endTime) async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/user/schedule?userID=$userID&startTime=${startTime.toIso8601String()}&endTime=${endTime.toIso8601String()}'));

    if (response.statusCode == 200) {
      final decodedData = utf8.decode(response.bodyBytes);
      
      Iterable l = json.decode(decodedData);
      return List<Schedule>.from(l.map((model) => Schedule.fromJson(model)));
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<void> deleteSchedule(int scheduleID) async {
    final response = await http.delete(Uri.parse('$baseUrl/schedules/delete?scheduleID=$scheduleID'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete schedule');
    }
  }

  Future<Schedule> updateSchedule(Schedule schedule) async {
    final response = await http.put(
      Uri.parse('$baseUrl/schedules/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(schedule.toJson()),
    );

    if (response.statusCode == 200) {
      return Schedule.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update schedule');
    }
  }

  Future<List<Schedule>> searchSchedules(String searchTerm) async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/search?searchTerm=$searchTerm'));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<Schedule>.from(l.map((model) => Schedule.fromJson(model)));
    } else {
      throw Exception('Failed to search schedules');
    }
  }

  Future<Schedule> getScheduleBySpecificTime(DateTime specificTime) async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/specific-time?specificTime=${specificTime.toIso8601String()}'));

    if (response.statusCode == 200) {
      return Schedule.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get schedule by specific time');
    }
  }
}