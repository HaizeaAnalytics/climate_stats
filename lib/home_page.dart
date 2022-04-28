import 'package:climate_stats/authentication_service.dart';
import 'package:climate_stats/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';
import 'profile_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String databaseName = "userInfo";
String userEmail = "";
ValueNotifier<String> _location = ValueNotifier<String>('');


class HomePage extends StatelessWidget {
  // const HomePage({Key? key}) : super(key: key);

  User userInfo;
  String lastLoginTime = "";


  HomePage(this.userInfo) {

    userEmail = userInfo.email.toString();
    lastLoginTime = userInfo.metadata.lastSignInTime!.toLocal().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new TopAppBar("Home", userInfo),
      body: Container(
        child: Column(
          children: [
            LogoArea(),


            PageInfo(this.lastLoginTime),

            SizedBox(height: 10,),

            Container(
              width: 500,
              height: 50,
              child: AutocompleteSearch(),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Favourites",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                ),
                SizedBox(width: 900,),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  height: 500,
                  child: FavouriteList(),
                ),

                const SizedBox(width: 20),

                SizedBox(
                  width: 500,
                  height: 500,
                  child: MyMap(),
                ),
                SizedBox(
                  width: 50,
                  height: 500,
                  child: Scaffold(
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                    floatingActionButton: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            child: const Icon(Icons.add_location),
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SecondRoute()),
                              );// Add your onPressed code here!
                            },
                            child: const Icon(Icons.addchart),
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        ],
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../assets/background_blur.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
      ),
    );
  }
}

/**
 * Data Viusalisation
 */
class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Visualisation'),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
             width: 600,
             height: 300,
             color: Color.fromRGBO(38, 38, 38, 0.4),
             child:Text("viusalsation ",
                 style: const TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 32.0,
                   color: Colors.white,
                 )),
           ),
           SizedBox(width:20),
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               AxisDropDown(),
               SizedBox(height: 100,),
               FloatingActionButton(
                 onPressed: () {},
                 child: const Icon(Icons.download),
                 backgroundColor: Colors.lightBlueAccent,
               ),
             ],
           ),
          ],
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../assets/background_blur.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
      ),
    );
  }
}


/**
 * Favourite list
 */
class FavouriteList extends StatefulWidget {

  @override
  _FavouriteList createState() => _FavouriteList();
}

class _FavouriteList extends State<FavouriteList>{
  List<String> favourites = [];

  @override
  void initState(){
    super.initState();
    getFavouriteList();
  }
  void getFavouriteList() async{

    await FirebaseFirestore.instance.collection(databaseName).doc(userEmail).get().then((DocumentSnapshot document){
        if(document.exists){
          favourites=List.from(document.get("favourites"));
        }
    });
    setState(() {

    });

  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: favourites.length,
        // itemExtent: 20.0,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: TextButton(
                onPressed: () {
                  _location.value=favourites[index];
                  print(_location.value);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(favourites[index]),
                  ],
                ),
              ),
              trailing: IconButton(
                icon:Icon(Icons.delete_forever),
                onPressed: () async{
                  CollectionReference user = FirebaseFirestore.instance.collection(databaseName);
                  user.doc(userEmail).update({'favourites':FieldValue.arrayRemove([favourites[index]])});
                  getFavouriteList();
                },
              ),
            ),
          );
        }
    );
  }
}

/**
 * autocomplete search
 */
class AutocompleteSearch extends StatelessWidget {

  static const List<String> addressOptions = <String>[
    'New South Wales',
    'Queensland',
    'Northern Territory',
    'Victoria',
    'South Australia',
    'Western Australia',
    'Tasmania',
    'Australian Capital Territory',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        padding:
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return addressOptions.where((String option) {
          return option.contains(textEditingValue.text.toUpperCase());
        });
      },
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top:Radius.circular(16.0),bottom: Radius.circular(16.0)),
          ),
          child: Container(
            height: 52.0 * options.length,
            width: 500 ,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: options.length,
              shrinkWrap: false,
              itemBuilder: (BuildContext context, int index) {
                final String option = options.elementAt(index);
                return InkWell(
                  onTap: () => onSelected(option),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(option),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      fieldViewBuilder: (
          BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted
          ) {
        return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          autofocus: true,
          onSubmitted: (value){
            _location.value = value;
          },
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
          ),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },

    );
  }
}

// /**
//  * Map
//  */
// class HomeMap extends StatefulWidget{
//   const HomeMap({Key?key}) : super(key:key);
//
//   @override
//   State<StatefulWidget> createState() => _HomeMap();
// }
//
// class _HomeMap extends State<HomeMap>{
//
//   @override
//   Widget build(BuildContext context) {
//     return FlutterMap(
//       options: MapOptions(
//         center: latLng.LatLng(-35.28,149.13),
//         zoom: 14.0,
//       ),
//       layers: [
//         MarkerLayerOptions(
//           markers: [
//             Marker(
//               width: 40.0,
//               height: 40.0,
//               point: latLng.LatLng(-35.28,149.13),
//               builder: (ctx) =>
//                   Container(
//                     child:Image.asset('../assets/RoundIcon.png', fit: BoxFit.cover),
//                   ),
//             ),
//           ],
//         ),
//       ],
//       children: <Widget>[
//         TileLayerWidget(options: TileLayerOptions(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c']
//         )),
//         MarkerLayerWidget(options: MarkerLayerOptions(
//           markers: [
//             Marker(
//               width: 40.0,
//               height: 40.0,
//               point: latLng.LatLng(-35.28,149.13),
//               builder: (ctx) =>
//                   Container(
//                     child:Image.asset('../assets/RoundIcon.png', fit: BoxFit.cover),
//                   ),
//             ),
//           ],
//         )),
//       ],
//     );
//   }
//
// }

