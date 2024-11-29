// route_display_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class RouteDisplayScreen extends StatefulWidget {
  final String startPlace;
  final String endPlace;
  final List<String> stopOverPlaces;

  RouteDisplayScreen({required this.startPlace, required this.endPlace, required this.stopOverPlaces});

  @override
  _RouteDisplayScreenState createState() => _RouteDisplayScreenState();
}

class _RouteDisplayScreenState extends State<RouteDisplayScreen> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleApiKey = dotenv.env['google_map_android_api_key'].toString();

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getPolyline();
  }


  void _setMarkers() {
    // Parse start and end places
    var startPlaceData = widget.startPlace.split('|')[1].split(',');
    var endPlaceData = widget.endPlace.split('|')[1].split(',');

    // Add start marker
    _addMarker(LatLng(double.parse(startPlaceData[0]), double.parse(startPlaceData[1])), "start", BitmapDescriptor.defaultMarker);

    // Add end marker
    _addMarker(LatLng(double.parse(endPlaceData[0]), double.parse(endPlaceData[1])), "end", BitmapDescriptor.defaultMarkerWithHue(90));

    // Add stopover markers
    for (var i = 0; i < widget.stopOverPlaces.length; i++) {
      var stopOverData = widget.stopOverPlaces[i].split('|')[1].split(',');
      _addMarker(LatLng(double.parse(stopOverData[0]), double.parse(stopOverData[1])), "stopover_$i", BitmapDescriptor.defaultMarkerWithHue(60));
    }
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _getPolyline() async {
    // Parse start and end places
    var startPlaceData = widget.startPlace.split('|')[1].split(',');
    var endPlaceData = widget.endPlace.split('|')[1].split(',');

    List<PolylineWayPoint> waypoints = widget.stopOverPlaces.map((place) {
      var data = place.split('|')[1].split(',');
      return PolylineWayPoint(location: "${data[0]},${data[1]}");
    }).toList();

    polylineCoordinates.add(LatLng(double.parse(startPlaceData[0]), double.parse(startPlaceData[1])));
    if (widget.stopOverPlaces.isNotEmpty) {
      widget.stopOverPlaces.forEach((place) {
        var data = place.split('|')[1].split(',');
        polylineCoordinates.add(LatLng(double.parse(data[0]), double.parse(data[1])));
      });
    }
    polylineCoordinates.add(LatLng(double.parse(endPlaceData[0]), double.parse(endPlaceData[1])));
    for (var i = 0; i < polylineCoordinates.length; i++) {
      polylines[PolylineId(i.toString())] = Polyline(
        polylineId: PolylineId(i.toString()),
        color: Colors.red,
        points: polylineCoordinates,
      );
    }

    // _addPolyLine(); 
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   googleApiKey: googleApiKey,
    //   request: PolylineRequest(
    //     origin: PointLatLng(double.parse(startPlaceData[0]), double.parse(startPlaceData[1])),
    //     destination: PointLatLng(double.parse(endPlaceData[0]), double.parse(endPlaceData[1])),
    //     mode: TravelMode.driving,
    //     wayPoints: waypoints,
    //   ),
    // );

    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    //   _addPolyLine();
    // }
  }

  // void _addPolyLine() {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
  //   polylines[id] = polyline;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route Display')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(double.parse(widget.startPlace.split('|')[1].split(',')[0]), double.parse(widget.startPlace.split('|')[1].split(',')[1])), zoom: 10),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: Set.of(markers.values),
        polylines: Set.of(polylines.values),
      ),
    );
  }
}