import 'dart:convert';
import 'globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class Maps extends StatefulWidget{

  @override
  State<Maps> createState() => _Maps();
}

class _Maps extends State<Maps>{
  // late String _currrentLocation = Globals.ssssadress.value;
  late List<PolygonDataModel> _polygonData;
  late MapZoomPanBehavior _zoomPanBehavior;
  late String _boundaryJson;

  Future<Set<MapPolygon>> _getPolygonPoints() async {
    String _currrentLocation = Globals.globalAddress.value;
    _polygonData = <PolygonDataModel>[
      PolygonDataModel(_currrentLocation, 'assets/RoundIcon.png',
          color: const Color.fromRGBO(237, 41, 57, 1.0)),];
    _zoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 10,
      // Brazil coordinate.
      focalLatLng: const MapLatLng(-35.28, 149.14),
      minZoomLevel: 6,
      maxZoomLevel: 16,
      enableDoubleTapZooming: true,
    );
    print('${_currrentLocation}.json');
    _boundaryJson = '${_currrentLocation}.json';
    List<dynamic> polygonGeometryData;
    int multipolygonGeometryLength;
    final List<List<MapLatLng>> polygons = <List<MapLatLng>>[];
    final String data = await rootBundle.loadString(_boundaryJson);
    final dynamic jsonData = json.decode(data);
    const String key = 'features';
    final int jsonLength = jsonData[key].length as int;
    for (int i = 0; i < jsonLength; i++) {
      final dynamic features = jsonData[key][i];
      final Map<String, dynamic> geometry =
      features['geometry'] as Map<String, dynamic>;

      if (geometry['type'] == 'Polygon') {
        polygonGeometryData = geometry['coordinates'][0] as List<dynamic>;
        polygons.add(_getLatLngPoints(polygonGeometryData));
      } else {
        multipolygonGeometryLength = geometry['coordinates'].length as int;
        for (int j = 0; j < multipolygonGeometryLength; j++) {
          polygonGeometryData = geometry['coordinates'][j][0] as List<dynamic>;
          polygons.add(_getLatLngPoints(polygonGeometryData));
        }
      }
    }
    return _getPolygons(polygons);
  }
  List<MapLatLng> _getLatLngPoints(List<dynamic> polygonPoints) {
    final List<MapLatLng> polygon = <MapLatLng>[];
    for (int i = 0; i < polygonPoints.length; i++) {
      polygon.add(MapLatLng(polygonPoints[i][1], polygonPoints[i][0]));
    }
    return polygon;
  }

  Set<MapPolygon> _getPolygons(List<List<MapLatLng>> polygonPoints) {
    return List<MapPolygon>.generate(
      polygonPoints.length,
          (int index) {
        return MapPolygon(points: polygonPoints[index]);
      },
    ).toSet();
  }

  MapSublayer _getPolygonLayer(Set<MapPolygon> polygons) {
    return MapPolygonLayer(
      polygons: polygons,
      color: Colors.grey.withOpacity(0.9),
      strokeColor: Colors.red,
    );
  }


  @override
  void initState() {
    // String _currrentLocation = Globals.ssssadress.value;
    // _polygonData = <PolygonDataModel>[
    //   PolygonDataModel(_currrentLocation, 'assets/RoundIcon.png',
    //       color: const Color.fromRGBO(237, 41, 57, 1.0)),];
    // _zoomPanBehavior = MapZoomPanBehavior(
    //   zoomLevel: 11,
    //   // Brazil coordinate.
    //   focalLatLng: const MapLatLng(-35.16, 149.14),
    //   minZoomLevel: 6,
    //   maxZoomLevel: 16,
    //   enableDoubleTapZooming: true,
    // );
    // print('${_currrentLocation}.json');
    // _boundaryJson = '${_currrentLocation}.json';
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Globals.globalAddress,
      builder: (context, value, widget) {
        return FutureBuilder<dynamic>(
          future: _getPolygonPoints(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  MapTileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    sublayers: <MapSublayer>[_getPolygonLayer(snapshot.data)],
                    zoomPanBehavior: _zoomPanBehavior,
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     print('Navigate to Visualisation' );
                  //   },
                  // )
                ],
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }



}

class PolygonDataModel {
  /// Holds the polygon data model data values
  PolygonDataModel(this.name, this.imagePath, {required this.color});

  /// Holds the string value
  final String name;

  /// Path of image
  final String imagePath;

  /// color value
  final Color color;
}