/*
Logo area
 */
class LogoArea extends StatelessWidget {
  const LogoArea({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
         // Image.asset('../assets/haizea.png', fit: BoxFit.cover),
        ],
      ),
      height: 68.0,
      width: double.infinity,
    );
  }
}



/*
Page information
 */
class PageInfo extends StatelessWidget {
  //const PageInfo({Key? key}) : super(key: key);

  String lastLoginTime;
  String username="";

  PageInfo(this.lastLoginTime) {
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Find somewhere new in ACT!",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
              color: Colors.white,
            )),
        Text(
          "Last login: " + lastLoginTime,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/**
 * X&Y axis Dropdown Menue
 */
class AxisDropDown extends StatefulWidget {
  const AxisDropDown({Key? key}) : super(key: key);

  @override
  State<AxisDropDown> createState() => _AxisDropDown();
}

class _AxisDropDown extends State<AxisDropDown> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
/**
 * Maps widget
 */
class MyMap extends StatefulWidget{
  @override
  State<MyMap> createState() => _MyMap();

}

class _MyMap extends State<MyMap> {
  late List<Model> data;
  late MapShapeSource _mapSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late String _selected;


  @override
  void initState() {
    _location.addListener(() =>_selected = _location.value);
    data = <Model>[
      Model('New South Wales', Color.fromRGBO(255, 215, 0, 1.0).withOpacity(0.5),
          '       New\nSouth Wales'),
      Model('Queensland', Color.fromRGBO(72, 209, 204, 1.0).withOpacity(0.5), 'Queensland'),
      Model('Northern Territory', Colors.red.withOpacity(0.5),
          'Northern\nTerritory'),
      Model('Victoria', Color.fromRGBO(171, 56, 224, 0.75).withOpacity(0.5), 'Victoria'),
      Model('South Australia', Color.fromRGBO(126, 247, 74, 0.75).withOpacity(0.5),
          'South Australia'),
      Model('Western Australia', Color.fromRGBO(79, 60, 201, 0.7).withOpacity(0.5),
          'Western Australia'),
      Model('Tasmania', Color.fromRGBO(99, 164, 230, 1).withOpacity(0.5), 'Tasmania'),
      Model('Australian Capital Territory', Colors.teal.withOpacity(0.5), 'ACT')
    ];
    _zoomPanBehavior = MapZoomPanBehavior(
        maxZoomLevel: 4.1,
        minZoomLevel: 4.1,
        focalLatLng: MapLatLng(-27.9, 133.417),
        enableDoubleTapZooming: false,
    );

    _mapSource = MapShapeSource.asset(
      'australia.json',
      shapeDataField: 'STATE_NAME',
      dataCount: data.length,
      primaryValueMapper: (int index) => data[index].state,
      dataLabelMapper: (int index) => data[index].stateCode,
      shapeColorValueMapper: (int index) => data[index].color,
    );
    super.initState();
  }

  // void _update(String selected) {
  //   _selected = selected;
  //   data = <Model>[Model(_selected,Color.fromRGBO(99, 164, 230, 1),_selected)];
  //   _mapSource = MapShapeSource.asset(
  //       'Location.json',
  //       shapeDataField: 'STATE_NAME',
  //       dataCount: data.length,
  //       primaryValueMapper: (int index) => data[index].state,
  //       dataLabelMapper: (int index) => data[index].stateCode,
  //       shapeColorValueMapper: (int index) => data[index].color,
  //   );
  //   setState(() {
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Stack(
      children: <Widget>[
        SfMaps(
          layers: <MapLayer>[
            MapTileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              zoomPanBehavior: _zoomPanBehavior,
              markerBuilder: (BuildContext context, int index){
                return MapMarker(
                  latitude:  -24.250,
                  longitude: 133.417,
                  alignment: Alignment.bottomCenter,);
              },
            ),
          ],
        ),
            SfMaps(
              layers: <MapShapeLayer>[
                MapShapeLayer(
                  source: _mapSource,
                  // legend: MapLegend(MapElement.shape),
                  showDataLabels: true,
                  shapeTooltipBuilder: (BuildContext context, int index) {
                      return Padding(
                      padding: EdgeInsets.all(data.length.toDouble()),
                      child: Text(data[index].stateCode,
                      style: themeData.textTheme.caption!.copyWith(color: themeData.colorScheme.surface)),
                      );
                  },
                  tooltipSettings: MapTooltipSettings(
                  color: Colors.grey[700],
                  strokeColor: Colors.white,
                  strokeWidth: 2),
                  strokeColor: Colors.white,
                  strokeWidth: 0.5,
                  dataLabelSettings: MapDataLabelSettings(
                  textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: themeData.textTheme.caption!.fontSize)),
                ),
              ],
            ),
      ],
    );
  }
}
class Model {
  Model(this.state, this.color, this.stateCode);

  String state;
  Color color;
  String stateCode;
}



