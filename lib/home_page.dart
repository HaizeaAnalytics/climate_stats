import 'package:climate_stats/authentication_service.dart';
import 'package:climate_stats/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String databaseName = "userInfo";
String userEmail = "";

class HomePage extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);
  User userInfo;
  String lastLoginTime = "";

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
            /*************/

            Row(
              children: [
                // Todo: finding region and favourite history

                Container(
                  width: 600,
                  height: 600,
                  child: CustomPaint(
                    painter: OpenPainter(),
                  ),
                ),

                // Todu: map conponent
                Container(
                  width: 600,
                  height: 600,
                  child: CustomPaint(
                    painter: OpenPainter(),
                  ),
                ),
              ],
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
  String username = "";

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
    return Container(
      child: Column(
        children: [
          Text("Welcome, " + username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 54.0,
                color: Colors.white,
              )),
          Text(
            "Last login: " + lastLoginTime,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
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
