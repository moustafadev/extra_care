import 'package:flutter/rendering.dart';

class Constants{

  static bool isEnglish = false;

  static TextStyle fontLight({double fontSize = 16, Color color}){
    return TextStyle(fontFamily: '', fontSize: fontSize, color: color );
  }

  static TextStyle fontBold({double fontSize = 16, Color color}){
    return TextStyle(fontFamily: '', fontWeight: FontWeight.bold, fontSize: fontSize, color: color);
  }

  static TextStyle fontRegular({double fontSize = 16, Color color}){
    return TextStyle(fontFamily: '', fontSize: fontSize, color: color);
  }
  

  static Color buttonColor (){
    return Color.fromRGBO(55, 140, 202, 1);
  }

  static Color blueColor (){
    return Color.fromRGBO(66, 103, 178, 1);
  }

  static Color skyColor (){
    return Color.fromRGBO(67, 164, 219, 1);
  }

  static Color whiteColor (){
    return Color.fromRGBO(255, 255, 255, .36);
  }

  static Color textFieldColor (){
    return Color.fromRGBO(142, 142, 147, 0.12);
  }

  static Color hintColor (){
    return Color.fromRGBO(0, 0, 0, 0.5);
  }

  static Color shadowColor (){
    return Color.fromRGBO(0, 0, 0, 0.2);
  }

  static Color lightBlackColor (){
    return Color.fromRGBO(38, 38, 40, 1);
  }

  static Color greyColor (){
    return Color.fromRGBO(184, 187, 198, 1);
  }

  static Color greenColor (){
    return Color.fromRGBO(107, 179, 49, 1);
  }
  static Color lightgreenColor (){
    return Color.fromRGBO(107, 179, 49, .7);
  }

  static Color descriptionColor (){
    return Color.fromRGBO(155, 155, 155, 1);
  }

  static Color redColor (){
    return Color.fromRGBO(229, 51, 93, 1);
  }

  static Color starColor (){
    return Color.fromRGBO(255, 204, 0, 1);
  }

}