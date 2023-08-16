import 'dart:convert';

class Utilities {
   static List<int> stringToByteArray(String input) {
    List<int> byteArray = utf8.encode(input);
    return byteArray;
  }
}