import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/map_data.dart';


class MapWebScreen extends StatefulWidget {
  const MapWebScreen({Key? key, required this.mapData}):super(key:key);

  final MapData mapData;

  @override
  State<MapWebScreen> createState() => _MapWebScreenState();
}

class _MapWebScreenState extends State<MapWebScreen> {

  @override
  Widget build(BuildContext context) {
    String url = "https://way-m.map.naver.com/quick-path/"+widget.mapData.eventLocationStart+"/"+widget.mapData.eventLocationEnd+"/-/car/0";
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
