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

            /*************/
            Container(
              width: 500,
              height: 50,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Finds somewhere new.",
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
                SizedBox(width: 400,),
                Text("Maps",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                ),
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
                      zoom: 16.0,
                    ),
                    layers: [
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 20.0,
                            height: 20.0,
                            point: latLng.LatLng(-35.28,149.13),
                            builder: (ctx) =>
                                Container(
                                  child: FlutterLogo(),
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
                            width: 20.0,
                            height: 20.0,
                            point: latLng.LatLng(-35.28,149.13),
                            builder: (ctx) =>
                                Container(
                                  child: FlutterLogo(),
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
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(this.userInfo)),
                );
              },
              child: const Text("Profile Page"),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
      ),
    );
  }
}

// /**
//  * Favourite list
//  */
// class FavList extends StatelessWidget{
//   const FavList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: 100,
//       itemExtent: 30,
//       itemBuilder: ,
//     );
//   }
// }

// /*
// Logo area
//  */
// class LogoArea extends StatelessWidget {
//   const LogoArea({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Image.asset('../assets/haizea.png', fit: BoxFit.cover),
//         ],
//       ),
//       height: 68.0,
//       width: double.infinity,
//     );
//   }
// }

// /*
// Page information
//  */
// class PageInfo extends StatelessWidget {
//   //const PageInfo({Key? key}) : super(key: key);
//
//   String lastLoginTime;
//   String username = "";
//
//   PageInfo(this.lastLoginTime) {
//     FirebaseFirestore.instance
//         .collection(databaseName)
//         .doc(userEmail)
//         .get()
//         .then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         username = documentSnapshot.get("firstname");
//         print(username);
//       } else {
//         print('Document does not exist on the database');
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Text("Welcome, " + username,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 54.0,
//                 color: Colors.white,
//               )),
//           Text(
//             "Last login: " + lastLoginTime,
//             style: const TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
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
