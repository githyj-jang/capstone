import 'package:flutter/material.dart';
import 'package:planto/model/itiinerary_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/map_data.dart';


class MapWebScreen extends StatefulWidget {
  const MapWebScreen({Key? key, required this.mapData}):super(key:key);

  final List<Itiinerary> mapData;

  @override
  State<MapWebScreen> createState() => _MapWebScreenState();
}

class _MapWebScreenState extends State<MapWebScreen> {

  @override
  Widget build(BuildContext context) {
    String url = "https://google.com/maps/dir/"+widget.mapData[0].place;
    for (var i = 1; i < widget.mapData.length; i++) {
      url += "/"+widget.mapData[i].place;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Route'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}