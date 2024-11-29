import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlacesSearchResult {
  final String name;
  final String address;
  final double lat;
  final double lng;

  PlacesSearchResult({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
}

Future<List<PlacesSearchResult>> searchPlaces(String keyword) async {
  String apiKey = dotenv.env['google_map_android_api_key'].toString();
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$keyword&key=$apiKey&language=ko');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final results = jsonResponse['results'] as List;

    return results.take(10).map((result) {
      final location = result['geometry']['location'];
      return PlacesSearchResult(
        name: result['name'],
        address: result['formatted_address'],
        lat: location['lat'],
        lng: location['lng'],
      );
    }).toList();
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}