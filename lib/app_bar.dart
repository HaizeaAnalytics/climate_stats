import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:climate_stats/authentication_service.dart';
import 'package:provider/provider.dart';

double barHeight = 65.0;

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  User userInfo;

  /// TopAppBar({Key key}) : super(key: key);
  TopAppBar(this.title, this.userInfo) {}

  @override
  State<StatefulWidget> createState() {
    return _TopAppBar(title, userInfo);
  }

  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}

class _TopAppBar extends State<TopAppBar> {
  String title;
  User userInfo;

  _TopAppBar(this.title, this.userInfo) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      height: barHeight,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('../assets/background_blur_appbar.png'), fit:BoxFit.cover),
        border: Border(bottom: BorderSide(width: 1, color: Colors.white)),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)],
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 70.0),
            height: barHeight*.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userInfo)),);
                    },
                    icon: Image.asset('../assets/haizea.png', fit: BoxFit.cover),
                    label: Text(""),
                  )
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: _popupMenuButton(context, userInfo, title)
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
Pop Menu
 */
PopupMenuButton _popupMenuButton(
    BuildContext context, User userInfo, String titleText) {
  return PopupMenuButton(
    icon: Icon(Icons.menu, color: Colors.white),
    itemBuilder: (BuildContext context) {
      return [
        PopupMenuItem(
          value: "Home",
          child: SizedBox(
            width: 130,
            height: 50.0,
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  color: Colors.grey[700],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 05.0, top: 0.5),
                  child: const Text("Home"),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: "Profit",
          child: SizedBox(
            width: 130,
            height: 50.0,
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.grey[700],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 05.0, top: 0.5),
                  child: const Text("Profile"),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: "SignOut",
          child: SizedBox(
            width: 130,
            height: 50.0,
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.grey[700],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 05.0, top: 1.0),
                  child: const Text("Sign Out"),
                ),
              ],
            ),
          ),
        ),
      ];
    },
    onSelected: (object) {
      print("Top bar clicked: " + object);
      switch (object) {
        case "Home":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userInfo)),
          );
          break;
        case "Profit":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(userInfo)),
          );
          break;
        case "SignOut":
          context.read<AuthenticationService>().signOut();
          setState(){}
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
          
          break;
      }
    },
  );
}
