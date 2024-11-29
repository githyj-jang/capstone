import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planto/model/google_map.dart';


class PlaceMapScreen extends StatelessWidget {
  final PlacesSearchResult place;

  PlaceMapScreen(this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(place.lat, place.lng),
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(place.name),
            position: LatLng(place.lat, place.lng),
            infoWindow: InfoWindow(title: place.name),
          )
        },
      ),
    );
  }
}