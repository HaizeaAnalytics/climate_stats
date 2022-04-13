import 'package:climate_stats/authentication_service.dart';
import 'package:climate_stats/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);
  User userInfo;
  HomePage(this.userInfo) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Home'),
      body: Center(
        child: Column(
          children: [
            const Text("HOME"),
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
      ),
    );
  }
}
