import 'dart:math';

class Itiinerary {
  final int? id;
  final int scheduleId;
  final String place;
  final String placeInfo;
  final int route;
  final DateTime startTime;

  Itiinerary({
    this.id,
    required this.scheduleId,
    required this.place,
    required this.placeInfo,
    required this.route,
    required this.startTime,
  });

  factory Itiinerary.fromJson(Map<String, dynamic> json) {
    return Itiinerary(
      id: json['id'],
      scheduleId: json['scheduleID'],
      place: json['place'],
      placeInfo: json['placeInfo'],
      route: json['route'],
      startTime: DateTime.parse(json['startTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleID': scheduleId,
      'place': place,
      'placeInfo': placeInfo,
      'route': route,
      'startTime': startTime.toIso8601String(),
    };
  }
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371e3; // Earth radius in meters
  double phi1 = lat1 * pi / 180;
  double phi2 = lat2 * pi / 180;
  double deltaPhi = (lat2 - lat1) * pi / 180;
  double deltaLambda = (lon2 - lon1) * pi / 180;

  double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
             cos(phi1) * cos(phi2) *
             sin(deltaLambda / 2) * sin(deltaLambda / 2);
             
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // Distance in meters
}

List<Itiinerary> optimizeRoute(List<Itiinerary> itineraries) {
  Map<int, List<Itiinerary>> groupedBySchedule = {};

  // Group itineraries by scheduleId
  for (var itinerary in itineraries) {
    if (!groupedBySchedule.containsKey(itinerary.scheduleId)) {
      groupedBySchedule[itinerary.scheduleId] = [];
    }
    groupedBySchedule[itinerary.scheduleId]!.add(itinerary);
  }

  List<Itiinerary> optimizedItineraries = [];

  // Optimize each group
  groupedBySchedule.forEach((scheduleId, itineraryList) {
    if (itineraryList.length <= 1) {
      optimizedItineraries.addAll(itineraryList);
      return;
    }

    // Parse coordinates from placeInfo
    List<Map<String, dynamic>> points = itineraryList.map((itinerary) {
      var parts = itinerary.placeInfo.split(',');
      return {
        'itinerary': itinerary,
        'latitude': double.parse(parts[0]),
        'longitude': double.parse(parts[1]),
      };
    }).toList();

    // Greedy algorithm to find the shortest path
    List<Itiinerary> orderedItineraries = [];
    var currentPoint = points.removeAt(0);
    orderedItineraries.add(currentPoint['itinerary']);

    while (points.isNotEmpty) {
      points.sort((a, b) {
        var distanceA = calculateDistance(
          currentPoint['latitude'], currentPoint['longitude'],
          a['latitude'], a['longitude']);
        var distanceB = calculateDistance(
          currentPoint['latitude'], currentPoint['longitude'],
          b['latitude'], b['longitude']);
        return distanceA.compareTo(distanceB);
      });
      
      currentPoint = points.removeAt(0);
      orderedItineraries.add(currentPoint['itinerary']);
    }

    // Update routes based on the new order
    for (int i = 0; i < orderedItineraries.length; i++) {
      orderedItineraries[i] = Itiinerary(
        id: orderedItineraries[i].id,
        scheduleId: orderedItineraries[i].scheduleId,
        place: orderedItineraries[i].place,
        placeInfo: orderedItineraries[i].placeInfo,
        route: i + 1, // Update route to reflect new order
        startTime: orderedItineraries[i].startTime,
      );
    }

    optimizedItineraries.addAll(orderedItineraries);
  });

  return optimizedItineraries;
}