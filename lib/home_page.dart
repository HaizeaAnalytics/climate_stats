import 'package:climate_stats/authentication_service.dart';
import 'package:climate_stats/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String databaseName = "userInfo";
String userEmail = "";

class HomePage extends StatelessWidget {
  // const HomePage({Key? key}) : super(key: key);

  User userInfo;
  String lastLoginTime = "";

  List<String> favourites = [
    '12 Swanston Street, Joel Joel',
    '8 Lapko Road, Magtitup',
    '10 Downing Street, London'
  ];

  List<String> items = <String>[
    'Low',
    'Medium',
    'High',
  ];

  HomePage(this.userInfo) {

    userEmail = userInfo.email.toString();
    lastLoginTime = userInfo.metadata.lastSignInTime!.toLocal().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Home'),
      body: Container(
        child: Column(
          children: [
            LogoArea(),
            PageInfo(this.lastLoginTime),

            SizedBox(
              height: 10,
            ),

            /*************/
            Container(
              width: 500,
              height: 50,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    // labelText: "Finds somewhere new.",
                    // labelStyle: TextStyle(fontSize: 24),
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                ),
              ),
            ),

            const SizedBox(height: 10),
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
                  child: ListView.builder(
                    itemCount: favourites.length,
                    // itemExtent: 20.0,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(favourites[index]),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon:Icon(Icons.delete_forever),
                            onPressed: (){},
                          ),
                        ),
                      );
                    }
                  ),
                ),

                const SizedBox(width: 20),

                SizedBox(
                  width: 500,
                  height: 500,
                  child: FlutterMap(
                    options: MapOptions(
                      center: latLng.LatLng(-35.28,149.13),
                      zoom: 14.0,
                    ),
                    layers: [
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: latLng.LatLng(-35.28,149.13),
                            builder: (ctx) =>
                                Container(
                                  child:Image.asset('../assets/RoundIcon.png', fit: BoxFit.cover),
                                ),
                          ),
                        ],
                      ),
                    ],
                    children: <Widget>[
                      TileLayerWidget(options: TileLayerOptions(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c']
                      )),
                      MarkerLayerWidget(options: MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: latLng.LatLng(-35.28,149.13),
                            builder: (ctx) =>
                                Container(
                                  child:Image.asset('../assets/RoundIcon.png', fit: BoxFit.cover),
                                ),
                          ),
                        ],
                      )),
                    ],
                  ),
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

            const SizedBox(height: 50),
            /**
             *
             * Add button to pages for development, if the navigation bar has not been developed.
             */
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: const Text("Sign out"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(userInfo)),
                );
              },
              child: const Text("Profile Page"),
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
          Image.asset('../assets/haizea.png', fit: BoxFit.cover),
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
    FirebaseFirestore.instance
        .collection(databaseName)
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        username = documentSnapshot.get("firstname");
        print(username);
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Welcome to Haizea's ClimateStats! " + username,
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

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color.fromARGB(255, 242, 239, 241)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset(80, 1) & const Size(500, 500), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
