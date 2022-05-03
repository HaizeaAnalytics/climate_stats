import 'package:flutter/cupertino.dart';

class Globals {
  static String currentAddress = "O'Malley";
  static ValueNotifier<String> ssssadress = ValueNotifier<String>("O'Malley");

  static printInteger() {
    print(currentAddress);
    print(ssssadress.value);
  }

  static changeInteger(String a) {
    currentAddress = a;
    ssssadress = ValueNotifier<String>(a);
    printInteger(); // this can be replaced with any static method
  }

}