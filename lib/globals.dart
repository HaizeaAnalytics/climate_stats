import 'package:flutter/cupertino.dart';

class Globals {
  static String defaultAddress = "O'Malley";
  static ValueNotifier<String> globalAddress = ValueNotifier<String>("O'Malley");

  static printValue() {
    print(defaultAddress);
    print(globalAddress.value);
  }

  static changeValue(String a) {
    defaultAddress = a;
    globalAddress = ValueNotifier<String>(a);
    printValue();
  }

}