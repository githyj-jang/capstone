import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:planto/model/itiinerary_data.dart';


class ItiineraryRepository {
  final String baseUrl = "http://10.0.2.2:8080"; 

  // ItiineraryRepository(this.baseUrl);

  Future<String> addItiinerary(Itiinerary itiinerary) async {
    final response = await http.post(
      Uri.parse('$baseUrl/itinerary/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(itiinerary.toJson()),
    );

    if (response.statusCode == 200) {
      return 'Itiinerary added successfully';
    } else {
      throw Exception('Failed to add itiinerary');
    }
  }

  Future<List<Itiinerary>> getItiinerariesByUserID(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/itinerary/all/$userId'));

    if (response.statusCode == 200) {
      final decodedData = utf8.decode(response.bodyBytes);
      
      Iterable l = json.decode(decodedData);
      return List<Itiinerary>.from(l.map((model) => Itiinerary.fromJson(model)));
    } else {
      throw Exception('Failed to load itiineraries');
    }
  }

  Future<Itiinerary> updateItiinerary(Itiinerary itiinerary) async {
    final response = await http.put(
      Uri.parse('$baseUrl/itinerary/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(itiinerary.toJson()),
    );

    if (response.statusCode == 200) {
      return Itiinerary.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update itiinerary');
    }
  }

  Future<void> deleteItiinerary(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/itinerary/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete itiinerary');
    }
  }

  Future<List<Itiinerary>> getItiinerariesByScheduleID(int scheduleID) async {
    final response = await http.get(Uri.parse('$baseUrl/itinerary/schedule?scheduleID=$scheduleID'));

    if (response.statusCode == 200) {
      final decodedData = utf8.decode(response.bodyBytes);
      
      Iterable l = json.decode(decodedData);
      return List<Itiinerary>.from(l.map((model) => Itiinerary.fromJson(model)));
    } else {
      throw Exception('Failed to load itiineraries');
    }
  }

  Future<void> deleteItiinerariesByScheduleID(int scheduleID) async {
    final response = await http.delete(Uri.parse('$baseUrl/itinerary/delete/schedule?scheduleID=$scheduleID'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete itiineraries');
    }
  }
}