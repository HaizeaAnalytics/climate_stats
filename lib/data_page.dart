// ignore_for_file: avoid_print

import 'dart:math';

import 'package:fl_chart/fl_chart.dart'; // Outdated should not be used in null safe library
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_bar.dart';
import 'package:climate_stats/get_data.dart' as data;

// run command: flutter run --no-sound-null-safety to run this file
const String databaseName = "userInfo";
String userEmail = "";
String userUid = "";

// Vars for accepting input/ graphing
TextEditingController textController = TextEditingController();
List<double> dates = [0, 10];
List<double> values = [0, 10];

class DataPage extends StatelessWidget {
  // const DataPage({Key? key}) : super(key:key);
  User userInfo;
  String lastLoginTime = "";

  DataPage(this.userInfo, {Key? key}) : super(key: key) {
    userUid = userInfo.uid.toString();
    userEmail = userInfo.email.toString();
    lastLoginTime = userInfo.metadata.lastSignInTime!.toLocal().toString();
  }

  // Layout of the data page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar("Visualisation", userInfo),
        body: Container(
          child: Column(children: [
            // LogoArea(),
            const SizedBox(
              height: 80,
            ),
            const SearchBar(),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const Address(),
              SubmitButton(),
              const Button(),
              const VariableDropDown(),
              const VariableDropDown()
            ]),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LineChartWidget(),
              ],
            )
          ]),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("../assets/background_blur.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}

// Hazeia Logo
class LogoArea extends StatelessWidget {
  const LogoArea({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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

// Search Bar
class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 75,
      child: TextField(
        autofocus: true,
        controller: textController,
        decoration: InputDecoration(
          // labelStyle: TextStyle(fontSize: 24),
          hintText: "Search Address",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
        ),
      ),
    );
  }
}

//Address Text
class Address extends StatelessWidget {
  const Address({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: Text("47 McGregor Street, Menindee",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
            )));
  }
}

// Add to Favourites Button
class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            CollectionReference user =
                FirebaseFirestore.instance.collection(databaseName);
            user.doc(userUid).update({
              'favourites': FieldValue.arrayUnion(["testlocation"])
            });
          },
          child: const Text('Add to Favourties'),
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ));
  }
}

// TEST
// Test submit button to demonstrate API functionality
// Submit Button
class SubmitButton extends StatelessWidget {
  SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            // Get the contents of the search bar
            // Trimmed to remove trailing or leading whitespace
            String address = textController.text.trim();

            // If address provided, get data
            if (address.isNotEmpty) {
              // Step 1: Get the polygon coordinates from address
              final coordinates = await data.getPolygon(address);
              // Step 2: Get the time series (tree data) using coordinates
              if (coordinates != null) {
                final treeData = await data.getTreeData(coordinates);
                //var splitdata = await data.split(treeData!);
                //final list = await data.toList(treeData);
                dates = treeData![0];
                values = treeData[1];
                // Print the values to the console (for testing/ demo purposes)
                print(dates);
                print(values);
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => const AlertDialog(
                          title: Text('Data Not Found'),
                          content: Text(
                              'No matching data was found for that address.\nPlease check the spelling and try again.'),
                        ));
              }
              // Step 3: Make graph using time series data
              build(context);
            }

            // If no address provided, prompt user
            else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const AlertDialog(
                        title: Text('No address provided'),
                        content: Text('Please enter an ACT street address.'),
                      ));
            }
          },
          child: const Icon(Icons.send),
        ));
  }
}

class VariableDropDown extends StatefulWidget {
  const VariableDropDown({Key? key}) : super(key: key);

  @override
  State<VariableDropDown> createState() => _VariableDropDown();
}

// Axis Variable Dropdown Menus
class _VariableDropDown extends State<VariableDropDown> {
  final items = ['Apple', 'Orange', 'Banana', 'Pear'];
  String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 4),
          color: Colors.blue),
      child: DropdownButton<String>(
        value: value,
        iconSize: 36,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        isExpanded: true,
        dropdownColor: Colors.white,
        items: items.map(buildMenuItem).toList(),
        onChanged: (value) => setState(() => this.value = value),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}

// Line Chart Graph
class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b636),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 500,
      height: 500,
      child: LineChart(
        LineChartData(
            backgroundColor: const Color(0xff23b636),

            // Set Max and Min from dates, values
            // Need null checking
            minX: (dates).reduce(min),
            maxX: (dates).reduce(max),
            minY: (values).reduce(min),
            maxY: (values).reduce(max),

            // Set the other chart parameters
            titlesData: LineTitles.getTitleData(),
            gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
                },
                drawVerticalLine: true,
                getDrawingVerticalLine: (value) {
                  return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
                }),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff3743d), width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                  spots: [
                    FlSpot(0, 3),
                    FlSpot(2.5, 2),
                    FlSpot(5, 5),
                    FlSpot(6.8, 3),
                    FlSpot(8, 4),
                    FlSpot(9.5, 3),
                    FlSpot(11, 4),
                  ],
                  isCurved: true,
                  colors: gradientColors,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.2))
                        .toList(),
                  ))
            ]),
      ));
}

class LineTitles {
  static getTitleData() => FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff68737d),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return 'Jan';
            case 1:
              return 'Feb';
            case 2:
              return 'Mar';
            case 3:
              return 'Apr';
            case 4:
              return 'May';
            case 5:
              return 'Jun';
            case 6:
              return 'Jul';
            case 7:
              return 'Aug';
            case 8:
              return 'Sept';
            case 9:
              return 'Oct';
            case 10:
              return 'Nov';
            case 11:
              return 'Dec';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0%';
              case 1:
                return '20%';
              case 2:
                return '40%';
              case 3:
                return '60%';
              case 4:
                return '80%';
              case 5:
                return '100%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12));
}
