import 'dart:html';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// run command: flutter run --no-sound-null-safety to run this file

class DataPage extends StatelessWidget {
  const DataPage({Key? key}) : super(key:key);


// Layout of the data page
@override
  Widget build(BuildContext context) {
    return Scaffold(
        // Navigation bar area
        body: Container(
          child: Column(
            children: [
              LogoArea(),
              SearchBar(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Address(),
                Button(),
                VariableDropDown(),
                VariableDropDown()
              ]),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                LineChartWidget(),
              ],)
              
            ]
          ),         
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("../assets/background.jpg"),
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


// Search Bar
class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
              width: 400,
              height: 75,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    // labelText: "Finds somewhere new.",
                    // labelStyle: TextStyle(fontSize: 24),
                    hintText: "Search Address",
                    prefixIcon: Icon(Icons.search),
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
    return Container(
         width: 300,
         child: const Text("47 McGregor Street, Menindee",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ))
  
    );
  }
}


// Add to Favourites Button
class Button extends StatelessWidget{
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          print("Clicked");
        },
        child: const Text('Add to Favourties'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          textStyle: TextStyle(
         fontSize: 14,
        fontWeight: FontWeight.bold)),

        )
          

    );
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 4),
        color: Colors.blue
      ),

      child: DropdownButton<String>(
        value: value,
        iconSize: 36,
        icon: Icon (Icons.arrow_drop_down, color: Colors.black),
        isExpanded: true,
        dropdownColor: Colors.white,
        items: items.map(buildMenuItem).toList(),
        onChanged: (value) => setState (() => this.value = value),


      
    ),
    );
  }

DropdownMenuItem<String> buildMenuItem(String item) =>
  DropdownMenuItem(value: item,
  child: Text(
    item,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
      backgroundColor: Color(0xff23b636),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 5,
      titlesData: LineTitles.getTitleData(),
      gridData: FlGridData(
        show:true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1
          );
        },
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1
          );
        }

      ),
      borderData: FlBorderData(
        show:true,
        border: Border.all(color: const Color(0xff3743d), width: 1),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0,3),
            FlSpot(2.5,2),
            FlSpot(5,5),
            FlSpot(6.8,3),
            FlSpot(8,4),
            FlSpot(9.5,3),
            FlSpot(11,4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          belowBarData: BarAreaData(
            show:true,
            colors: gradientColors
            .map((color) => color.withOpacity(0.2)).toList(),
          )
        )
      ]

    ),


 ) );

}

class LineTitles {
  static getTitleData() => FlTitlesData(
    show:true,
    bottomTitles: SideTitles(
      showTitles: true,
      reservedSize: 22,
      getTextStyles: (value) => const TextStyle(
        color: Color(0xff68737d),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      getTitles: (value) {
        switch (value.toInt()){
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
        switch (value.toInt()){
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
      margin: 12


    )
  );
}