import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planto/model/google_map.dart';
import 'package:planto/screen/place_map_screen.dart.dart';


class PlacesSearchScreen extends StatefulWidget {
  @override
  _PlacesSearchScreenState createState() => _PlacesSearchScreenState();
}

class _PlacesSearchScreenState extends State<PlacesSearchScreen> {
  List<PlacesSearchResult> _places = [];
  
  void _search(String keyword) async {
    try {
      final places = await searchPlaces(keyword);
      setState(() {
        _places = places;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('장소 검색')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: '키워드 입력'),
            onSubmitted: _search,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return Card(
                  child: ListTile(
                    title: Text(place.name),
                    subtitle: Text(place.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            // Define check button action here
                             Navigator.pop(context, place);
                          },
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceMapScreen(place),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}